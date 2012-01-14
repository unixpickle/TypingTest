//
//  TestDocument.m
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestDocument.h"

@implementation TestDocument

@synthesize testContainer;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (NSString *)windowNibName {
    return @"TestDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    NSLog(@"I am ish gay");
    [super windowControllerDidLoadNib:aController];
    
    if (!loadedTest) {
        ANTypingTest * defaultTest = [[ANTypingTest alloc] initWithTestString:@"The quick brown fox."];
        [self loadTest:defaultTest];
    } else if (!testContainer) {
        [self loadTest:loadedTest];
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    if (!testContainer.testView.typingTest) {
        if (outError) *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:NULL];
        return nil;
    }
    return [NSKeyedArchiver archivedDataWithRootObject:testContainer.testView.typingTest];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    NSLog(@"Read from data");
    ANTypingTest * test = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (![test isKindOfClass:[ANTypingTest class]] || !test) {
        if (outError) *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:NULL];
        return NO;
    }
    loadedTest = test;
    return YES;
}

+ (BOOL)autosavesInPlace {
    return NO;
}

- (NSWindow *)mainWindow {
    return [[[self windowControllers] objectAtIndex:0] window];
}

#pragma mark - Test Container -

- (void)loadTest:(ANTypingTest *)theTest {
    if (testContainer) {
        [testContainer removeFromSuperview];
    }
    
    NSWindow * window = [self mainWindow];
    NSRect frame = NSMakeRect(0, 150, [window.contentView frame].size.width,
                              [window.contentView frame].size.height - 150);
    ANTypingTestView * testView = [[ANTypingTestView alloc] initWithFrame:frame typingTest:theTest];
    
    testContainer = [[ANTypingTestContainer alloc] initWithFrame:frame typingTestView:testView];
    [testContainer setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [window.contentView addSubview:testContainer];
    [window makeFirstResponder:testContainer];
}

@end
