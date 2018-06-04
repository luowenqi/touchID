//
//  TouchID.m
//  TouchID
//
//  Created by lwq on 2018/5/31.
//  Copyright © 2018年 lwq. All rights reserved.
//

#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>

@implementation TouchID

+(instancetype)shared{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[TouchID alloc]init];
    });
    return shared;
}

-(void)verifyTouchID:(void(^)(BOOL state, NSString* message))callback{
    __block  BOOL verifyState = NO;
    __block  NSString * verifyMessage = @"";
    if ([[UIDevice currentDevice] systemVersion].floatValue <8.0) {
        NSLog(@"系统版本过低,不支持指纹识别");
        verifyState = NO;
        verifyMessage = @"系统版本过低,不支持指纹识别";
        callback(verifyState,verifyMessage);
    }else{
        LAContext* context = [LAContext new]; //获取一个上下文
        NSError* error = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {//判断当前设备是否支持指纹识别,可能存在指纹识别损坏,部分ipad没有指纹识别
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"这里是弹窗的内容,一般填写为什么请求指纹识别" reply:^(BOOL success, NSError * _Nullable error) {//请求指纹识别,成功或者失败的回调
                if (success) {//指纹识别成功
                    verifyState = YES;
                    verifyMessage = @"通过指纹识别";
                }else if (error){
                    switch (error.code) {
                            verifyState = NO;
                        case LAErrorAuthenticationFailed:
                            verifyMessage = @"连续三次指纹识别错误,授权失败";
                            break;
                        case LAErrorUserCancel:
                            verifyMessage = @"在TouchID对话框中点击了取消按钮,授权失败";
                            break;
                        case LAErrorUserFallback:
                            verifyMessage = @"在TouchID对话框中点击了输入密码按钮,授权失败";
                            break;
                        case LAErrorSystemCancel:
                             verifyMessage = @"TouchID对话框被系统取消，例如按下Home或者电源键,授权失败";
                            break;
                        case LAErrorAppCancel:
                             verifyMessage = @"被其他APP中断验证,比方说忽然来电话,切换到其他APP,授权失败";
                            break;
                        case LAErrorInvalidContext:
                             verifyMessage = @"指纹识别请求失效,授权失败";
                            break;
                        default:
                             verifyMessage = @"指纹识别请求失效,授权失败";
                            break;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{//必须在主线程中操作
                    callback(verifyState,verifyMessage);
                });
            }];
            
        }else{//当前不支持指纹识别
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled:
                    verifyMessage = @"设备支持指纹识别,但是未设置指纹";
                    break;
                case LAErrorPasscodeNotSet:
                     verifyMessage = @"设备支持指纹识别,但是未设置密码";
                    break;
                case LAErrorTouchIDLockout: /// 再本软件连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    verifyMessage = @"Touch ID被锁，需要用户先在锁屏界面输入密码才能再次启用touchID";
                    break;
                default:
                    verifyMessage = @"当前设备指纹识别不可用";
                    break;
                    //其他的指纹识别失败情况统统归纳为指纹识别不可用
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(verifyState,verifyMessage);
            });
        }
    }
}




@end
