//
//  SearchKeyWordView.m
//  HSWWWallpaper
//
//  Created by tusm on 16/10/18.
//  Copyright © 2016年 tusm. All rights reserved.
//

#import "SearchKeyWordView.h"

@protocol TopSearchViewDelegate <NSObject>

-(void)TopSearchViewClickWithTag:(NSInteger)tag;

-(void)TapTheMargin;

//返回高度给持有者
-(void)comesBackHeight:(CGFloat)height;

@end

@interface TopSearchView : UIView

@property(nonatomic,weak)id<TopSearchViewDelegate>delegate;
@property(nonatomic,strong)NSArray *topKeywordArrs;
@end

//按钮横向间隙
static const NSInteger BITHI =10;

@interface TopSearchView()
@property(nonatomic,strong)UILabel *topTitleLab;
@property(nonatomic,strong)NSMutableArray *listRect;
@end

@implementation TopSearchView

-(UILabel *)topTitleLab{
    if (!_topTitleLab) {
        _topTitleLab = [UILabel new];
        _topTitleLab.text = @"你还可以搜这些...";
        _topTitleLab.hidden = YES;
        _topTitleLab.textAlignment = NSTextAlignmentLeft;
        _topTitleLab.backgroundColor = [UIColor clearColor];
        _topTitleLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
        _topTitleLab.font = [UIFont systemFontOfSize:15];
    }
    return _topTitleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.topKeywordArrs = [NSArray array];
        self.listRect = [NSMutableArray array];
        [self addSubview:self.topTitleLab];
    }
    return self;
}

-(void)setTopKeywordArrs:(NSArray *)topKeywordArrs{
    _topKeywordArrs = topKeywordArrs;
    [self comesBackHeight];//回调高度给持有者(Vc)
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

//计算高度
-(void)comesBackHeight{
    if (_topKeywordArrs.count > 0) {
        CGFloat x = 0;
        CGFloat y = 37.5;
        CGFloat h = [UIFont systemFontOfSize:[self getPropertyFont]].lineHeight+BITHI;
        CGFloat tx=[self GetWidthWithTag:0];
        for(NSInteger i = 0;i<_topKeywordArrs.count;i++){
            if (tx>WIDTHDiv-BITHI) {
                tx = [self GetWidthWithTag:i];
                x = 0;
                y+=h+BITHI;
            }
            CGFloat w = [self GetWidthWithTag:i];
            [self.listRect addObject:[NSValue valueWithCGRect:CGRectMake(x+BITHI, y, w-5, h)]];
            if (i!=_topKeywordArrs.count - 1) {
                tx+=[self GetWidthWithTag:i+1];
            }
            x+=w;
        }
        if ([self.delegate respondsToSelector:@selector(comesBackHeight:)]) {
            [self.delegate comesBackHeight:y+[UIFont systemFontOfSize:[self getPropertyFont]].lineHeight+15];
        }
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_topKeywordArrs.count > 0) {
        self.topTitleLab.hidden = NO;
        CGFloat x = 0;
        CGFloat y = 37.5;
        CGFloat h = [UIFont systemFontOfSize:[self getPropertyFont]].lineHeight+BITHI;
        CGFloat tx=[self GetWidthWithTag:0];
        for(NSInteger i = 0;i<_topKeywordArrs.count;i++){
            NSString *_text = _topKeywordArrs[i];
            if (tx>WIDTHDiv-BITHI) {
                tx = [self GetWidthWithTag:i];
                x = 0;
                y+=h+BITHI;
            }
            CGFloat w = [self GetWidthWithTag:i];
            
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x+BITHI, y, w-5, h) cornerRadius:5.0f];
            [self.listRect addObject:[NSValue valueWithCGRect:CGRectMake(x+BITHI, y, w-5, h)]];
            [[UIColor colorWithWhite:0.8 alpha:0.5] setStroke];
            [roundedRect strokeWithBlendMode:kCGBlendModeNormal alpha:1];
            
            UIFont  *font = [UIFont boldSystemFontOfSize:[self getPropertyFont]];
            NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment=NSTextAlignmentCenter;
            NSDictionary* attribute = @{ NSForegroundColorAttributeName:[UIColor colorWithWhite:.3 alpha:1], NSFontAttributeName:font, NSKernAttributeName:@0, NSParagraphStyleAttributeName:paragraphStyle,};
            CGSize sizeText = [_text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font, NSKernAttributeName:@0, } context:nil].size;
            CGRect rect = CGRectMake(x+6.8+(w-sizeText.width)/2, y+(h-sizeText.height)/2, sizeText.width, sizeText.height);
            [_text drawInRect:rect withAttributes:attribute];
            
            if (i!=_topKeywordArrs.count - 1) {
                tx+=[self GetWidthWithTag:i+1];
            }
            x+=w;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    for (int i = 0; i < self.listRect.count; i++) {
        CGRect rect = [self.listRect[i] CGRectValue];
        if (p.x > rect.origin.x&&p.x < rect.origin.x+rect.size.width&& p.y>rect.origin.y&&p.y<rect.origin.y+rect.size.height) {
            if ([self.delegate respondsToSelector:@selector(TopSearchViewClickWithTag:)]) {
                [self.delegate TopSearchViewClickWithTag:i];
                break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(TapTheMargin)]) {
                [self.delegate TapTheMargin];
            }
        }
    }
}

-(CGFloat)GetWidthWithTag:(NSInteger)tag{
    NSString *text = _topKeywordArrs[tag];
    CGFloat h = [UIFont systemFontOfSize:[self getPropertyFont]].lineHeight+BITHI;
    CGRect frame = [text boundingRectWithSize:CGSizeMake(999, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[self getPropertyFont]]} context:nil];
    return frame.size.width+40;
}

-(NSInteger)getPropertyFont{
    return 14;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _topTitleLab.frame = CGRectMake(20, 0, WIDTHDiv - 30, 35);
}

@end

@protocol SearchKeyWordViewCellDelegate <NSObject>

//添加tableview删除动画
-(void)deleteKeyWordWithSelf:(UITableViewCell *)cell andKeyWord:(NSString *)keyWord;

@end

@interface SearchKeyWordViewCell : UITableViewCell

@property(nonatomic,weak)id<SearchKeyWordViewCellDelegate>delegate;

@property(nonatomic,strong)UIButton *deleteKeyword;
@property(nonatomic,strong)UILabel *strLab;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,assign)BOOL lineEnd;
@end

@interface SearchKeyWordViewCell ()

@end

@implementation SearchKeyWordViewCell

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    }
    return _lineView;
}

-(UILabel *)strLab{
    if (!_strLab) {
        _strLab = [UILabel new];
        _strLab.textColor = [UIColor colorWithWhite:.5 alpha:1];
        _strLab.textAlignment = NSTextAlignmentLeft;
        _strLab.font = [UIFont systemFontOfSize:14.5];
    }
    return _strLab;
}

-(UIButton *)deleteKeyword{
    if (!_deleteKeyword) {
        _deleteKeyword = [UIButton new];
        [_deleteKeyword addTarget:self action:@selector(deleteKeywordClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [UIImageView new];
        img.image = [UIImage imageNamed:@"search_delete"];
        img.tag = 9580;
        [_deleteKeyword addSubview:img];
    }
    return _deleteKeyword;
}

-(void)deleteKeywordClick{
    if ([self.delegate respondsToSelector:@selector(deleteKeyWordWithSelf:andKeyWord:)]) {
        [self.delegate deleteKeyWordWithSelf:self andKeyWord:self.strLab.text];
    }
}

-(void)setLineEnd:(BOOL)lineEnd{
    _lineEnd = lineEnd;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.lineEnd = NO;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.deleteKeyword];
    [self.contentView addSubview:self.strLab];
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _deleteKeyword.frame = CGRectMake(self.frame.size.width - self.frame.size.height- 15, 0, self.frame.size.height, self.frame.size.height);
    UIImageView *imgv = [_deleteKeyword viewWithTag:9580];
    imgv.frame = CGRectMake((self.frame.size.height - 20)/2, (self.frame.size.height - 20)/2, 20, 20);
    _strLab.frame = CGRectMake(25, (self.frame.size.height - 30)/2, self.frame.size.width - 60, 30);
    _lineView.frame = CGRectMake(20, self.frame.size.height - 1, self.frame.size.width - 20, 1);
    if (_lineEnd) {
        _lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    }
}

@end


@interface SearchKeyWordView ()<UITableViewDataSource,UITableViewDelegate,SearchKeyWordViewCellDelegate,TopSearchViewDelegate>
@property(nonatomic,strong)TopSearchView *topView;
@property(nonatomic,strong)UIView *clearKeywordView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGFloat topViewHeight;
@end

@implementation SearchKeyWordView

#pragma mark - SearchKeyWordViewCellDelegate func

-(void)deleteKeyWordWithSelf:(UITableViewCell *)cell andKeyWord:(NSString *)keyWord{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(deleteKeywordClickOnTheKeyWord:andIndexPath:)]) {
        [self.delegate deleteKeywordClickOnTheKeyWord:keyWord andIndexPath:path];
    }
}

#pragma mark - TopSearchViewDelegate func

-(void)TopSearchViewClickWithTag:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(superTopSearchViewClickWithTag:)]) {
        [self.delegate superTopSearchViewClickWithTag:tag];
    }
}

-(void)TapTheMargin{
    if ([self.delegate respondsToSelector:@selector(hideKeyboard)]) {
        [self.delegate hideKeyboard];
    }
}

-(void)comesBackHeight:(CGFloat)height{
    _topViewHeight = height;
    [self setNeedsLayout];
}


#pragma mark - 自定义Vc调用函数

-(void)refViewByTheIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    if (self.LabTitleStrs.count > 0) {
        self.tableView.tableFooterView.hidden = NO;
        _clearKeywordView.hidden = NO;
    }else{
        self.tableView.tableFooterView.hidden = YES;
        _clearKeywordView.hidden = YES;
    }
}

-(void)refView{
    [self.tableView reloadData];
    if (self.LabTitleStrs.count > 0) {
        self.tableView.tableFooterView.hidden = NO;
        _clearKeywordView.hidden = NO;
    }else{
        self.tableView.tableFooterView.hidden = YES;
        _clearKeywordView.hidden = YES;
    }
}

-(void)TopViewGetData:(NSArray *)arrs{
    self.topView.topKeywordArrs = arrs;
}

-(BOOL)isTopViewData{
    if (self.topView.topKeywordArrs.count > 0) {
        return NO;
    }
    return YES;
}

-(NSString *)TopViewComesBackKeywordByTag:(NSInteger)tag{
    return self.topView.topKeywordArrs[tag];
}

#pragma mark - 系统视图代理函数

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(hideKeyboard)]) {
        [self.delegate hideKeyboard];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.LabTitleStrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchKeyWordViewCell *cell = (SearchKeyWordViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(searchViewClickOnTheKeyWord:)]) {
        [self.delegate searchViewClickOnTheKeyWord:cell.strLab.text];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 44;
    }
    return WIDTHDiv*.1;
}

static NSString *CellIdentifier = @"CELL";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchKeyWordViewCell *cell = [[SearchKeyWordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.delegate = self;
    cell.strLab.text = self.LabTitleStrs[indexPath.section];
    if (indexPath.section == self.LabTitleStrs.count - 1) {
        cell.lineEnd = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    return cell;
}

#pragma mark - 初始化视图函数

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _topViewHeight = 5;
//        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

-(TopSearchView *)topView{
    if (!_topView) {
        _topView = [TopSearchView new];
        _topView.delegate = self;
    }
    return _topView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:.95];
//        _tableView.backgroundColor = [UIColor clearColor];
        //                [_tableView setSeparatorColor:[UIColor whiteColor]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollsToTop = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView *)clearKeywordView{
    if (!_clearKeywordView) {
        _clearKeywordView  = [UIView new];
        _clearKeywordView.hidden = YES;
        UIButton *clear = [[UIButton alloc]initWithFrame:CGRectMake(80, 5, WIDTHDiv-160, 30)];
        [clear setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [clear setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
        clear.titleLabel.font = [UIFont systemFontOfSize:14];
        //        clear.layer.cornerRadius = 5;
        //        clear.layer.masksToBounds = YES;
        //        clear.layer.borderWidth = 1;
        //        clear.layer.borderColor = [[UIColor colorWithRed:1 green:.2 blue:.1 alpha:.9] CGColor];
        [clear addTarget:self action:@selector(clearSearchArr) forControlEvents:UIControlEventTouchUpInside];
        [_clearKeywordView addSubview: clear];
    }
    return _clearKeywordView;
}

-(void)clearSearchArr{
    if ([self.delegate respondsToSelector:@selector(clearAllKeywoed)]) {
        [self.delegate clearAllKeywoed];
    }
}

-(void)setLabTitleStrs:(NSArray *)LabTitleStrs{
    _LabTitleStrs = LabTitleStrs;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _clearKeywordView.frame = CGRectMake(0, 0, WIDTHDiv, 45);
    _tableView.tableFooterView = self.clearKeywordView;
    _topView.frame = CGRectMake(0, 0, WIDTHDiv, _topViewHeight);
    _tableView.tableHeaderView = self.topView;
}


@end
