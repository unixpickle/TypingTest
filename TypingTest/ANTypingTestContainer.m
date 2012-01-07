//
//  ANTypingTestContainer.m
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANTypingTestContainer.h"

@implementation ANTypingTestContainer

@synthesize testView;

- (id)initWithFrame:(NSRect)aRect typingTestView:(ANTypingTestView *)aTestView {
    if ((self = [super initWithFrame:aRect])) {
        [aTestView setDelegate:self];
        [aTestView setFrame:NSMakeRect(0, 0, aRect.size.width, aRect.size.height)];
        CGFloat height = [aTestView typingTestRequiredHeight];
        NSRect newFrame = NSMakeRect(0, 0, aRect.size.width, height);
        [aTestView setFrame:newFrame];
        
        clipView = [[NSClipView alloc] initWithFrame:newFrame];
        [clipView setDocumentView:aTestView];
        
        [self setContentView:clipView];
        [self setHasHorizontalScroller:NO];
        [self setHasVerticalScroller:YES];
        
        testView = aTestView;
    }
    return self;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return YES;
}

- (void)typingTestView:(ANTypingTestView *)testView scrollToRect:(CGRect)visibleRect {
    NSRect newContent = NSMakeRect(0,
                                   visibleRect.origin.y - (self.frame.size.height - visibleRect.size.height)
                                   , self.frame.size.width, self.frame.size.height);
    if (newContent.origin.y < 0) newContent.origin.y = 0;
    [self.contentView scrollRectToVisible:newContent];
}

- (void)keyDown:(NSEvent *)theEvent {
    [testView keyDown:theEvent];
}

@end
