//
//  UIAlertController+dy_extension.m
//  ID贷
//
//  Created by apple on 2019/6/24.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "UIAlertController+dy_extension.h"

@implementation UIAlertController (dy_extension)


+ (instancetype)showCustomAlertWithTitle:(NSString *)title messgae:(NSString *)message confirmTitle:(NSString *)confirmTitle cancleTitle:(NSString *)cancleTitle confirmCallback:(void (^)(void))callback {
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        callback();
    }];
    [vc addAction:confirm];
    [vc addAction:[UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:nil]];

    return vc;
}
@end
