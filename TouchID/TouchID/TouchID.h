//
//  TouchID.h
//  TouchID
//
//  Created by lwq on 2018/5/31.
//  Copyright © 2018年 lwq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchID : NSObject

+(instancetype)shared;
/**
 验证指纹

 回调为指纹识别结果,提示信息
 */
-(void)verifyTouchID:(void(^)(BOOL state, NSString* message))callback;

@end
