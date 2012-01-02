//
//  ANTypingTestLetter.h
//  TypingTest
//
//  Created by Alex Nichol on 1/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ANTypingTestLetterStateDefault,
    ANTypingTestLetterStateCorrect,
    ANTypingTestLetterStateIncorrect
} ANTypingTestLetterState;

@interface ANTypingTestLetter : NSObject {
    unichar letter;
    ANTypingTestLetterState state;
}

@property (readonly) unichar letter;
@property (readwrite) ANTypingTestLetterState state;

- (id)initWithLetter:(unichar)aLetter state:(ANTypingTestLetterState)aState;
+ (ANTypingTestLetter *)letterWithUnichar:(unichar)aLetter;

@end
