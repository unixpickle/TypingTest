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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        startDate = [aDecoder decodeObjectForKey:@"start"];
        endDate = [aDecoder decodeObjectForKey:@"end"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:startDate forKey:@"start"];
    [aCoder encodeObject:endDate forKey:@"end"];
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
