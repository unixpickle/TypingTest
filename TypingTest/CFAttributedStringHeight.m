//
//  CFAttributedStringHeight.m
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CFAttributedStringHeight.h"

CGFloat CFAttributedStringDrawHeight (CFAttributedStringRef string, CGFloat width, CGContextRef context) {
    NSRect boundsRect = NSMakeRect(0, 0, width, 10000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, boundsRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CGPathRelease(path);
    CFRelease(framesetter);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint * origins = (CGPoint *)malloc(sizeof(CGPoint) * CFArrayGetCount(lines));
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
        
    CGFloat minY = CGFLOAT_MAX;
    for (NSUInteger i = 0; i < CFArrayGetCount(lines); i++) {
        // calculate the rect for this line
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect rect = CTLineGetImageBounds(line, context);
        rect.origin = origins[i];
        rect.origin.x += boundsRect.origin.x;
        rect.origin.y += boundsRect.origin.y;
        if (rect.origin.y < minY) {
            minY = rect.origin.y;
        }
    }
    
    free(origins);
    CFRelease(frame);
    
    return boundsRect.size.height - minY;
}
