//
//  TestDocument.h
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+Label.h"
#import "ANTypingTestContainer.h"
#import "EnterTextWindow.h"

@interface TestDocument : NSDocument <EnterTextWindowDelegate, ANTypingTestViewDelegate> {
    ANTypingTest * loadedTest;
    ANTypingTestContainer * testContainer;
    
    NSButton * editButton;
    NSButton * pauseResetButton;
    NSTextField * timeField;
    NSTextField * wordCountField;
    NSTextField * mistakesField;
    NSTextField * wpmField;
    
    
    NSTimer * testUpdateTimer;
}

@property (readonly) ANTypingTestContainer * testContainer;

- (void)loadTest:(ANTypingTest *)theTest;
- (NSWindow *)mainWindow;

- (void)modifyTestText:(id)sender;
- (void)pauseRestartPressed:(id)sender;
- (void)updateStatistics;

@end
