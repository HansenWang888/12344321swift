//
//  LoginNetwork.m
//  ID贷
//
//  Created by apple on 2019/6/19.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "LoginNetwork.h"

@implementation LoginNetwork

+ (instancetype)loginWithMobile:(NSString *)mobile time:(NSString *)timeStamp md5:(NSString *)md5 app:(NSString *)appName model:(NSString *)phoneType version:(NSString *)version imei:(NSString *)uuid {
    
    LoginNetwork *obj = [LoginNetwork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/user/facebooklogin";
    obj.xdf_requestArgument = @{
                                @"mobile" : mobile,
                                @"times" : timeStamp,
                                @"md5" : md5,
                                @"app" : appName,
                                @"model" : phoneType,
                                @"version" : version,
                                @"imei" : uuid,
                                };
    obj.xdf_requestMethod = YTKRequestMethodPOST;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

@end
