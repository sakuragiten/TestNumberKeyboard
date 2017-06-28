//
//  ViewController.m
//  TestNumberKeyboard
//
//  Created by gongsheng on 2017/6/28.
//  Copyright © 2017年 com.liwai.liwaiSupplier. All rights reserved.
//

#import "ViewController.h"
#import "GSNumberTextField.h"

@interface ViewController ()

/** 故事版当中的textField */
@property (weak, nonatomic) IBOutlet GSNumberTextField *sb_textFiled;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self test];
}


#pragma mark - 测试代码

- (void)test
{
    GSNumberTextField *textField = [[GSNumberTextField alloc] init];
    textField.frame = CGRectMake(30, 200, 90, 30);
    textField.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:textField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
