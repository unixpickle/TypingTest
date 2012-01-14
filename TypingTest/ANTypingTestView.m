//
//  ANTypingTestView.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANTypingTestView.h"

@implementation ANTypingTestView

@synthesize graphicsDelegate;
@synthesize delegate;
@synthesize typingTest;
@synthesize currentScrollRect;

- (id)initWithFrame:(NSRect)aFrame typingTest:(ANTypingTest *)theTest {
    if ((self = [super initWithFrame:aFrame])) {
        typingTest = theTest;
        
        testString = CFAttributedStringCreateMutable(NULL, 0);
        for (NSUInteger i = 0; i < [typingTest.letters count]; i++) {
            ANTypingTestLetter * letter = [typingTest.letters objectAtIndex:i];
            char chars[2] = {(char)[letter letter], 0};
            CFStringRef string = CFStringCreateWithCString(NULL, chars, CFStringGetSystemEncoding());
            CFAttributedStringReplaceString(testString, CFRangeMake(i, 0), string);
            CFRelease(string);
        }
        
        // set the string's font
        CTFontRef font = CTFontCreateWithName(CFSTR("Menlo"), 14, NULL);
        CFAttributedStringSetAttribute(testString, CFRangeMake(0, [typingTest.letters count]), kCTFontAttributeName, font);
        CFRelease(font);
        
        // set the string's colors
        defaultColor = CGColorCreateGenericRGB(0.5, 0.5, 0.5, 1);
        wrongColor = CGColorCreateGenericRGB(1, 0, 0, 1);
        typedColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        
        CFAttributedStringSetAttribute(testString, CFRangeMake(0, [typingTest.letters count]), kCTForegroundColorAttributeName, defaultColor);
                
        // set the string's line spacing and line break
        CGFloat lineSpacing = 12;
        CTLineBreakMode breakMode = kCTLineBreakByWordWrapping;
        
        struct CTParagraphStyleSetting spacingSetting;
        spacingSetting.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        spacingSetting.valueSize = sizeof(CGFloat);
        spacingSetting.value = &lineSpacing;
        
        struct CTParagraphStyleSetting breakSetting;
        breakSetting.spec = kCTParagraphStyleSpecifierLineBreakMode;
        breakSetting.valueSize = sizeof(breakMode);
        breakSetting.value = &breakMode;
        struct CTParagraphStyleSetting settings[2] = {
            spacingSetting, breakSetting
        };
        
        CTParagraphStyleRef pStyle = CTParagraphStyleCreate(settings, 2);
        CFAttributedStringSetAttribute(testString, CFRangeMake(0, [typingTest.letters count]), kCTParagraphStyleAttributeName, pStyle);
        CFRetain(pStyle);
        
        // initial character states
        for (NSUInteger i = 0; i < [[theTest letters] count]; i++) {
            ANTypingTestLetter * letter = [[theTest letters] objectAtIndex:i];
            if ([letter state] != ANTypingTestLetterStateDefault) {
                [self setLetterState:[letter state] forLetter:i];
            }
        }
    }
    return self;
}

- (CGFloat)typingTestRequiredHeight:(CGFloat)width {
    return CFAttributedStringDrawHeight(testString, width - (kTextSidePadding * 2),
                                        (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort]) + kTextTopPadding * 2 + 5;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

#pragma mark - Test -

- (void)keyDown:(NSEvent *)theEvent {
    if ([typingTest isFinishedTest]) return;
    if (![typingTest currentPeriod]) {
        [typingTest startPeriod];
        if ([delegate respondsToSelector:@selector(typingTestViewTestBegan:)]) {
            [delegate typingTestViewTestBegan:self];
        }
    }
    
    NSString * chars = [theEvent characters];
    
    // 51 = backspace
    if ([theEvent keyCode] == 51) {
        if ([typingTest currentLetter] == 0) {
            NSBeep();
            return;
        }
        [typingTest deleteLastChar];
        [self setLetterState:ANTypingTestLetterStateDefault
                   forLetter:[typingTest currentLetter]];
        return;
    }
    
    unichar theChar = 0;
    if ([theEvent keyCode] == 36) {
        theChar = '\n';
    } else {
        if ([chars length] != 1) return;
        theChar = [chars characterAtIndex:0];
    }
    
    NSUInteger currentChar = typingTest.currentLetter;
    [typingTest charTyped:theChar];
    
    for (NSUInteger i = currentChar; i < typingTest.currentLetter; i++) {
        ANTypingTestLetter * aLetter = [[typingTest letters] objectAtIndex:i];
        [self setLetterState:aLetter.state
                   forLetter:i];
    }
    
    if ([typingTest isFinishedTest]) {
        [typingTest endPeriod];
        if ([delegate respondsToSelector:@selector(typingTestViewTestCompleted:)]) {
            [delegate typingTestViewTestCompleted:self];
        }
    }
}

- (void)setLetterState:(ANTypingTestLetterState)state forLetter:(NSUInteger)index {
    CGColorRef color = defaultColor;
    
    switch (state) {
        case ANTypingTestLetterStateCorrect:
            color = typedColor;
            break;
        case ANTypingTestLetterStateIncorrect:
            color = wrongColor;
            break;
        default:
            break;
    }
    
    CFAttributedStringSetAttribute(testString, CFRangeMake(index, 1), kCTForegroundColorAttributeName, color);
    [self setNeedsDisplay:YES];
}

#pragma mark - Drawing -

- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextClearRect(context, self.bounds);
    CGRect newScrollRect = [self drawTestText:context];
    if (!CGRectEqualToRect(newScrollRect, currentScrollRect)) {
        currentScrollRect = newScrollRect;
        if ([graphicsDelegate respondsToSelector:@selector(typingTestView:scrollToRect:)]) {
            [graphicsDelegate typingTestView:self scrollToRect:newScrollRect];
        }
    }
}

- (CGRect)drawTestText:(CGContextRef)context {
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, self.bounds);
    
    NSRect boundsRect = NSMakeRect(kTextSidePadding, kTextTopPadding,
                                   self.frame.size.width - (kTextSidePadding * 2),
                                   self.frame.size.height - (kTextTopPadding * 2));
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, boundsRect);
    
    ANTextFrame * frame = [[ANTextFrame alloc] initWithAttributedString:testString
                                                                context:context path:path];
    
    CGPathRelease(path);
    
    // draw the text
    CGContextSetTextPosition(context, 0, 0);
    [frame draw];
    
    CGRect scrollRect = [self drawTestTextLines:frame context:context];    
    return scrollRect;
}

- (CGRect)drawTestTextLines:(ANTextFrame *)frame context:(CGContextRef)context {    
    // get line info
    NSArray * lines = [frame lines];
    
    CGRect scrollRect = CGRectZero;
    for (NSUInteger i = 0; i < [lines count]; i++) {
        ANTextLine * line = [lines objectAtIndex:i];
        CGRect rect = [line boundingRect];
                
        // special things need to be done for the current line
        NSUInteger currentLetter = typingTest.currentLetter;
        if ([line containsCharacterIndex:currentLetter]) {
            // get the frame of the current line
            scrollRect = rect;
            scrollRect.origin.y -= 6;
            scrollRect.size.height += 6;
            if (scrollRect.origin.y < 0) scrollRect.origin.y = 0;
            
            // draw the cursor
            CGFloat offset = [line offsetOfCharacter:currentLetter];
            CGPoint topPoint = CGPointMake(offset, rect.origin.y - 1);
            CGPoint bottomPoint = CGPointMake(offset, rect.origin.y + kCursorHeight + 1);
            
            // stroke points
            CGPoint points[2] = {topPoint, bottomPoint};
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
            CGContextStrokeLineSegments(context, points, 2);
        }
        
        // draw line separator
        if (i + 1 < [lines count] && [line boundingRect].size.height > 0) {
            CGPoint lineStart = CGPointMake(3, round(CGRectGetMinY(rect)) - 8);
            CGPoint lineEnd = CGPointMake(self.frame.size.width - 6, round(CGRectGetMinY(rect)) - 8);
            
            // stroke points
            CGPoint points[2] = {lineStart, lineEnd};
            CGContextSetRGBStrokeColor(context, 0.6, 0.7, 0.99, 1);
            CGContextStrokeLineSegments(context, points, 2);
        }
    }
    
    return scrollRect;
}

#pragma mark - Memory -

- (void)dealloc {
    CFRelease(testString);
    CGColorRelease(defaultColor);
    CGColorRelease(wrongColor);
    CGColorRelease(typedColor);
}

@end
