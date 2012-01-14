//
//  ANTestTimePeriod.h
//  TypingTest
//
//  Created by  on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANTestTimePeriod : NSObject <NSCoding, NSCopying> {
    NSDate * startDate;
    NSDate * endDate;
}

@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSDate * endDate;

+ (ANTestTimePeriod *)periodStartingWithNow;

- (NSTimeInterval)periodTime;
- (void)endPeriod;

@end
