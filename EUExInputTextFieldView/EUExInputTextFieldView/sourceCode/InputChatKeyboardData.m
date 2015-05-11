//
//  ChatKeyboardData.m
//  EuexInputTextFieldView
//
//  Created by xurigan on 15/3/9.
//  Copyright (c) 2015年 com.zywx. All rights reserved.
//

#import "InputChatKeyboardData.h"

@implementation InputChatKeyboardData

static InputChatKeyboardData *_sharedChatKeyboardData = nil;

+ (InputChatKeyboardData *)sharedChatKeyboardData
{
    if (!_sharedChatKeyboardData) {
        _sharedChatKeyboardData = [[self alloc] init];
    }
    
    return _sharedChatKeyboardData;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.faceArray = [NSArray array];
        self.faceImgArray = [NSArray array];
        self.shareArray = [NSArray array];
        self.shareImgArray = [NSArray array];
    }
    return self;
}

@end
