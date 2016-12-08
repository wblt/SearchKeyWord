//
//  SearchKeyWordView.h
//  HSWWWallpaper
//
//  Created by tusm on 16/10/18.
//  Copyright © 2016年 tusm. All rights reserved.
//

#define WIDTHDiv  [UIScreen mainScreen ].bounds.size.width
#define HEIGHTDiv  [ UIScreen mainScreen ].bounds.size.height

#import <UIKit/UIKit.h>

@protocol SearchKeyWordViewDelegate <NSObject>
//点击了某个搜索记录
-(void)searchViewClickOnTheKeyWord:(NSString *)keyWord;
//删除某个搜索记录
-(void)deleteKeywordClickOnTheKeyWord:(NSString *)keyWord andIndexPath:(NSIndexPath *)indexPath;
//删除所有搜索记录
-(void)clearAllKeywoed;
//隐藏键盘
-(void)hideKeyboard;
//热搜回调的关键字数组tag
-(void)superTopSearchViewClickWithTag:(NSInteger)tag;

@end

@interface SearchKeyWordView : UIView
//刷新搜索关键字列表
-(void)refView;
//局部刷新搜索关键字
-(void)refViewByTheIndexPath:(NSIndexPath *)indexPath;
//判断热搜有没有数据
-(BOOL)isTopViewData;
//给热搜赋值
-(void)TopViewGetData:(NSArray *)arrs;
//根据topView回调的tag 从topView取到搜索关键字
-(NSString *)TopViewComesBackKeywordByTag:(NSInteger)tag;

@property(nonatomic,weak)id <SearchKeyWordViewDelegate>delegate;
@property(nonatomic,strong)NSArray *LabTitleStrs;//关键字数据源
@end
