//
//  AppDelegate.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANTypingTestContainer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    ANTypingTestContainer * testContainer;
}

@property (assign) IBOutlet NSWindow * window;

@end
