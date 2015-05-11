//
//  ZBMessageVoice.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-17.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputZBMessageBubbleFactory.h"

@interface InputZBMessageVoiceFactory : NSObject

+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(ZBBubbleMessageType)type;

@end
