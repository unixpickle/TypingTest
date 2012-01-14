//
//  AppDelegate.m
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    hasOpenedNew = YES;
    for (NSString * string in filenames) {
        NSURL * url = [NSURL fileURLWithPath:string];
        [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES error:nil];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (!hasOpenedNew) [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
}

@end
