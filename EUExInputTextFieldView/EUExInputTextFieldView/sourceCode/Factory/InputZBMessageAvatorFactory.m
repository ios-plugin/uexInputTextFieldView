//
//  ZBMessageAvator.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-17.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "InputZBMessageAvatorFactory.h"
#import "UIImage+InputXHRounded.h"

@implementation InputZBMessageAvatorFactory

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatorType:(ZBMessageAvatorType)messageAvatorType {
    CGFloat radius = 0.0;
    switch (messageAvatorType) {
        case ZBMessageAvatorCircle:
            radius = originImage.size.width / 2.0;
            break;
        case ZBMessageAvatorSquare:
            radius = 8;
            break;
        default:
            break;
    }
    UIImage *avator = [originImage createRoundedWithRadius:radius];
   
    return avator;
}

@end
