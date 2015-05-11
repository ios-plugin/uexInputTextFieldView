//
//  ChatKeyboardUtility.h
//  EuexInputTextFieldView
//
//  Created by xurigan on 15/1/12.
//  Copyright (c) 2015年 com.zywx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputChatKeyboardUtility : NSObject

+ (int)getRand;

+ (NSString *)getFilePathInChatKeyboardCache:(NSString*)fileName;

@end
