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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        letter = [aDecoder decodeIntegerForKey:@"letter"];
        state = (ANTypingTestLetterState)[aDecoder decodeIntegerForKey:@"state"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:letter forKey:@"letter"];
    [aCoder encodeInteger:state forKey:@"state"];
}

+ (ANTypingTestLetter *)letterWithUnichar:(unichar)aLetter {
    return [[ANTypingTestLetter alloc] initWithLetter:aLetter state:ANTypingTestLetterStateDefault];
}

@end
