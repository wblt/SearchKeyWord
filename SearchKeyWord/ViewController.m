//
//  ViewController.m
//  SearchKeyWord
//
//  Created by tusm on 16/11/28.
//  Copyright © 2016年 yjh. All rights reserved.
//



#import "ViewController.h"
#import "SearchKeyWordView.h"
#import "HSWWApi.h"
#import "PlayVcEverLike.h"

@interface ViewController ()<UISearchBarDelegate,SearchKeyWordViewDelegate>
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)SearchKeyWordView *skView;
@end

@implementation ViewController

//点击了某个搜索记录
-(void)searchViewClickOnTheKeyWord:(NSString *)keyWord{
    [self searchByKeyword:keyWord];
    self.searchBar.text = keyWord;
}
//删除某个搜索记录
-(void)deleteKeywordClickOnTheKeyWord:(NSString *)keyWord andIndexPath:(NSIndexPath *)indexPath{
    [PlayVcEverLike clearVidByVid:keyWord];
    self.skView.LabTitleStrs = [PlayVcEverLike getVids];
    [self.skView refViewByTheIndexPath:indexPath];
}
//删除所有搜索记录
-(void)clearAllKeywoed{
    [PlayVcEverLike clearVids];
    [self reloadSearch];
}

//隐藏键盘
-(void)hideKeyboard{
    [self.searchBar resignFirstResponder];
}
//热搜回调的关键字数组tag
-(void)superTopSearchViewClickWithTag:(NSInteger)tag{
    [self searchByKeyword:[self.skView TopViewComesBackKeywordByTag:tag]];
    self.searchBar.text = [self.skView TopViewComesBackKeywordByTag:tag];
}

-(void)searchByKeyword:(NSString *)keyWord{
    [PlayVcEverLike writeToFileDocumentPathByVid:keyWord];
    [self.searchBar resignFirstResponder];
}

-(void)reloadSearch{
    self.skView.LabTitleStrs = [PlayVcEverLike getVids];
    [self.skView refView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,0,0)];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = self.searchBar;
    
    self.skView = [[SearchKeyWordView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.skView.delegate = self;
//    self.skView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.skView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)GetKeyWordData{
    [HSWWApi GetSearchkeywordCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [self.skView TopViewGetData:obj];
        }
    }];
}

//searchBar 响应键盘
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if ([self.skView isTopViewData]) {
        [self GetKeyWordData];
    }
    [self reloadSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchByKeyword:searchBar.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
