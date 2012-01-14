//
//  ANTypingTest.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANTypingTestLetter.h"
#import "ANTestTimePeriod.h"

@interface ANTypingTest : NSObject <NSCoding> {
    ANTestTimePeriod * currentPeriod;
    NSMutableArray * previousPeriods;
    NSArray * letters;
    NSUInteger currentLetter;
}

@property (readonly) ANTestTimePeriod * currentPeriod;
@property (readonly) NSArray * letters;
@property (readwrite) NSUInteger currentLetter;

- (id)initWithTestString:(NSString *)aString;

- (void)startPeriod;
- (void)endPeriod;
- (NSUInteger)totalTime;

- (BOOL)isFinishedTest;

- (void)deleteLastChar;
- (BOOL)charTyped:(unichar)theChar;

- (NSUInteger)wordsCompleteCount;
- (NSUInteger)mistakeCount;

@end
