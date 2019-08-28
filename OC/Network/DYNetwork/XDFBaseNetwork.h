//
//  WNBaseNetwork.h
//  项目常用设定
//
//  Created by Hansen on 2018/11/8.
//  Copyright © 2018 ma c. All rights reserved.
//

#import "YTKRequest.h"
#import "XDFNetworkError.h"
#import "XDFNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFBaseNetwork : YTKRequest
///域名
@property (nonatomic, copy) NSString *xdf_baseURL;
///相对路径
@property (nonatomic, copy) NSString *xdf_requestUrl;
///请求参数
@property (nonatomic, copy) id xdf_requestArgument;
///请求方式
@property (nonatomic, assign) YTKRequestMethod xdf_requestMethod;
///缓存时间 默认不缓存 单位：秒
@property (nonatomic, assign) NSUInteger xdf_cacheTimeInSeconds;
///验证返回数据
@property (nonatomic, copy) NSDictionary *xdf_jsonValidator;
///超时时间 默认60s
@property (nonatomic, assign) NSTimeInterval xdf_requestTimeout;
///请求参数的解析方式 默认json
@property (nonatomic, assign) YTKRequestSerializerType xdf_requestSerializerType;
///回参的返回方式 默认json
@property (nonatomic, assign) YTKResponseSerializerType xdf_responseSerializerType;
/**请求头*/
@property (nonatomic, copy) NSDictionary *xdf_requestHeaderFieldValueDictionary;
/**上传文件s使用*/
@property (nonatomic,copy) AFConstructingBlock xdf_constructingBodyBlock;


/*
 *统一调用 对返回进行统一处理
 *
 *@param response 返回数据 已经是从字典中取出的data
 *@param error 错误信息
 */
- (void)xdf_startRequestWithFinished:(void(^)(id  responseObject,XDFNetworkError *error))finished;

/*
 *统一调用 对返回进行统一处理
 *
 *@param response 返回数据 已经是从字典中取出的data
 *@param error1 业务错误信息
 *@param error2 接口错误信息
 */
- (void)xdf_startRequestWithSuccessful:(void(^)(id  responseObject,XDFNetworkError *error))successful failing:(void(^)(XDFNetworkError *error))failing;

/*
*只返回成功的回调，出现错误会弹出提示
*
*@param response 返回数据 已经是从字典中取出的data
*/
- (void)xdf_startRequestWithSuccessful:(void(^)(id  responseObject))successful;

///统一调用 无处理
- (void)xdf_startRequestWithCompleted:(void (^)(YTKBaseRequest *request))Completed;


- (BOOL)isAvailableNetwork;
@end






NS_ASSUME_NONNULL_END
