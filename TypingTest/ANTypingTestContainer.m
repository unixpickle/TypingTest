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
    }
    return self;
}

- (void)typingTestView:(ANTypingTestView *)testView scrollToRect:(CGRect)visibleRect {
    
}

@end
