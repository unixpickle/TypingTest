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
    [super windowControllerDidLoadNib:aController];
    
    NSRect frame = [[self mainWindow].contentView frame];
    
    editButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, 120, 80, 24)];
    [editButton setBezelStyle:NSRoundedBezelStyle];
    [editButton setTitle:@"Edit"];
    [editButton setTarget:self];
    [editButton setAction:@selector(modifyTestText:)];
    [[self mainWindow].contentView addSubview:editButton];
    
    timeField = [NSTextField labelTextField];
    [timeField setFrame:NSMakeRect(frame.size.width - 150, 150 - 30, 140, 20)];
    [timeField setStringValue:@"Time: 0:00"];
    [timeField setAlignment:NSRightTextAlignment];
    [[self mainWindow].contentView addSubview:timeField];
    
    wpmField = [NSTextField labelTextField];
    [wpmField setFrame:NSMakeRect(frame.size.width - 150, 120 - 30, 140, 20)];
    [wpmField setStringValue:@"WPM: 0"];
    [wpmField setAlignment:NSRightTextAlignment];
    [[self mainWindow].contentView addSubview:wpmField];
    
    wordCountField = [NSTextField labelTextField];
    [wordCountField setFrame:NSMakeRect(frame.size.width - 150, 90 - 30, 140, 20)];
    [wordCountField setStringValue:@"Words: 0"];
    [wordCountField setAlignment:NSRightTextAlignment];
    [[self mainWindow].contentView addSubview:wordCountField];
    
    mistakesField = [NSTextField labelTextField];
    [mistakesField setFrame:NSMakeRect(frame.size.width - 150, 60 - 30, 140, 20)];
    [mistakesField setStringValue:@"Mistakes: 0"];
    [mistakesField setAlignment:NSRightTextAlignment];
    [[self mainWindow].contentView addSubview:mistakesField];
    
    [wpmField setAutoresizingMask:NSViewMinXMargin];
    [timeField setAutoresizingMask:NSViewMinXMargin];
    [wordCountField setAutoresizingMask:NSViewMinXMargin];
    [mistakesField setAutoresizingMask:NSViewMinXMargin];
    
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

#pragma mark - User Interface -

- (NSWindow *)mainWindow {
    return [[[self windowControllers] objectAtIndex:0] window];
}

#pragma mark UI Actions

- (void)modifyTestText:(id)sender {
    NSString * current = [testContainer.testView.typingTest testString];
    EnterTextWindow * window = [[EnterTextWindow alloc] initWithSize:NSMakeSize(300, 120)
                                                         initialText:current];
    [window setDelegate:self];
    
    [NSApp beginSheet:window modalForWindow:[self mainWindow] modalDelegate:self didEndSelector:nil contextInfo:NULL];
    [NSApp runModalForWindow:window];
    [NSApp endSheet:window];
    
    [window orderOut:nil];
}

#pragma mark Editing

- (void)enterTextWindowEnteredText:(EnterTextWindow *)window {
    NSCharacterSet * whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString * testText = [[window userText] stringByTrimmingCharactersInSet:whitespace];
    ANTypingTest * test = [[ANTypingTest alloc] initWithTestString:testText];
    [self loadTest:test];
}

#pragma mark - Test -

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
    
    [testView setDelegate:self];
    [self updateStatistics];
    if ([theTest currentPeriod]) {
        [self typingTestViewTestBegan:testView];
    }
}

#pragma mark Text Delegate

- (void)typingTestViewTestBegan:(ANTypingTestView *)testView {
    if (testView != testContainer.testView) return;
    if (!testUpdateTimer) {
        testUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatistics) userInfo:nil repeats:YES];
    }
}

- (void)typingTestViewTestCompleted:(ANTypingTestView *)testView {
    [self updateStatistics];
    [testUpdateTimer invalidate];
    testUpdateTimer = nil;
}

- (void)typingTestViewUpdated:(ANTypingTestView *)testView {
    [self updateStatistics];
}

#pragma mark Statistics

- (void)updateStatistics {
    ANTypingTest * test = testContainer.testView.typingTest;
    NSTimeInterval totalTime = [test totalTime];
    NSUInteger wordCount = [test wordsCompleteCount];
    NSUInteger mistakeCount = [test mistakeCount];
    NSString * timeString = [NSString stringWithFormat:@"Time: %d:%02d",
                             (int)floor(round(totalTime) / 60.0), (int)round(totalTime) % 60];
    NSString * wpmString = [NSString stringWithFormat:@"WPM: %d",
                            (int)round((float)wordCount / (totalTime / 60.0))];
    NSString * mistakesString = [NSString stringWithFormat:@"Mistakes: %ld", (long)mistakeCount];
    NSString * wordsString = [NSString stringWithFormat:@"Words: %ld", (long)wordCount];
    if (totalTime <= 0) wpmString = @"WPM: 0";
    [timeField setStringValue:timeString];
    [wpmField setStringValue:wpmString];
    [mistakesField setStringValue:mistakesString];
    [wordCountField setStringValue:wordsString];
}

@end
