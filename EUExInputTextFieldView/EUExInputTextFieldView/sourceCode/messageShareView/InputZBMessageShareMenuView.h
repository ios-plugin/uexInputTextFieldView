//
//  ZBShareMenuView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputZBMessageShareMenuItem.h"

#define kZBMessageShareMenuPageControlHeight 30

@protocol InputZBMessageShareMenuViewDelegate <NSObject>

@optional
- (void)didSelecteShareMenuItem:(InputZBMessageShareMenuItem *)shareMenuItem atIndex:(NSInteger)index;

@end

@interface InputZBMessageShareMenuView : UIView

/**
 *  第三方功能Models
 */
@property (nonatomic, strong) NSArray *shareMenuItems;

@property (nonatomic, weak) id <InputZBMessageShareMenuViewDelegate> delegate;

- (void)reloadData;

@end
