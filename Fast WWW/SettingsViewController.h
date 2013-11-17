//
//  SettingsViewController.h
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *portTextField;
@property (strong, nonatomic) IBOutlet UILabel *IPAddressLabel;
@property (strong, nonatomic) IBOutlet UISwitch *serverModeSwitch;
- (IBAction)saveNewPort:(UITextField *)sender;
- (IBAction)setServerMode:(UISwitch *)sender;


@end
