//
//  AFNetworkingClient.h
//  HSWWWallpaper
//
//  Created by tusm on 16/6/15.
//  Copyright © 2016年 tusm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void (^HDCallBack)(id obj);
@interface AFNetworkingClient : NSObject
+(void)getWithPath:(NSString *)path withCallBack:(HDCallBack)myCallback;
+(void)postWithPath:(NSString *)path WithParams:(NSDictionary *)params withCallBack:(HDCallBack)myCallback;
@end
