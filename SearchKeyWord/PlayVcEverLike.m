//
//  PlayVcEverLike.m
//  MTV
//
//  Created by tusm on 16/7/28.
//
//

#import "PlayVcEverLike.h"

@implementation PlayVcEverLike
/*
    Vids.dat 只是文件名,如需储存多个文件 在个方法传入文件名即可,
    文件名可用宏的形式传入
*/
+(void)clearVidByVid:(NSString *)vid{
    NSString *CachesPath = [self getDocumentPath];
    NSString *fileName = @"Vids.dat";
    NSString *filePath = [CachesPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (value) {
        NSArray *VidArrs = [NSMutableArray arrayWithArray:[value componentsSeparatedByString:@"&&"]];
        NSMutableString *keywordsMuT = [NSMutableString string];
        int i = 0;
        for (NSString *Str in VidArrs) {
            if (![vid isEqualToString:Str]) {
                if (i == 0) {
                    [keywordsMuT appendString:[NSString stringWithFormat:@"%@",Str]];
                }else{
                    [keywordsMuT appendString:[NSString stringWithFormat:@"&&%@",Str]];
                }
                i++;
            }
        }
        NSString *keywords = keywordsMuT.description;
        NSData *wordData = [keywords dataUsingEncoding:NSUTF8StringEncoding];
        [wordData writeToFile:filePath atomically:YES];
    }
}

+(BOOL)isLikeByVid:(NSString *)vid{
    BOOL isLike = NO;
    NSString *CachesPath = [self getDocumentPath];
    NSString *fileName = @"Vids.dat";
    NSString *filePath = [CachesPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (value) {
        NSArray *VidArrs = [NSMutableArray arrayWithArray:[value componentsSeparatedByString:@"&&"]];
        for (NSString *docStr in VidArrs) {
            if ([docStr isEqualToString:vid]) {
                isLike = YES;
            }
        }
    }
    return isLike;
}

+(void)writeToFileDocumentPathByVid:(NSString *)vid{
    NSString *CachesPath = [self getDocumentPath];
    NSString *fileName = @"Vids.dat";
    NSString *filePath = [CachesPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        NSData *wordData = [vid dataUsingEncoding:NSUTF8StringEncoding];
        [wordData writeToFile:filePath atomically:YES];
    }else{
        if ([self isLikeByVid:vid]) {
            [self clearVidByVid:vid];
        }
        NSData *newData = [NSData dataWithContentsOfFile:filePath];
        NSString *value = [[NSString alloc]initWithData:newData encoding:NSUTF8StringEncoding];
        NSMutableString *keywordsMuT = [NSMutableString stringWithFormat:@"%@",value];
        [keywordsMuT appendString:[NSString stringWithFormat:@"&&%@",vid]];
        NSString *keywords = keywordsMuT.description;
        NSData *wordData = [keywords dataUsingEncoding:NSUTF8StringEncoding];
        [wordData writeToFile:filePath atomically:YES];
    }
}

+(NSArray *)getVids{
    NSString *CachesPath = [self getDocumentPath];
    NSString *fileName = @"Vids.dat";
    NSString *filePath = [CachesPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *VidArrs = [NSMutableArray arrayWithArray:[value componentsSeparatedByString:@"&&"]];
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSString *str in VidArrs) {
            if (![str isEqualToString:@""]) {
                [mutArr addObject:str];
            }
        }
        return [[mutArr reverseObjectEnumerator] allObjects];
    }
    return [NSArray array];
}

+(void)clearVids{
    NSString *CachesPath = [self getDocumentPath];
    NSString *fileName = @"Vids.dat";
    NSString *filePath = [CachesPath stringByAppendingPathComponent:fileName];
    NSString *keywords = @"";
    NSData *wordData = [keywords dataUsingEncoding:NSUTF8StringEncoding];
    [wordData writeToFile:filePath atomically:YES];
}

+(NSString *)getDocumentPath{
    NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocumentPath = pathes[0];
    return DocumentPath;
}


@end
