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
#import "Reachability.h"

@interface SettingsViewController ()
{
    HTTPServer *server;
    UInt16 port;
}
@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus netStat = [reach currentReachabilityStatus];
    
    if (netStat == ReachableViaWiFi) {
        [self.IPAddressLabel setText:@"Turn on iOS server"];
    } else {
        [self.IPAddressLabel setText:@"Please turn on WiFi"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    port = 8080;
    server = [[HTTPServer alloc] init];
    [self setupHTTPServer:server];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)saveNewPort:(UITextField *)sender
{
    if (![self.portTextField.text isEqualToString:@""]) {
        port = [sender.text intValue];
    } else {
        port = 8080;
    }
}

- (IBAction)setServerMode:(UISwitch *)sender
{
    if (![sender isOn]) {
        if ([server isRunning]) {
            [server stop];
            NSLog(@"Server was turned off!");
            [self.IPAddressLabel setText:@"Turn on iOS server"];
        }
    } else {
        if ([self fireUpServer]) {
            [self.IPAddressLabel setText:[NSString stringWithFormat:@"%@:%u", [self getIPAddress], port]];
        }
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

#pragma mark - Setting server

- (BOOL)fireUpServer
{
    NSError *error;
	if([server start:&error] && ![[self getIPAddress] isEqualToString:@"error"]) {
		NSLog(@"Started HTTP Server on port %hu", [server listeningPort]);
        return TRUE;
	} else {
		NSLog(@"Error starting HTTP Server: %@", error);
        [self.IPAddressLabel setText:@"Please turn on WiFi"];
        [server stop];
        [self.serverModeSwitch setOn:NO animated:YES];
        return FALSE;
	}
}

- (void)setupHTTPServer:(HTTPServer *)serv
{
    [serv setType:@"_http._tcp."];
    [serv setPort:port];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    [serv setDocumentRoot:webPath];
}

#pragma mark - Tap gesture

- (void)dismissKeyboard
{
    [self.portTextField resignFirstResponder];
}

@end