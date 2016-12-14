//
//  ChatKeyboard.h
//  EUExChatKeyboard
//
//  Created by xurigan on 14/12/12.
//  Copyright (c) 2014年 com.zywx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUExInputTextFieldView.h"
#import "InputZBMessageInputView.h"
#import "InputZBMessageShareMenuView.h"
#import "InputZBMessageManagerFaceView.h"
#import "InputZBMessage.h"
#import "InputChatKeyboardUtility.h"


typedef NS_ENUM(NSInteger,ZBMessageViewState) {
    ZBMessageViewStateShowFace,
    ZBMessageViewStateShowShare,
    ZBMessageViewStateShowNone,
};


@interface InputChatKeyboard : NSObject<InputZBMessageInputViewDelegate,InputZBMessageShareMenuViewDelegate,InputZBMessageManagerFaceViewDelegate>

@property (nonatomic, weak) EUExInputTextFieldView * uexObj;

@property (nonatomic,strong) InputZBMessageInputView *messageToolView;

@property (nonatomic,strong) InputZBMessageManagerFaceView *faceView;

@property (nonatomic,strong) UIButton * sendButton;

@property (nonatomic,strong) InputZBMessageShareMenuView *shareMenuView;

@property (nonatomic,assign) CGFloat previousTextViewContentHeight;

@property (nonatomic,assign) double animationDuration;

@property (nonatomic,assign) CGRect keyboardRect;

@property (nonatomic,strong) NSTimer * timerRecordUpdate;



@property (nonatomic,assign) CGFloat inputViewHeight;

@property (nonatomic,assign) BOOL isInit;

@property (nonatomic,strong) NSString * facePath;

@property (nonatomic,assign)CGFloat bottomOffset;

-(instancetype)initWithUexobj:(EUExInputTextFieldView *)uexObj;
-(void)open;
-(void)close;
- (void)hideKeyboard;
- (void)changeWebView:(float)height;
@end
