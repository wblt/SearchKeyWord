//
//  HSWWApi.h
//  HSWWWallpaper
//
//  Created by tusm on 16/7/2.
//  Copyright © 2016年 tusm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkingClient.h"
typedef void (^HSWWCallBack)(id obj);
@interface HSWWApi : NSObject
//获取搜索推荐关键字
+(void)GetSearchkeywordCallBack:(HSWWCallBack)callback;
@end
