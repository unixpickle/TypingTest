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
    ANTypingTest * test = [[ANTypingTest alloc] initWithTestString:@"The quick brown fox jumps over the lazy dog. Holy crap, it looks like the fox just ate a lump of dog shit. This is one gross fox if you ask me."];
    testView = [[ANTypingTestView alloc] initWithFrame:[self.window.contentView bounds]
                                            typingTest:test];
    [self.window.contentView addSubview:testView];
    [self.window makeFirstResponder:testView];
}

@end
