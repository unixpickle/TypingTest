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
    ANTypingTest * test = [[ANTypingTest alloc] initWithTestString:@"This is a basic typing test. Letters you type incorrectly will appear in red. Letters that you have yet to type will appear in gray. The cursor that comes before every character is drawn manually through CoreGraphics. Enjoy the test, and please, spend some time developing this project so I don't have to."];
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
