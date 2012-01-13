//
//  ANTestTimePeriod.m
//  TypingTest
//
//  Created by  on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANTestTimePeriod.h"

@implementation ANTestTimePeriod

@synthesize startDate;
@synthesize endDate;

+ (ANTestTimePeriod *)periodStartingWithNow {
    ANTestTimePeriod * period = [[ANTestTimePeriod alloc] init];
    period.startDate = [NSDate date];
    return period;
}

- (NSTimeInterval)periodTime {
    if (endDate) {
        return [endDate timeIntervalSinceDate:startDate];
    }
    return [[NSDate date] timeIntervalSinceDate:startDate];
}

- (void)endPeriod {
    endDate = [NSDate date];
}

@end
