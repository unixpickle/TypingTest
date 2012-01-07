//
//  AppDelegate.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    ANTypingTest * test = [[ANTypingTest alloc] initWithTestString:@"This is a basic typing test. Letters you type incorrectly will appear in red. Soon I must make incorrect letters/characters have a red background so that you can tell if you mess up on spaces."];
    ANTypingTestView * testView = [[ANTypingTestView alloc] initWithFrame:[self.window.contentView bounds]
                                                               typingTest:test];
    NSRect testFrame = NSMakeRect(0, [self.window.contentView frame].size.height - 59,
                                  [self.window.contentView frame].size.width, 59);
    ANTypingTestContainer * container = [[ANTypingTestContainer alloc] initWithFrame:testFrame
                                                                      typingTestView:testView];
    [self.window.contentView addSubview:container];
    [self.window makeFirstResponder:container];
}

@end
