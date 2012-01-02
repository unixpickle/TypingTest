//
//  ANTypingTestView.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANTypingTest.h"

@interface ANTypingTestView : NSView {
    ANTypingTest * typingTest;
    CFMutableAttributedStringRef testString;
    
    CGColorRef defaultColor;
    CGColorRef wrongColor;
    CGColorRef typedColor;
}

- (id)initWithFrame:(NSRect)aFrame typingTest:(ANTypingTest *)theTest;

- (void)setLetterState:(ANTypingTestLetterState)state forLetter:(NSUInteger)index;
- (CGRect)drawTestText:(CGContextRef)context;

@end
