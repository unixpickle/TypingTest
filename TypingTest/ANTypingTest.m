//
//  ANTypingTest.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANTypingTest.h"

@implementation ANTypingTest

@synthesize currentPeriod;
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
        previousPeriods = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Timing -

- (void)startPeriod {
    if (currentPeriod) {
        [currentPeriod endPeriod];
        [previousPeriods addObject:currentPeriod];
    }
    currentPeriod = [ANTestTimePeriod periodStartingWithNow];
}

- (void)endPeriod {
    [currentPeriod endPeriod];
    [previousPeriods addObject:currentPeriod];
    currentPeriod = nil;
}

- (NSUInteger)totalTime {
    NSTimeInterval totalTime = 0;
    for (ANTestTimePeriod * period in previousPeriods) {
        totalTime += [period periodTime];
    }
    if (currentPeriod) {
        totalTime += [currentPeriod periodTime];
    }
    return totalTime;
}

#pragma mark - Appending & New Text Handling -

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

#pragma mark - User Statistics -

- (NSUInteger)wordsCompleteCount {
    NSUInteger wordCount = 0;
    NSUInteger charCount = 0;
    for (NSUInteger i = 0; i < [letters count]; i++) {
        ANTypingTestLetter * letter = [letters objectAtIndex:i];
        if ([letter state] == ANTypingTestLetterStateDefault) {
            charCount = 0;
            break;
        }
        if (isspace([letter letter])) {
            if (charCount > 0) wordCount++;
            charCount = 0;
        } else {
            charCount++;
        }
    }
    if (charCount > 0) wordCount++;
    return wordCount;
}

- (NSUInteger)mistakeCount {
    NSUInteger numWrong = 0;
    for (NSUInteger i = 0; i < [letters count]; i++) {
        ANTypingTestLetter * letter = [letters objectAtIndex:i];
        if ([letter state] == ANTypingTestLetterStateIncorrect) {
            numWrong++;
        }
    }
    return numWrong;
}

@end
