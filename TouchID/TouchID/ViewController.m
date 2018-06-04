//
//  ViewController.m
//  TouchID
//
//  Created by lwq on 2018/5/31.
//  Copyright © 2018年 lwq. All rights reserved.
//

#import "ViewController.h"
#import "TouchID.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];  
}

- (IBAction)touchIDVerify:(UIButton *)sender {
    TouchID* touchid = [TouchID shared];
    [touchid verifyTouchID:^(BOOL state, NSString *message) {
        NSString* title = @"失败";
        if (state == YES) title = @"成功";
        UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {}];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
}




@end
