//
//  EditorViewController.m
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *websiteContent = [NSString stringWithContentsOfFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Web/index.html"] encoding:NSUTF8StringEncoding error:nil];
    [self.webisteTextView setText:websiteContent];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)savePage:(UIButton *)sender
{
}

#pragma mark - Tap gesture

- (void)dismissKeyboard
{
    [self.webisteTextView resignFirstResponder];
}

#pragma mark - Documents directory

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
