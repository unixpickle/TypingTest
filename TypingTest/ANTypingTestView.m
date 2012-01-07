//
//  ANTypingTestView.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANTypingTestView.h"

@implementation ANTypingTestView

@synthesize delegate;

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
                
        // set the string's line spacing
        CGFloat lineSpacing = 12;
        struct CTParagraphStyleSetting setting;
        setting.spec = kCTParagraphStyleSpecifierLineSpacing;
        setting.valueSize = sizeof(CGFloat);
        setting.value = &lineSpacing;
        CTParagraphStyleRef pStyle = CTParagraphStyleCreate(&setting, 1);
        CFAttributedStringSetAttribute(testString, CFRangeMake(0, [typingTest.letters count]), kCTParagraphStyleAttributeName, pStyle);
        CFRetain(pStyle);
    }
    return self;
}

- (CGFloat)typingTestRequiredHeight {
    NSMutableAttributedString * attribObj = (__bridge NSMutableAttributedString *)testString;
    NSRect r = [attribObj boundingRectWithSize:NSMakeSize(self.frame.size.width - (kTextSidePadding * 2), FLT_MAX)
                            options:0];
    return r.size.height + (kTextTopPadding * 2);
}

- (BOOL)canBecomeKeyView {
    return YES;
}

#pragma mark - Test -

- (void)keyDown:(NSEvent *)theEvent {
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
    
    if ([chars length] != 1) return;
    unichar theChar = [chars characterAtIndex:0];
    if (![typingTest charTyped:theChar]) {
        [self setLetterState:ANTypingTestLetterStateIncorrect
                   forLetter:(typingTest.currentLetter - 1)];
    } else {
        [self setLetterState:ANTypingTestLetterStateCorrect
                   forLetter:(typingTest.currentLetter - 1)];
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
    CGRect newScrollRect = [self drawTestText:context];
    if (!CGRectEqualToRect(newScrollRect, currentScrollRect)) {
        currentScrollRect = newScrollRect;
        if ([delegate respondsToSelector:@selector(typingTestView:scrollToRect:)]) {
            [delegate typingTestView:self scrollToRect:newScrollRect];
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
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(testString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CGPathRelease(path);
    CFRelease(framesetter);
    
    // draw the text
    CGContextSetTextPosition(context, 0, 0);
    CTFrameDraw(frame, context);
    
    CGRect scrollRect = [self drawTestTextLines:frame context:context];
    CFRelease(frame);
    
    return scrollRect;
}

- (CGRect)drawTestTextLines:(CTFrameRef)frame context:(CGContextRef)context {
    // universal drawing bounds
    NSRect boundsRect = NSMakeRect(kTextSidePadding, kTextTopPadding,
                                   self.frame.size.width - (kTextSidePadding * 2),
                                   self.frame.size.height - (kTextTopPadding * 2));
    
    // get line info
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint * origins = (CGPoint *)malloc(sizeof(CGPoint) * CFArrayGetCount(lines));
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    // blue line separator color
    CGContextSetRGBStrokeColor(context, 0.6, 0.7, 0.99, 1);
    
    CGRect scrollRect = CGRectZero;
    for (NSUInteger i = 0; i < CFArrayGetCount(lines); i++) {
        // calculate the rect for this line
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect rect = CTLineGetImageBounds(line, context);
        rect.origin = origins[i];
        rect.origin.x += boundsRect.origin.x;
        rect.origin.y += boundsRect.origin.y;
        
        // if the line contains the current character, scroll to the line
        CFRange range = CTLineGetStringRange(line);
        NSUInteger currentLetter = typingTest.currentLetter;
        if (currentLetter >= range.location && currentLetter < range.location + range.length) {
            scrollRect = rect;
        }
        
        // draw separator line
        if (i + 1 < CFArrayGetCount(lines)) {
            CGPoint lineStart = CGPointMake(3, round(CGRectGetMinY(rect)) - 8);
            CGPoint lineEnd = CGPointMake(self.frame.size.width - 6, round(CGRectGetMinY(rect)) - 8);
            CGPoint points[2] = {lineStart, lineEnd};
            CGContextStrokeLineSegments(context, points, 2);
        }
    }
    
    free(origins);
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
