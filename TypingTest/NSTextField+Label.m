//
//  NSTextField+Label.m
//  TypingTest
//
//  Created by Alex Nichol on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSTextField+Label.h"

@implementation NSTextField (Label)

+ (NSTextField *)labelTextField {
    NSTextField * field = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
    [field setBordered:NO];
    [field setBackgroundColor:[NSColor clearColor]];
    [field setEditable:NO];
    [field setSelectable:NO];
    return field;
}

@end
