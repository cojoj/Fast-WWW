//
//  EditorViewController.m
//  Fast WWW
//
//  Created by Mateusz Zając on 13.11.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import "EditorViewController.h"

#define TEXT_VIEV_Y_POSITION 58

@interface EditorViewController ()

@end

@implementation EditorViewController
{
    NSFileManager *manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *websiteContent = [NSString stringWithContentsOfFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Web/index.html"] encoding:NSUTF8StringEncoding error:nil];
    [self.webisteTextView setText:websiteContent];
    
    [self addKeyboardObservers];
}

- (IBAction)savePage:(UIButton *)sender
{
    [self.webisteTextView.text writeToFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Web/index.html"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - Documents directory

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Keyboard methods

- (void)addKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.webisteTextView.frame = CGRectMake(0, TEXT_VIEV_Y_POSITION, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.webisteTextView.frame = CGRectMake(0, TEXT_VIEV_Y_POSITION, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)dismissKeyboard
{
    [self.webisteTextView resignFirstResponder];
}

@end
