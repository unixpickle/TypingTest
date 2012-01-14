//
//  EnterTextWindow.h
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class EnterTextWindow;

@protocol EnterTextWindowDelegate <NSObject>

@optional
- (void)enterTextWindowEnteredText:(EnterTextWindow *)window;

@end

@interface EnterTextWindow : NSWindow {
    NSButton * doneButton;
    NSButton * cancelButton;
    NSTextView * textView;
    __weak id<EnterTextWindowDelegate> delegate;
}

@property (nonatomic, weak) id<EnterTextWindowDelegate> delegate;

- (id)initWithSize:(NSSize)size initialText:(NSString *)text;
- (void)donePressed:(id)sender;
- (void)cancelPressed:(id)sender;

- (NSString *)userText;

@end
