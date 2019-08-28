//
//  HomeNetWork.m
//  ID贷
//
//  Created by 吴祖辉 on 2019/6/21.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "HomeNetWork.h"

@implementation HomeNetWork

+ (instancetype)getObtainAuthentication
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/user/getauth";
    obj.xdf_requestArgument = @{};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getMyquato
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/apply/getmyquato";
    obj.xdf_requestArgument = @{@"model":[NSString getCurrentDeviceModel]};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getMyReturn
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/apply/getmyretrun";
    obj.xdf_requestArgument = @{};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)saveMyApplyWithMoney:(NSString *)money andDid:(NSString *)did
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/apply/savemyapply";
    obj.xdf_requestArgument = @{@"money":money,@"did":did};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getMyApplyWithModel:(NSString *)model andDid:(NSString *)did
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/apply/getmyapply";
    obj.xdf_requestArgument = @{@"model":model,@"did":did};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)saveMyReturn
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/apply/savemyretrun";
    obj.xdf_requestArgument = @{};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

+ (instancetype)getOrderWithOrderId:(NSString *)orderId
{
    HomeNetWork *obj = [HomeNetWork new];
    obj.xdf_baseURL = kBaseURL;
    obj.xdf_requestUrl = @"/apply/getorder";
    obj.xdf_requestArgument = @{@"orderid":orderId};
    obj.xdf_requestMethod = YTKRequestMethodGET;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
    
    return obj;
}

@end
