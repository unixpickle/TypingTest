//
//  EnterTextWindow.h
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface EnterTextWindow : NSWindow {
    NSButton * doneButton;
    NSTextView * textView;
}

- (id)initWithSize:(NSSize)size initialText:(NSString *)text;
- (void)donePressed:(id)sender;

@end
