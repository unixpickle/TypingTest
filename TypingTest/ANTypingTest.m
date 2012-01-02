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

- (void)charTyped:(unichar)theChar {
    if ([self isFinishedTest]) return;
    ANTypingTestLetter * letter = [letters objectAtIndex:currentLetter++];
    if (theChar == [letter letter]) {
        [letter setState:ANTypingTestLetterStateCorrect];
    } else {
        [letter setState:ANTypingTestLetterStateIncorrect];
    }
}

@end
