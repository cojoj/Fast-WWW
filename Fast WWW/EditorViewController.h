//
//  EditorViewController.h
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *webisteTextView;
- (IBAction)savePage:(UIButton *)sender;
- (IBAction)loadSampleHTML:(UIButton *)sender;

@end
