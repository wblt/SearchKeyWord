//
//  HSWWApi.m
//  HSWWWallpaper
//
//  Created by tusm on 16/7/2.
//  Copyright © 2016年 tusm. All rights reserved.
//

#import "HSWWApi.h"

@implementation HSWWApi


+(void)GetSearchkeywordCallBack:(HSWWCallBack)callback{
    NSString *path = [NSString stringWithFormat:@"http://api.app.27270.com/api/index.php?action=hotword"];
    [AFNetworkingClient getWithPath:path withCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = obj;
            if ([dic[@"code"] intValue] == 1) {
                NSArray *Arr = dic[@"data"];
                callback(Arr);
            }else{
                NSString *str = dic[@"msg"];
                callback(str);
            }
        }else{
            callback(@"获取推荐搜索关键字失败");
        }
    }];
}

@end
