//
//  ZBFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "InputZBFaceView.h"
#import "InputChatKeyboardData.h"

#define NumPerLine 7
#define Lines    3
#define FaceSize  24
/*
** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 5

@implementation InputZBFaceView

- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index facePath:(NSString *)facePath
{
    self = [super initWithFrame:frame];
    if (self) {
        // 水平间隔
        CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSize -2*EdgeDistance)/(NumPerLine-1);
        // 上下垂直间隔
        CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSize)/(Lines-1);
        
        NSLog(@"%f,%f",verticalInterval,CGRectGetHeight(self.bounds));
        
        for (int i = 0; i<Lines; i++)
        {
            for (int x = 0;x<NumPerLine;x++)
            {
                UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:expressionButton];
                [expressionButton setFrame:CGRectMake(x*FaceSize+EdgeDistance+x*horizontalInterval,
                                                      i*FaceSize +i*verticalInterval+EdgeInterVal,
                                                      FaceSize,
                                                      FaceSize)];
                
                if (index*20+i*7+x > [[InputChatKeyboardData sharedChatKeyboardData].faceImgArray count]) {
                    return self;
                } else if (index*20+i*7+x == [[InputChatKeyboardData sharedChatKeyboardData].faceImgArray count]) {
                    NSString * imgPath = [NSString stringWithFormat:@"%@%@",[InputChatKeyboardData sharedChatKeyboardData].facePath,[InputChatKeyboardData sharedChatKeyboardData].deleteImg];
                    UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
                    [expressionButton setBackgroundImage:image forState:UIControlStateNormal];
                    expressionButton.tag = 0;
                    
                } else if (i*7+x+1 ==21) {
                    NSString * imgPath = [NSString stringWithFormat:@"%@%@",[InputChatKeyboardData sharedChatKeyboardData].facePath,[InputChatKeyboardData sharedChatKeyboardData].deleteImg];
                    UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
                    [expressionButton setBackgroundImage:image forState:UIControlStateNormal];
                    expressionButton.tag = 0;
        
                }else{
                    NSString * imgStr = [[[InputChatKeyboardData sharedChatKeyboardData].faceImgArray objectAtIndex:(int)index*20+i*7+x] objectForKey:@"text"];
                    NSString *imageStr = [NSString stringWithFormat:@"%@%@",[InputChatKeyboardData sharedChatKeyboardData].facePath,imgStr];
                    [expressionButton setBackgroundImage:[UIImage imageWithContentsOfFile:imageStr] forState:UIControlStateNormal];
                    expressionButton.tag = 20*index+i*7+x+1;
                }
                [expressionButton addTarget:self
                                     action:@selector(faceClick:)
                           forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return self;
}

- (void)faceClick:(UIButton *)button {
    
    NSString *faceName;
    BOOL isDelete;
    if (button.tag ==0){
        faceName = nil;
        isDelete = YES;
    }else{
       faceName = [[[InputChatKeyboardData sharedChatKeyboardData].faceArray objectAtIndex:(int)button.tag-1] objectForKey:@"text"];
       isDelete = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelecteFace:andIsSelecteDelete:)]) {
        [self.delegate didSelecteFace:faceName andIsSelecteDelete:isDelete];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
