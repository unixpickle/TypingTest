//
//  TestDocument.h
//  TypingTest
//
//  Created by Alex Nichol on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANTypingTestContainer.h"

@interface TestDocument : NSDocument {
    ANTypingTest * loadedTest;
    ANTypingTestContainer * testContainer;
    NSButton * editButton;
}

@property (readonly) ANTypingTestContainer * testContainer;

- (void)loadTest:(ANTypingTest *)theTest;
- (NSWindow *)mainWindow;

@end
