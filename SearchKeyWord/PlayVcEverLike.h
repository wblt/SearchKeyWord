//
//  PlayVcEverLike.h
//  MTV
//
//  Created by tusm on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@interface PlayVcEverLike : NSObject

+(void)clearVids;//清除所有

+(BOOL)isLikeByVid:(NSString *)vid;//查询是否存储

+(void)writeToFileDocumentPathByVid:(NSString *)vid;//写入字段,如已包含,将置顶

+(void)clearVidByVid:(NSString *)vid;//删除某字段

+(NSArray *)getVids;//获取字段数组

@end
