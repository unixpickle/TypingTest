//
//  ANTypingTest.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANTypingTest.h"

@implementation ANTypingTest

@synthesize startDate;
@synthesize endDate;
@synthesize letters;
@synthesize currentLetter;

- (id)initWithTestString:(NSString *)aString {
    if ((self = [super init])) {
        NSMutableArray * lettersMutable = [[NSMutableArray alloc] initWithCapacity:[aString length]];
        for (NSUInteger i = 0; i < [aString length]; i++) {
            unichar theChar = [aString characterAtIndex:i];
            ANTypingTestLetter * letter = [ANTypingTestLetter letterWithUnichar:theChar];
            [lettersMutable addObject:letter];
        }
        letters = [[NSArray alloc] initWithArray:lettersMutable];
    }
    return self;
}

- (void)beginTest {
    endDate = nil;
    startDate = [NSDate date];
}

- (void)endTest {
    endDate = [NSDate date];
}

- (NSTimeInterval)testTime {
    if (!endDate) return [[NSDate date] timeIntervalSinceDate:startDate];
    return [endDate timeIntervalSinceDate:startDate];
}

- (BOOL)isFinishedTest {
    if (currentLetter == [letters count]) return YES;
    return NO;
}

- (void)deleteLastChar {
    if (currentLetter > 0) {
        currentLetter--;
        ANTypingTestLetter * letter = [letters objectAtIndex:currentLetter];
        [letter setState:ANTypingTestLetterStateDefault];
    }
}

- (BOOL)charTyped:(unichar)theChar {
    if ([self isFinishedTest]) return NO;
    ANTypingTestLetter * letter = [letters objectAtIndex:currentLetter++];
    if (theChar == [letter letter]) {
        [letter setState:ANTypingTestLetterStateCorrect];
        return YES;
    } else {
        [letter setState:ANTypingTestLetterStateIncorrect];
        return NO;
    }
}

@end
