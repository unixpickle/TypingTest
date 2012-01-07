//
//  ANTextLine.m
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANTextLine.h"

@implementation ANTextLine

- (id)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)theOrigin context:(CGContextRef)theContext {
    if ((self = [super init])) {
        line = CFRetain(lineRef);
        origin = theOrigin;
        context = CGContextRetain(theContext);
    }
    return self;
}

- (CTLineRef)CTLine {
    return line;
}

- (CGPoint)origin {
    return origin;
}

- (CGRect)boundingRect {
    CGRect bounds = CTLineGetImageBounds(line, context);
    bounds.origin = origin;
    return bounds;
}

- (void)dealloc {
    CGContextRelease(context);
    CFRelease(line);
}

@end
