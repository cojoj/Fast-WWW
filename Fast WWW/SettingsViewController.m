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

@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.IPAddressLabel setText:[self getIPAddress]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Obtaining IP adress

- (NSString *)getIPAddress {
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

@end
