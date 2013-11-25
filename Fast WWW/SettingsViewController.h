//
//  SettingsViewController.h
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

// ---------------------------------
// List of public properties
// ---------------------------------
@property (strong, nonatomic) IBOutlet UITextField *portTextField;  // Text field for port
@property (strong, nonatomic) IBOutlet UILabel *IPAddressLabel;     // Lable showing IP address and port on which server is running
@property (strong, nonatomic) IBOutlet UISwitch *serverModeSwitch;  // Switch for turning ON and OFF the server

// ---------------------------------
// Public methods
// ---------------------------------
// Action for saving the port from text field and assigning it to the server settings
- (IBAction)saveNewPort:(UITextField *)sender;
// Action for setting server ON and OFF
- (IBAction)setServerMode:(UISwitch *)sender;

@end
