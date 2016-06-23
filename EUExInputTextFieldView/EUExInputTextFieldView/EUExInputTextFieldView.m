//
//  EUExInputTextFieldView.m
//  EUExInputTextFieldView
//
//  Created by xurigan on 15/3/9.
//  Copyright (c) 2015年 com.zywx. All rights reserved.
//

#import "EUExInputTextFieldView.h"
#import "InputChatKeyboard.h"
#import "InputXMLReader.h"
#import "InputChatKeyboardData.h"

@interface EUExInputTextFieldView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) InputChatKeyboard * chatKeyboard;
@property (nonatomic, strong) NSString * delete;
@property (nonatomic, strong) NSString * pageNum;
@property (nonatomic, strong) UITapGestureRecognizer * tapGR;
@end

@implementation EUExInputTextFieldView




- (instancetype)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine{
    self = [super initWithWebViewEngine:engine];
    if (self) {
        
    }
    return self;
}

-(void)clean {
    if (_tapGR) {
        
        _tapGR.delegate = nil;
        _tapGR = nil;
    }
    if (_chatKeyboard) {
        [_chatKeyboard close];
        _chatKeyboard = nil;
    }
}

-(void)open:(NSMutableArray *)inArguments {
    InputChatKeyboardData *chatKeyboardData = [InputChatKeyboardData sharedChatKeyboardData];
    
    ACArgsUnpack(NSDictionary *xmlDic) = inArguments;
    
    NSString * xmlPath = [self absPath:[xmlDic objectForKey:@"emojicons"]];
    
    NSString * placeHold = @"";
    if ([xmlDic objectForKey:@"placeHold"]) {
        placeHold = [xmlDic objectForKey:@"placeHold"];
    }
    chatKeyboardData.placeHold = placeHold;
    [self getFaceDicByFaceXMLPath:xmlPath];
    
    NSArray * facePathArray = [xmlPath componentsSeparatedByString:@"/"];
    NSString * fileName = [facePathArray lastObject];
    NSRange range = [xmlPath rangeOfString:fileName];
    xmlPath = [xmlPath substringToIndex:range.location];
    chatKeyboardData.facePath = xmlPath;
    
    float textSize = 30.0;
    if ([xmlDic objectForKey:@"textSize"]) {
        textSize = [[xmlDic objectForKey:@"textSize"] floatValue];
    }
    BOOL isAudio=NO;
    if([xmlDic objectForKey:@"inputMode"]&&[[xmlDic objectForKey:@"inputMode"] integerValue]==1){
        isAudio=YES;
    }
    UIColor * sendBtnbgColorUp = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
    if ([xmlDic objectForKey:@"sendBtnbgColorUp"]) {
        NSString * sendBtnbgColorUpStr = [xmlDic objectForKey:@"sendBtnbgColorUp"];
        sendBtnbgColorUp = [UIColor ac_ColorWithHTMLColorString:sendBtnbgColorUpStr];
    }
    UIColor * sendBtnbgColorDown = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    if ([xmlDic objectForKey:@"sendBtnbgColorDown"]) {
        NSString * sendBtnbgColorDownStr = [xmlDic objectForKey:@"sendBtnbgColorDown"];
        sendBtnbgColorDown = [UIColor ac_ColorWithHTMLColorString:sendBtnbgColorDownStr];
    }
    NSString * sendBtnText = @"发送";
    if ([xmlDic objectForKey:@"sendBtnText"]) {
        sendBtnText = [NSString stringWithFormat:@"%@",[xmlDic objectForKey:@"sendBtnText"]];
    }
    float sendBtnTextSize = 14.0;
    if ([xmlDic objectForKey:@"sendBtnTextSize"]) {
        sendBtnTextSize = [[xmlDic objectForKey:@"sendBtnTextSize"] floatValue];
    }
    UIColor * sendBtnTextColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    if ([xmlDic objectForKey:@"sendBtnTextColor"]) {
        NSString * sendBtnTextColorStr = [xmlDic objectForKey:@"sendBtnTextColor"];
        sendBtnTextColor = [UIColor ac_ColorWithHTMLColorString:sendBtnTextColorStr];
    }

    chatKeyboardData.sendBtnbgColorUp = sendBtnbgColorUp;
    chatKeyboardData.sendBtnbgColorDown = sendBtnbgColorDown;
    chatKeyboardData.sendBtnText = sendBtnText;
    chatKeyboardData.sendBtnTextSize = sendBtnTextSize;
    chatKeyboardData.sendBtnTextColor = sendBtnTextColor;
    
    if (!_chatKeyboard) {
        _chatKeyboard = [[InputChatKeyboard alloc]initWithUexobj:self];
        if([xmlDic objectForKey:@"bottom"]){
            _chatKeyboard.bottomOffset=[[xmlDic objectForKey:@"bottom"] floatValue];
        }
        [_chatKeyboard open];
        _tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
        [[self.webViewEngine webView]addGestureRecognizer:_tapGR];
        _tapGR.delegate = self;
    
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)hideKeyboard:(NSMutableArray*)inArguments {
    
    if (_chatKeyboard) {
        
        [_chatKeyboard hideKeyboard];
        
    }
    
}

- (void)changeWebViewFrame:(NSMutableArray *)inArguments {
    float h = [inArguments.firstObject floatValue];
    if (_chatKeyboard) {
        [_chatKeyboard changeWebView:h];
    }
}

-(void)getShareDicFromSharePath:(NSString *)sharePath
{
    NSData * xmlData = [NSData dataWithContentsOfFile:sharePath];
    NSError * error;
    NSDictionary * xmlDic = [InputXMLReader dictionaryForXMLData:xmlData error: &error];
    NSDictionary * tempDic = [xmlDic objectForKey:@"shares"];
    [InputChatKeyboardData sharedChatKeyboardData].shareArray = [tempDic objectForKey:@"key"];
    [InputChatKeyboardData sharedChatKeyboardData].shareImgArray = [tempDic objectForKey:@"string"];
    [InputChatKeyboardData sharedChatKeyboardData].pageNum = [tempDic objectForKey:@"prePageNum"];
    
}

-(NSMutableDictionary *)getDicByKeyArray:(NSArray *)keyArray andStringArray:(NSArray *)stringArray
{
    NSMutableDictionary * reDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < [keyArray count]; i++)
    {
        NSString * key = [[keyArray objectAtIndex:i] objectForKey:@"text"];
        NSString * string = [[stringArray objectAtIndex:i] objectForKey:@"text"];
        [reDic setObject:string forKey:key];
    }
    return reDic;
}

-(void)getFaceDicByFaceXMLPath:(NSString *)xmlPath
{
    NSData * xmlData = [NSData dataWithContentsOfFile:xmlPath];
    NSError * error;
    NSDictionary * xmlDic = [InputXMLReader dictionaryForXMLData:xmlData error: &error];
    NSDictionary * emojiconsDic = [xmlDic objectForKey:@"emojicons"];
    [InputChatKeyboardData sharedChatKeyboardData].faceArray = [emojiconsDic objectForKey:@"key"];
    [InputChatKeyboardData sharedChatKeyboardData].faceImgArray = [emojiconsDic objectForKey:@"string"];
    [InputChatKeyboardData sharedChatKeyboardData].deleteImg = [emojiconsDic objectForKey:@"delete"];
}

-(void)close:(NSMutableArray *)inArguments {
    if (_chatKeyboard) {
        [_chatKeyboard close];
        _chatKeyboard = nil;
    }
}

-(void)setInputFocused:(NSMutableArray *)inArguments {
    [_chatKeyboard.messageToolView.messageInputTextView becomeFirstResponder];

}

- (NSNumber *)getInputBarHeight:(NSMutableArray *)inArguments{
    CGFloat height = 40.f;
    if(ACSystemVersion() >= 7.0){
        height = 45.f;
    }
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexInputTextFieldView.cbGetInputBarHeight" arguments:ACArgsPack(@(height))];
    return @(height);
}

@end
