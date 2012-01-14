//
//  ANTypingTestView.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANTypingTest.h"
#import "CFAttributedStringHeight.h"
#import "ANTextFrame.h"

#define kTextSidePadding 6
#define kTextTopPadding 10
#define kCursorHeight 14

@class ANTypingTestView;

@protocol ANTypingTestViewUIDelegate <NSObject>

@optional
- (void)typingTestView:(ANTypingTestView *)testView scrollToRect:(CGRect)visibleRect;

@end

@protocol ANTypingTestViewDelegate <NSObject>

@optional
- (void)typingTestViewTestBegan:(ANTypingTestView *)testView;
- (void)typingTestViewTestCompleted:(ANTypingTestView *)testView;
- (void)typingTestViewUpdated:(ANTypingTestView *)testView;

@end

@interface ANTypingTestView : NSView {
    ANTypingTest * typingTest;
    CFMutableAttributedStringRef testString;
    
    CGColorRef defaultColor;
    CGColorRef wrongColor;
    CGColorRef typedColor;
    
    CGRect currentScrollRect;
    
    __weak id<ANTypingTestViewUIDelegate> graphicsDelegate;
    __weak id<ANTypingTestViewDelegate> delegate;
}

@property (nonatomic, weak) id<ANTypingTestViewUIDelegate> graphicsDelegate;
@property (nonatomic, weak) __weak id<ANTypingTestViewDelegate> delegate;
@property (readonly) ANTypingTest * typingTest;
@property (readonly) CGRect currentScrollRect;

- (id)initWithFrame:(NSRect)aFrame typingTest:(ANTypingTest *)theTest;
- (CGFloat)typingTestRequiredHeight:(CGFloat)width;

- (void)setLetterState:(ANTypingTestLetterState)state forLetter:(NSUInteger)index;

- (CGRect)drawTestText:(CGContextRef)context;
- (CGRect)drawTestTextLines:(ANTextFrame *)frame context:(CGContextRef)context;

@end
