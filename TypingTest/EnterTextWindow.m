//
//  EnterTextWindow.m
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterTextWindow.h"

@implementation EnterTextWindow

@synthesize delegate;

- (id)initWithSize:(NSSize)size initialText:(NSString *)text {
    if ((self = [super initWithContentRect:NSMakeRect(0, 0, size.width, size.height) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO])) {
        
        textView = [[NSTextView alloc] initWithFrame:NSMakeRect(10, 44, size.width - 20, size.height - 54)];
        [textView setString:text];
        
        NSScrollView * scrollview = [[NSScrollView alloc] initWithFrame:textView.frame];
        // NSSize contentSize = [scrollview contentSize];
        
        [scrollview setBorderType:NSNoBorder];
        [scrollview setHasVerticalScroller:YES];
        [scrollview setHasHorizontalScroller:NO];
        [scrollview setDocumentView:textView];
        
        doneButton = [[NSButton alloc] initWithFrame:NSMakeRect(size.width - 90, 10, 80, 24)];
        [doneButton setBezelStyle:NSRoundedBezelStyle];
        [doneButton setTitle:@"Done"];
        [doneButton setTarget:self];
        [doneButton setAction:@selector(donePressed:)];
        
        cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(size.width - 170, 10, 80, 24)];
        [cancelButton setBezelStyle:NSRoundedBezelStyle];
        [cancelButton setTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(cancelPressed:)];
        
        [self.contentView addSubview:scrollview];
        [self.contentView addSubview:doneButton];
        [self.contentView addSubview:cancelButton];
        
        [self setDefaultButtonCell:doneButton.cell];
    }
    return self;
}

- (void)donePressed:(id)sender {
    [NSApp stopModal];
    [delegate enterTextWindowEnteredText:self];
}

- (void)cancelPressed:(id)sender {
    [NSApp stopModal];
}

- (NSString *)userText {
    return [textView string];
}

@end
