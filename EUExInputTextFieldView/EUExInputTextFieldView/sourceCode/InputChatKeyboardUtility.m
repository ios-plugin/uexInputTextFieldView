//
//  ChatKeyboardUtility.m
//  EuexInputTextFieldView
//
//  Created by xurigan on 15/1/12.
//  Copyright (c) 2015年 com.zywx. All rights reserved.
//

#import "InputChatKeyboardUtility.h"

@implementation InputChatKeyboardUtility

+ (int)getRand {
    srand((unsigned)time(NULL));
    return rand();
}

+ (NSString *)getFilePathInChatKeyboardCache:(NSString*)fileName {
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/chatKeyboardCache/%@",fileName]];
}

@end
