//
//  GSTextField.m
//  testKeyboard
//
//  Created by gongsheng on 16/8/1.
//  Copyright © 2016年 gongsheng. All rights reserved.
//

#import "GSNumberTextField.h"

@interface GSNumberTextField ()

/** 小数点按钮 */
@property (nonatomic, strong) UIButton *pointButton;

@end

@implementation GSNumberTextField


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self settingTextField];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self settingTextField];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self settingTextField];
    }
    return self;
}

- (void)settingTextField
{
    self.keyboardType = UIKeyboardTypeNumberPad;
}


#pragma mark - 键盘的位置发生改变
- (void)keyboardWillChange:(NSNotification *)notification
{
    
//    NSLog(@"%@", notification);

    [self addPointButton];

}

#pragma mark - 添加小数点
- (void)addPointButton
{
    if (_pointButton) return;//防止重复添加
    
    UIWindow *keyboardWindow = [[UIApplication sharedApplication].windows lastObject];
    UIView *keyboard = [self findKeyView:@"UIKBKeyplaneView" inView:keyboardWindow];
    
    if (keyboardWindow) {
        UIView *numButton = [keyboard.subviews lastObject];
        CGSize pointSize = numButton.bounds.size; //获取数字按钮的大小
        
        UIView *pointView;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        for (UIView *view in keyboard.subviews) {
            CGPoint point = [keyboard convertPoint:view.center toView:[UIApplication sharedApplication].keyWindow];
            if (point.x < pointSize.width && point.y > screenHeight - pointSize.height) {
                pointView = view;
                break;
            }
        }
        if (!pointView) {
            return;
        }
        UIButton *button = [[UIButton alloc] initWithFrame:pointView.bounds];
        [button setTitle:@"·" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:45];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(pointButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(pointButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(pointButtonOutSide:) forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpOutside];
        
        self.pointButton = button;
        
        pointView.userInteractionEnabled = YES;
        [pointView addSubview:button];
        
    }
    
}


#pragma mark - 找到小数点对应位置的方法
- (UIView *)findKeyView:(NSString *)name inView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        NSString *className = NSStringFromClass([subView class]);
        
        if ([className isEqualToString:name]) {
            return subView;
        } else {
            UIView *subView_2 = [self findKeyView:name inView:subView];
            if (subView_2) {
                return subView_2;
            }
        }
    }
    return nil;
}


#pragma mark - 小数点按钮的点击事件
/** 按钮点击 */
- (void)pointButtonClick:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.text];
    if ([text containsString:@"."]) {
        return;
    }
    if (text.length == 0) {
        [text appendString:@"0"];
    }
    [text appendString:@"."];
    self.text = text;
}
- (void)pointButtonTouchDown:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
}
- (void)pointButtonOutSide:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
}


#pragma mark - 移除小数点按钮
- (void)removePointButton
{
    /** 每次键盘收起的时候移除小数点 */
    [self.pointButton removeFromSuperview];
    self.pointButton = nil;

}

#pragma mark - 开始编辑
- (BOOL)becomeFirstResponder
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    return  [super becomeFirstResponder];
}


#pragma mark - 结束编辑
- (BOOL)resignFirstResponder
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removePointButton];
    
    return [super resignFirstResponder];
}



- (void)removeFromSuperview
{
    NSLog(@"------");
    
    
}
- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
