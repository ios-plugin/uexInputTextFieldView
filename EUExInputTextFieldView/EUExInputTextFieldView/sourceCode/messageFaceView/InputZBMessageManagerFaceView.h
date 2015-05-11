//
//  MessageFaceView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputZBFaceView.h"

@protocol InputZBMessageManagerFaceViewDelegate <NSObject>

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele;

@end

@interface InputZBMessageManagerFaceView : UIView<UIScrollViewDelegate,InputZBFaceViewDelegate>

@property (nonatomic,weak)id<InputZBMessageManagerFaceViewDelegate>delegate;
@property (nonatomic,strong) NSString * facePath;

- (id)initWithFrame:(CGRect)frame andFacePath:(NSString *)facePath;

@end
