//
//  AFNetworkingClient.m
//  HSWWWallpaper
//
//  Created by tusm on 16/6/15.
//  Copyright © 2016年 tusm. All rights reserved.
//

#import "AFNetworkingClient.h"

@implementation AFNetworkingClient


// post
+(void)postWithPath:(NSString *)path WithParams:(NSDictionary *)params withCallBack:(HDCallBack)myCallback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        myCallback(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        myCallback(error);
    }];
}

//Get
+(void)getWithPath:(NSString *)path withCallBack:(HDCallBack)myCallback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        myCallback(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        myCallback(error);
    }];
}

+(void)toApplyForFinishWithDic:(NSDictionary *)dic andImageData:(NSData *)imageData andpath:(NSString *)path andCallback:(HDCallBack)myCallback{
    NSDictionary *params = dic;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"pic[]" fileName:@"aaa.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        myCallback(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        myCallback(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        myCallback(error);
    }];
}

@end
