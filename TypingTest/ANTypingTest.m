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

- (NSString *)testString {
    NSMutableString * stringMutable = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < [letters count]; i++) {
        unichar c = [[letters objectAtIndex:i] letter];
        [stringMutable appendFormat:@"%C", c];
    }
    return [NSString stringWithString:stringMutable];
}

#pragma mark - NSCoding -

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        letters = [aDecoder decodeObjectForKey:@"letters"];
        previousPeriods = [[aDecoder decodeObjectForKey:@"previousDates"] mutableCopy];
        currentPeriod = [aDecoder decodeObjectForKey:@"currentPeriod"];
        currentLetter = [aDecoder decodeIntegerForKey:@"currentLetter"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:previousPeriods forKey:@"previousDates"];
    [aCoder encodeObject:letters forKey:@"letters"];
    [aCoder encodeObject:currentPeriod forKey:@"currentPeriod"];
    [aCoder encodeInteger:currentLetter forKey:@"currentLetter"];
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

- (void)resetTest {
    for (NSUInteger i = 0; i < [letters count]; i++) {
        ANTypingTestLetter * letter = [letters objectAtIndex:i];
        [letter setState:ANTypingTestLetterStateDefault];
    }
    [self setCurrentLetter:0];
    currentPeriod = nil;
    [previousPeriods removeAllObjects];
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
        if (kSpaceJumpsWords && isspace(theChar)) {
            // jump to the next word/line (or to where the whitespace next occurs)
            for (NSUInteger i = currentLetter; i < [letters count]; i++) {
                ANTypingTestLetter * aLetter = [letters objectAtIndex:i];
                if ([aLetter letter] == theChar) {
                    [aLetter setState:ANTypingTestLetterStateCorrect];
                    currentLetter = i + 1;
                    break;
                } else {
                    // they skipped this letter, so it's wrong
                    [aLetter setState:ANTypingTestLetterStateIncorrect];
                }
            }
        }
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
