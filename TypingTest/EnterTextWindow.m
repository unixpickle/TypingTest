//
//  EnterTextWindow.m
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterTextWindow.h"

@implementation EnterTextWindow

- (id)initWithSize:(NSSize)size initialText:(NSString *)text {
    if ((self = [super initWithContentRect:NSMakeRect(0, 0, size.width, size.height) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO])) {
        
        textView = [[NSTextView alloc] initWithFrame:NSMakeRect(10, 44, size.width - 20, size.height - 54)];
        [textView setString:text];
        
        doneButton = [[NSButton alloc] initWithFrame:NSMakeRect(size.width - 90, 10, 80, 24)];
        [doneButton setBezelStyle:NSRoundedBezelStyle];
        
        [self.contentView addSubview:textView];
        [self.contentView addSubview:doneButton];
    }
    return self;
}

- (void)donePressed:(id)sender {
    NSLog(@"Done");
}

@end
