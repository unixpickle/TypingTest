//
//  ANTypingTestLetter.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANTypingTestLetter.h"

@implementation ANTypingTestLetter

@synthesize letter, state;

- (id)initWithLetter:(unichar)aLetter state:(ANTypingTestLetterState)aState {
    if ((self = [super init])) {
        letter = aLetter;
        state = aState;
    }
    return self;
}

@end
