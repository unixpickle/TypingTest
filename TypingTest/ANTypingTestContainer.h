//
//  ANTypingTestContainer.h
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ANTypingTestView.h"

@interface ANTypingTestContainer : NSScrollView <ANTypingTestViewDelegate> {
    ANTypingTestView * testView;
    NSClipView * clipView;
}

@property (readonly) ANTypingTestView * testView;

- (id)initWithFrame:(NSRect)aRect typingTestView:(ANTypingTestView *)aTestView;
- (void)redrawStuff;

@end
