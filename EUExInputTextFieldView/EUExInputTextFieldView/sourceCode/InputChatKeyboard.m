//
//  ChatKeyboard.m
//  EUExChatKeyboard
//
//  Created by xurigan on 14/12/12.
//  Copyright (c) 2014年 com.zywx. All rights reserved.
//

#import "InputChatKeyboard.h"
#import "InputChatKeyboardData.h"





#define isSysVersionAbove7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define UEX_SCREENWIDTH (isSysVersionAbove7_0?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].applicationFrame.size.width)
#define UEX_SCREENHEIGHT (isSysVersionAbove7_0?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].applicationFrame.size.height)

@implementation UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


@interface InputChatKeyboard()
@property  (nonatomic,assign)BOOL keyboardShouldHide;
@end


@implementation InputChatKeyboard

-(instancetype)initWithUexobj:(EUExInputTextFieldView *)uexObj{
    if (self = [super init]) {
        _uexObj = uexObj;
        _animationDuration = 0.25;
        _isInit = YES;
        _bottomOffset = 0;
        _keyboardShouldHide = YES;
    }
    return self;
}

-(void)removeViewAndSubviewsFromSuperview:(UIView *)view{
    if ([view.subviews count] == 0) {
        [view removeFromSuperview];
    } else {
        for (UIView * subview in view.subviews) {
            [self removeViewAndSubviewsFromSuperview:subview];
        }
        [view removeFromSuperview];
    }
}

-(void)close {

    if (self.messageToolView) {
        [self removeViewAndSubviewsFromSuperview:self.messageToolView];
        self.messageToolView = nil;
    }
    if (self.sendButton) {
        [self removeViewAndSubviewsFromSuperview:self.sendButton];
        self.sendButton = nil;
    }
    if (self.faceView) {
        [self removeViewAndSubviewsFromSuperview:self.faceView];
        self.faceView = nil;
    }
    if (self.shareMenuView) {
        [self removeViewAndSubviewsFromSuperview:self.shareMenuView];
        self.shareMenuView = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)open {
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        _inputViewHeight = 45.0f;
    }
    else{
        _inputViewHeight = 40.0f;
    }
    
    self.messageToolView = [[InputZBMessageInputView alloc]initWithFrame:CGRectMake(0.0f,UEX_SCREENHEIGHT - _inputViewHeight - _bottomOffset,UEX_SCREENWIDTH,_inputViewHeight)];
    
    self.messageToolView.delegate = self;
    [[self.uexObj.webViewEngine webView] addSubview:self.messageToolView];
    
    [self shareFaceView];

}

- (void)shareFaceView{

    if (!self.faceView) {
        InputChatKeyboardData *chatKeyboardData = [InputChatKeyboardData sharedChatKeyboardData];
        self.faceView = [[InputZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0.0f,UEX_SCREENHEIGHT, UEX_SCREENWIDTH, 196) andFacePath:self.facePath];
        self.faceView.delegate = self;
        [[self.uexObj.webViewEngine webView] addSubview:self.faceView];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.frame = CGRectMake(UEX_SCREENWIDTH-70, CGRectGetMaxY(self.faceView.frame)+3, 70, 37);
        [self.sendButton setTitle:chatKeyboardData.sendBtnText forState:UIControlStateNormal];
        [self.sendButton setTitleColor:chatKeyboardData.sendBtnTextColor forState:UIControlStateNormal];
        [self.sendButton setBackgroundColor:chatKeyboardData.sendBtnbgColorUp];
        [self.sendButton setBackgroundColor:chatKeyboardData.sendBtnbgColorDown forState:UIControlStateHighlighted];
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:chatKeyboardData.sendBtnTextSize];
        self.sendButton.layer.borderWidth = 0.6;
        self.sendButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];

//        [self.sendButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[UEX_BUNDLE resourcePath] stringByAppendingPathComponent:@"EmotionsSendBtnGrey@2x.png"]] forState:UIControlStateNormal];
//        [self.sendButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[UEX_BUNDLE resourcePath] stringByAppendingPathComponent:@"EmotionsSendBtnBlueHL@2x.png"]] forState:UIControlStateHighlighted];
        [[self.uexObj.webViewEngine webView] addSubview:self.sendButton];
        [self.sendButton addTarget:self action:@selector(sendButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)sendButtonDidClicked:(id)sender {
    _keyboardShouldHide = YES;
    [self didSendTextAction:self.messageToolView.messageInputTextView];
    [self messageViewAnimationWithMessageRect:CGRectZero
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:0.25
                                     andState:ZBMessageViewStateShowNone];
}

- (void)shareShareMeun
{

    if (!self.shareMenuView)
    {
        self.shareMenuView = [[InputZBMessageShareMenuView alloc]initWithFrame:CGRectMake(0.0f,UEX_SCREENHEIGHT,UEX_SCREENWIDTH, 196)];
        [[self.uexObj.webViewEngine webView] addSubview:self.shareMenuView];

        self.shareMenuView.delegate = self;
        
        NSMutableArray * itemArray = [NSMutableArray array];
        int count = (int)[InputChatKeyboardData sharedChatKeyboardData].shareArray.count;
        
        for (int i = 0; i < count; i++) {
            NSString * imgStr = [[[InputChatKeyboardData sharedChatKeyboardData].shareImgArray objectAtIndex:i] objectForKey:@"text"];
            NSString * imgPath = [NSString stringWithFormat:@"%@%@",[InputChatKeyboardData sharedChatKeyboardData].sharePath,imgStr];
            //UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
            UIImage * image = [UIImage imageNamed:imgPath];
            NSString * imgTitle = [[[InputChatKeyboardData sharedChatKeyboardData].shareArray objectAtIndex:i] objectForKey:@"text"];
            
            InputZBMessageShareMenuItem * shareItem = [[InputZBMessageShareMenuItem alloc]initWithNormalIconImage:image title:imgTitle];
            [itemArray addObject:shareItem];
        }
        
        self.shareMenuView.shareMenuItems = [NSArray arrayWithArray:itemArray];
        [self.shareMenuView reloadData];
        
    }
}

- (void)changeWebView:(float)height {
    
//    float yy = [self.uexObj.webViewEngine webView].frame.origin.y;
//    CGPoint point = CGPointZero;
//    if (CGRectGetMinY(self.messageToolView.frame) < yy + height) {
//        point = CGPointMake(0, yy + height - CGRectGetMinY(self.messageToolView.frame));
//    }
//    ACLogDebug(@"%@",@(point.y));
//    [[self.uexObj.webViewEngine webScrollView] setContentOffset:point];
    
}
 
#pragma mark - messageView animation
- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(ZBMessageViewState)state{
    if (CGRectGetHeight(rect) > 0) {
        duration = duration + 0.1;
    }else{
        duration = 0.01;
    }
    
    

    
    
    //ACLogDebug(@"msgRect:%@,inputRect%@",[NSValue valueWithCGRect:rect],[NSValue valueWithCGRect:inputViewRect]);
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat offsetHeight = self.bottomOffset;
        if(CGRectGetHeight(rect)>offsetHeight){
            offsetHeight=CGRectGetHeight(rect);
        }
        
        self.messageToolView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT-offsetHeight-CGRectGetHeight(inputViewRect),UEX_SCREENWIDTH,CGRectGetHeight(inputViewRect));
        switch (state) {
            case ZBMessageViewStateShowFace:
            {
                self.faceView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT-CGRectGetHeight(rect),UEX_SCREENWIDTH,CGRectGetHeight(rect));
                
                
                self.shareMenuView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT,UEX_SCREENWIDTH,CGRectGetHeight(self.shareMenuView.frame));
            }
                break;
            case ZBMessageViewStateShowNone:
            {
                self.faceView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT-CGRectGetHeight(rect),UEX_SCREENWIDTH,CGRectGetHeight(self.faceView.frame));
                
                self.shareMenuView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT,UEX_SCREENWIDTH,CGRectGetHeight(self.shareMenuView.frame));
            }
                break;
            case ZBMessageViewStateShowShare:
            {
                self.shareMenuView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT-CGRectGetHeight(rect),UEX_SCREENWIDTH,CGRectGetHeight(rect));
                
                self.faceView.frame = CGRectMake(0.0f,UEX_SCREENHEIGHT,UEX_SCREENWIDTH,CGRectGetHeight(self.faceView.frame));
                
            }
                break;
                
            default:
                break;
        }
        CGRect tmpRect = self.sendButton.frame;
        tmpRect.origin.y = CGRectGetMaxY(self.faceView.frame)-37;
        self.sendButton.frame = tmpRect;
        
    } completion:^(BOOL finished) {
        
        NSInteger status = 0;
        
        if (!_keyboardShouldHide) {
            status = 1;
        }
        
        NSDictionary * jsDic = @{@"status":@(status)};
        [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onKeyBoardShow" arguments:ACArgsPack(jsDic.ac_JSONFragment)];
    }];
    


}



#pragma end

#pragma mark - ZBMessageInputView Delegate
- (void)didSelectedMultipleMediaAction:(BOOL)changed{
    
    if (changed){
        _keyboardShouldHide = NO;
        [self messageViewAnimationWithMessageRect:self.shareMenuView.frame
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowShare];
    }
    else{
        [self messageViewAnimationWithMessageRect:self.keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
    
}

- (void)didSendFaceAction:(BOOL)sendFace{
    if (sendFace) {
        _keyboardShouldHide = NO;
        [self messageViewAnimationWithMessageRect:self.faceView.frame
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowFace];
    }
    else{
        [self messageViewAnimationWithMessageRect:self.keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
}

- (void)didChangeSendVoiceAction:(BOOL)changed{
    if (changed){
        [self messageViewAnimationWithMessageRect:CGRectZero
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
    else{
        [self messageViewAnimationWithMessageRect:self.keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
}

/*
 * 点击输入框代理方法
 */
- (void)inputTextViewWillBeginEditing:(InputZBMessageTextView *)messageInputTextView{
    
}

- (void)inputTextViewDidBeginEditing:(InputZBMessageTextView *)messageInputTextView
{
    _keyboardShouldHide = NO;
    [self messageViewAnimationWithMessageRect:self.keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:self.animationDuration
                                     andState:ZBMessageViewStateShowNone];
    
    if (!self.previousTextViewContentHeight)
    {
        self.previousTextViewContentHeight = messageInputTextView.contentSize.height;
    }
}



- (void)inputTextViewDidChange:(InputZBMessageTextView *)messageInputTextView
{
    if (_isInit) {
        self.previousTextViewContentHeight = messageInputTextView.contentSize.height;
        _isInit = NO;
    }
    
    CGFloat maxHeight = [InputZBMessageInputView maxHeight];
    CGSize size = [messageInputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(messageInputTextView.frame), maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }

    
    if(changeInHeight != 0.0f) {
        
        [UIView animateWithDuration:0.01f
                         animations:^{
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageToolView.frame;
                             self.messageToolView.frame = CGRectMake(0.0f,
                                                                     inputViewFrame.origin.y - changeInHeight,
                                                                     inputViewFrame.size.width,
                                                                     inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
}
/*
 * 发送信息
 */
- (void)didSendTextAction:(InputZBMessageTextView *)messageInputTextView{
    
    NSDictionary * jsDic = [NSDictionary dictionaryWithObject:messageInputTextView.text forKey:@"emojiconsText"];
    
    
    [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onCommit" arguments:ACArgsPack(jsDic.ac_JSONFragment)];
    [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onCommitJson" arguments:ACArgsPack(jsDic)];
    

    
    [messageInputTextView resignFirstResponder];
    [messageInputTextView setText:nil];
    
    [self inputTextViewDidChange:messageInputTextView];
    
}




#pragma end
#pragma mark - ZBMessageFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    NSString * oldMsg = self.messageToolView.messageInputTextView.text;
    if (dele && [oldMsg length] > 0) {
        
        [self.messageToolView.messageInputTextView deleteBackward];
        
    } else if (!dele) {
        
        self.messageToolView.messageInputTextView.text = [oldMsg stringByAppendingString:faceStr];
        [self inputTextViewDidChange:self.messageToolView.messageInputTextView];
        
    }
    
}
#pragma end


-(void)doActionWithSelectShareMenuItemIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            //
            break;
        case 1:
            //
            break;
        case 2:
            //
            break;
    }
    
}



#pragma mark - ZBMessageShareMenuView Delegate
- (void)didSelecteShareMenuItem:(InputZBMessageShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    NSString *jsStr = [NSString stringWithFormat:@"if(uexInputTextFieldView.onShareMenuItem!=null){uexInputTextFieldView.onShareMenuItem(%d);}", (int)index];
    [[self.uexObj.webViewEngine webView] stringByEvaluatingJavaScriptFromString:jsStr];
    [self doActionWithSelectShareMenuItemIndex:index];
    [self messageViewAnimationWithMessageRect:CGRectZero
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:0.25
                                     andState:ZBMessageViewStateShowNone];
    
}
#pragma end

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardShouldHide = YES;
    [self messageViewAnimationWithMessageRect:CGRectZero
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:0.25
                                     andState:ZBMessageViewStateShowNone];
    
}

- (void)keyboardWillShow:(NSNotification *)notification{

    self.keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardChange:(NSNotification *)notification{

    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight([self.uexObj.webViewEngine webView].frame)) {
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:0.25
                                         andState:ZBMessageViewStateShowNone];
    
    }
}

-(void)willCancelRecordingVoiceAction{
    //
}

-(void)stopCancelRecordingVoiceAction{
    
}

-(void)didTimeOut{
    
    NSDictionary *cbDic = @{
                            @"status":@2,
                            @"voicePath":@2
                            };
    [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onVoiceAction" arguments:ACArgsPack(cbDic.ac_JSONFragment)];
    
    _messageToolView.holdDownButton.selected = NO;
    _messageToolView.holdDownButton.highlighted = NO;
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction{
    NSDictionary *cbDic = @{
                            @"status":@0,
                            @"voicePath":@0
                            };
    [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onVoiceAction" arguments:ACArgsPack(cbDic.ac_JSONFragment)];
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction{
    NSDictionary *cbDic = @{
                            @"status":@-1,
                            @"voicePath":@-1
                            };
    [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onVoiceAction" arguments:ACArgsPack(cbDic.ac_JSONFragment)];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction{
    
    NSDictionary *cbDic = @{
                            @"status":@1,
                            @"voicePath":@1
                            };
    [self.uexObj.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.onVoiceAction" arguments:ACArgsPack(cbDic.ac_JSONFragment)];

    
}

- (void)hideKeyboard {
    _keyboardShouldHide = YES;
    [self.messageToolView.messageInputTextView resignFirstResponder];
    
    if (CGRectGetMaxY(self.messageToolView.frame) < UEX_SCREENHEIGHT - _bottomOffset) {
        
        [self messageViewAnimationWithMessageRect:CGRectZero
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:self.animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }

}



@end
