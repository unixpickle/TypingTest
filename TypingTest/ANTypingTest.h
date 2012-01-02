//
//  ANTypingTest.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANTypingTestLetter.h"

@interface ANTypingTest : NSObject {
    NSDate * startDate;
    NSDate * endDate;
    NSArray * letters;
    NSUInteger currentLetter;
}

@property (readonly) NSDate * startDate;
@property (readonly) NSDate * endDate;
@property (readonly) NSArray * letters;
@property (readwrite) NSUInteger currentLetter;

- (void)beginTest;
- (void)endTest;
- (NSTimeInterval)testTime;
- (BOOL)isFinishedTest;

- (void)deleteLastChar;
- (void)charTyped:(unichar)theChar;

@end
