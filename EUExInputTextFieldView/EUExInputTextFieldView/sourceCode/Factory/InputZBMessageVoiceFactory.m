//
//  ZBMessageVoice.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-17.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "InputZBMessageVoiceFactory.h"

@implementation InputZBMessageVoiceFactory

+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(ZBBubbleMessageType)type {
    UIImageView *messageVoiceAniamtionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSString *imageSepatorName;
    switch (type) {
        case ZBBubbleMessageTypeSending:
            imageSepatorName = @"Sender";
            break;
        case ZBBubbleMessageTypeReceiving:
            imageSepatorName = @"Receiver";
            break;
        default:
            break;
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i ++) {
        //[UIImage imageWithContentsOfFile:[[UEX_BUNDLE resourcePath] stringByAppendingPathComponent: @"messageInputViewResource/input-bar-background@2x.png"]]
        NSString * imagePath = [NSString stringWithFormat:@"%@VoiceNodePlaying00%ld@2x.png",imageSepatorName,(long)i];
        UIImage *image = [UIImage imageWithContentsOfFile:[[UEX_BUNDLE resourcePath] stringByAppendingPathComponent:imagePath]];
        if (image)
            [images addObject:image];
    }
    NSString * messageVoiceAniamtionImageViewPath = [NSString stringWithFormat:@"%@VoiceNodePlaying@2x.png",imageSepatorName];
    messageVoiceAniamtionImageView.image = [UIImage imageWithContentsOfFile:[[UEX_BUNDLE resourcePath] stringByAppendingPathComponent:messageVoiceAniamtionImageViewPath]];
    messageVoiceAniamtionImageView.animationImages = images;
    messageVoiceAniamtionImageView.animationDuration = 1.0;
    [messageVoiceAniamtionImageView stopAnimating];
    
    return messageVoiceAniamtionImageView;
}

@end
