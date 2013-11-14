//
//  SettingsViewController.m
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import "SettingsViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <HTTPServer.h>

@interface SettingsViewController ()
{
    HTTPServer *server;
    UInt16 port;
}
@end

@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    server = [[HTTPServer alloc] init];
    
    if ([[self getIPAddress] isEqualToString:@"error"]) {
        [self.infoLabel setText:@"You can't broadcast through GSM"];
        [self.IPAddressLabel setText:@"Turn on WiFi!"];
    } else {
        [self.infoLabel setText:@"You are broadcating on:"];
        [self.IPAddressLabel setText:[NSString stringWithFormat:@"%@:%@", [self getIPAddress], self.portTextField.text ? self.portTextField.text : @"8080"]];
    }
}

- (IBAction)setServerMode:(UISwitch *)sender
{
    if (![sender isOn]) {
        if ([server isRunning]) {
            [server stop];
            NSLog(@"Server was turned off!");
        }
    } else {
        [self fireUpServer];
    }
}

#pragma mark - Obtaining IP adress

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

#pragma mark - Server setting

- (void)fireUpServer
{
    NSError *error;
	if([server start:&error]) {
		NSLog(@"Started HTTP Server on port %hu", [server listeningPort]);
	}
	else {
		NSLog(@"Error starting HTTP Server: %@", error);
	}
}

@end
