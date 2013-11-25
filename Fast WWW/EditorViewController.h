//
//  EditorViewController.h
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *webisteTextView; // Text view which holds website content

// Action which is saving the source to the index.html stored inside Documents
- (IBAction)savePage:(UIButton *)sender;
// Loading sample HTML source from main bundle
- (IBAction)loadSampleHTML:(UIButton *)sender;

@end
