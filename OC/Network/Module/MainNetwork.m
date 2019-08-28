//
//  MainNetwork.m
//  HX_Car_CLL
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "MainNetwork.h"

@implementation MainNetwork

+ (instancetype)calculateCarCost:(double)total type:(int)type rate:(float)rate year:(int)year {
    
    MainNetwork *obj = [MainNetwork new];
    obj.xdf_baseURL = @"https://www.xjzhuan.com";
    obj.xdf_requestUrl = @"/calcul/calcul";
    obj.xdf_requestArgument = @{
                                @"total" : @(total),
                                @"type" : @(type),
                                @"rate" : @(rate),
                                @"year" : @(year)
                                };
    obj.xdf_requestMethod = YTKRequestMethodPOST;
    obj.xdf_requestSerializerType = YTKRequestSerializerTypeHTTP;
    obj.xdf_responseSerializerType = YTKResponseSerializerTypeJSON;
   
    return obj;
    
}
@end
