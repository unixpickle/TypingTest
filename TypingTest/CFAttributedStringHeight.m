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
    
    ANTextFrame * frame = [[ANTextFrame alloc] initWithAttributedString:string
                                                                context:context
                                                                   path:path];
    
    CGPathRelease(path);
    
    return [frame boundingRect].size.height;
}
