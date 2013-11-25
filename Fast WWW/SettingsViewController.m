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

// Private properties
@property (strong, nonatomic) IBOutlet UIImageView *serverImageView;    // Image view for holding infinite animation
@property (strong, nonatomic) IBOutlet UILabel *connectionsLabel;       // Lable diplaying a number of connected computers to server

@end

@implementation SettingsViewController
{
    // Declaration of private instance variables
    HTTPServer *server;
    UInt16 port;
    int numberOfConnections;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Chcking whether we are using a GSM or WiFi
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus netStat = [reach currentReachabilityStatus];
    
    // If WiFi we're updating labels properly
    if (netStat == ReachableViaWiFi) {
        [self.IPAddressLabel setText:@"Turn on iOS server"];
    } else {
        [self.IPAddressLabel setText:@"Please turn on WiFi"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setting table view backgroud to be white
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    // Initializing number of connections
    numberOfConnections = 0;
    // Setting default port
    port = 8080;
    // Initializing server
    server = [[HTTPServer alloc] init];
    // Setting up the server
    [self setupHTTPServer:server];
    // Loading animation frames into image view
    [self loadAnimationImagesToArray];
    
    // Setting notification center to observe connected hosts
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Added connection"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Removed connection"
                                               object:nil];
    
    // Adding swipe gesture to hide keyboard when is not needed anymore
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:recognizer];
}

- (IBAction)saveNewPort:(UITextField *)sender
{
    // Setting proper port from text field
    // Default is 8080
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
        [self.serverImageView stopAnimating];
    } else {
        if ([self fireUpServer]) {
            [self.IPAddressLabel setText:[NSString stringWithFormat:@"%@:%u", [self getIPAddress], port]];
            [self.serverImageView startAnimating];
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
    // Setting up necessary info for server to start
    [serv setType:@"_http._tcp."];
    [serv setPort:port];
    [serv setDocumentRoot:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Web"]];
}

#pragma mark - Swipe gesture

- (void)dismissKeyboard
{
    [self.portTextField resignFirstResponder];
}

#pragma mark - Notifications

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"Added connection"]) {
        ++numberOfConnections;
        [self.connectionsLabel setText:[NSString stringWithFormat:@"%i", numberOfConnections]];
        // NSLog(@"Number of connections: %i", numberOfConnections);
    } else if ([notification.name isEqualToString:@"Removed connection"]) {
        --numberOfConnections;
        [self.connectionsLabel setText:[NSString stringWithFormat:@"%i", numberOfConnections]];
        // NSLog(@"Number of connections: %i", numberOfConnections);
    }
}

#pragma mark - Documents directory

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Loading animation

- (void)loadAnimationImagesToArray
{
    NSArray *animationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"frame1.png"],
                                                        [UIImage imageNamed:@"frame2.png"],
                                                        [UIImage imageNamed:@"frame3.png"],
                                                        [UIImage imageNamed:@"frame4.png"],
                                                        [UIImage imageNamed:@"frame5.png"],
                                                        [UIImage imageNamed:@"frame6.png"],
                                                        [UIImage imageNamed:@"frame7.png"],
                                                        [UIImage imageNamed:@"frame8.png"],
                                                        [UIImage imageNamed:@"frame9.png"],
                                                        [UIImage imageNamed:@"frame10.png"],
                                                        [UIImage imageNamed:@"frame11.png"],
                                                        [UIImage imageNamed:@"frame12.png"],
                                                        [UIImage imageNamed:@"frame13.png"],
                                                        [UIImage imageNamed:@"frame14.png"],
                                                        [UIImage imageNamed:@"frame15.png"],
                                                        [UIImage imageNamed:@"frame16.png"],
                                                        [UIImage imageNamed:@"frame17.png"],
                                                        [UIImage imageNamed:@"frame18.png"],
                                                        [UIImage imageNamed:@"frame19.png"],
                                                        [UIImage imageNamed:@"frame20.png"],
                                                        [UIImage imageNamed:@"frame21.png"],
                                                        [UIImage imageNamed:@"frame22.png"],
                                                        [UIImage imageNamed:@"frame23.png"],
                                                        [UIImage imageNamed:@"frame24.png"],
                                                        [UIImage imageNamed:@"frame25.png"], nil];
    [self.serverImageView setAnimationImages:animationArray];
}

@end