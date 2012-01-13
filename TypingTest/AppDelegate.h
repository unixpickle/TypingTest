//
//  AppDelegate.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANTypingTestContainer.h"

#define kTestViewHeight 59*4

@interface AppDelegate : NSObject <NSApplicationDelegate, ANTypingTestViewDelegate> {
    ANTypingTestContainer * testContainer;
    NSTimer * timer;
}

@property (assign) IBOutlet NSWindow * window;

- (void)updateStats;

@end
