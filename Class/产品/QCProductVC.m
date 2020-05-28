//
//  QCProductVC.m
//  Jwo2o
//
//  Created by 张燕枭 on 2020/5/18.
//  Copyright © 2020 ZhangYanXiao. All rights reserved.
//

#import "QCProductVC.h"
#import "QCJXTJCell.h"
#import "QCTableView.h"

@interface QCProductVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    CGFloat mainScrollContentY;
}

//UI
@property (weak, nonatomic) IBOutlet UIScrollView *main_scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainScrollContent_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainScrollContentHeight_constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineLeft_contraint;
@property (weak, nonatomic) IBOutlet UIImageView *underLine_view;

@property (weak, nonatomic) IBOutlet UIView *segment_view;
@property (weak, nonatomic) IBOutlet UIScrollView *segment_scrollView;
@property (weak, nonatomic) IBOutlet UIView *segmentScrollContent_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentScrollContentWidth_constraint;
@property (weak, nonatomic) IBOutlet UIScrollView *table_scrollView;
@property (weak, nonatomic) IBOutlet UIView *tableScrollContent_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableScrollContentHeight_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableScrollContentWidth_constraint;

@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSMutableArray *segUnits;
@property (nonatomic, strong) NSMutableArray *tableViews;

@end

@implementation QCProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initView
{
    [_main_scrollView setDelegate:self];
    [_segment_scrollView setDelegate:self];
    [_table_scrollView setDelegate:self];
    _mainScrollContentHeight_constraint.constant = SCREEN_HEIGHT+116;
    [_mainScrollContent_view layoutIfNeeded];
    _tableScrollContentHeight_constraint.constant = SCREEN_HEIGHT-64;
    [_tableScrollContent_view layoutIfNeeded];
    
}

- (void)loadData
{
    _types = [NSMutableArray arrayWithArray:@[@"推荐",@"少男",@"少女",@"老年",@"青年"]];
    _products = [NSMutableArray arrayWithCapacity:3];
    for (int i=0;i<3;i++) {
        NSArray *products = @[@"女性关爱险",@"重疾险",@"癌症医疗险"];
        NSDictionary *productInfo = @{@"title":@"住院医疗险",@"products":products};
        [_products addObject:productInfo];
    }
    [self setupView];
}

- (void)setupView
{
    //清除之前的View
    for (UIView *view in _segUnits) {
        [view removeFromSuperview];
    }
    _segUnits = [NSMutableArray arrayWithCapacity:5];
    for (UIView *view in _tableViews) {
        [view removeFromSuperview];
    }
    _tableViews = [NSMutableArray arrayWithCapacity:5];
    
    _tableScrollContentWidth_constraint.constant = SCREEN_WIDTH*_types.count;
    [_tableScrollContent_view layoutIfNeeded];
    
    float segWidth = SCREEN_WIDTH/4;
    _segmentScrollContentWidth_constraint.constant = segWidth*_types.count;
    [_segmentScrollContent_view layoutIfNeeded];
    
    for (int i=0; i<5; i++) {
        UIView *segUnitView = [[UIView alloc] initWithFrame:CGRectMake(i*segWidth, 0, segWidth, 64)];
        UILabel *segUnitLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, segWidth, 64)];
        [segUnitLbl setTextAlignment:NSTextAlignmentCenter];
        [segUnitLbl setText:_types[i]];
        [segUnitLbl setTag:1001];
        [segUnitLbl setFont:SemiboldFont(16)];
        [segUnitLbl setTextColor:UIColorRGB(0x999999)];
        
        UIButton *segUnitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [segUnitBtn setFrame:CGRectMake(0, 0, segWidth, 64)];
        [segUnitBtn setTag:i];
        [segUnitBtn addTarget:self action:@selector(click_seg:) forControlEvents:UIControlEventTouchUpInside];
        [segUnitView addSubview:segUnitLbl];
        [segUnitView addSubview:segUnitBtn];
        [_segmentScrollContent_view addSubview:segUnitView];
        [_segUnits addObject:segUnitView];
        
        QCTableView *tableView = [[QCTableView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//        [tableView setScrollEnabled:NO];
        [_tableScrollContent_view addSubview:tableView];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableViews addObject:tableView];
        
//        [tableView addGestureRecognizer:_main_scrollView.panGestureRecognizer];
    }
    [self scrollViewDidScroll:_table_scrollView];
}

- (void)click_seg:(UIButton*)sender
{
    [_table_scrollView setContentOffset:CGPointMake(sender.tag*SCREEN_WIDTH, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_table_scrollView) {
        NSInteger pageCount = _types.count;
        float segUnitWidth = SCREEN_WIDTH/4;
        float contentX = scrollView.contentOffset.x;
        float contentScope = SCREEN_WIDTH*(pageCount-1);
        
        float underLineScope = segUnitWidth*(pageCount-1);
        
        float underLineLeft = contentX*(underLineScope/contentScope)+((segUnitWidth-58)/2);
        _underLineLeft_contraint.constant = underLineLeft;
        
        NSInteger page = (scrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
        
        for (int i=0;i<_segUnits.count;i++) {
            UIView *segUnitView = _segUnits[i];
            UILabel *segUnitLbl = [segUnitView viewWithTag:1001];
            if (page==i) {
                [segUnitLbl setFont:SemiboldFont(20)];
                [segUnitLbl setTextColor:UIColorRGB(0x333333)];
            }else{
                [segUnitLbl setFont:SemiboldFont(16)];
                [segUnitLbl setTextColor:UIColorRGB(0x999999)];
            }
        }
        if (page>3) {
            [_segment_scrollView setContentOffset:CGPointMake((page-3)*segUnitWidth, 0) animated:YES];
        }else if (page<3) {
            [_segment_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }else if([scrollView isKindOfClass:[UITableView class]]){
        //内部ScrollView
        NSLog(@"滚动UITableView");
        QCTableView *qctv = (QCTableView*)scrollView;
        //判断向上滑动还是向下滑动
        if (scrollView.contentOffset.y - qctv.tableY > 0) {
            //向上
            //_main_scrollView就是我的外层主ScrollView，当它小于116或者大于0的时候，这时候还在向上滑动就说明在移动它，这时候禁止内部ScrollView滚动，一直设置内部ScrollView的Y轴为最后一次记录的Y轴，以禁止它的滚动。
            if (_main_scrollView.contentOffset.y<116&&scrollView.contentOffset.y>0) {
                [scrollView setContentOffset:CGPointMake(0, qctv.tableY)];
            }
            /*mainScrollContentY是我在全局声明的变量
             {
             CGFloat mainScrollContentY;
             }
             有条件的可以将它写在主ScrollView的重写对象里，我这里没有为主Scroll重写对象，就放在当前Controller里了为了简单
             */
            //只在主ScrollView滚动了的条件下记录它的坐标。
            mainScrollContentY = _main_scrollView.contentOffset.y;
        }else if(scrollView.contentOffset.y - qctv.tableY < 0){
            //向下
            //内部ScrollView的Y大于0说明内部ScrollView没到顶，这时候向下移动也应该将_main_scrollView固定在最上方，一直设置外部_main_scrollView的Y轴为最后一次记录的Y轴，以禁止它的滚动。
            if (scrollView.contentOffset.y>=0) {
                [_main_scrollView setContentOffset:CGPointMake(0, mainScrollContentY)];
            }else if (_main_scrollView.contentOffset.y>0) {
                //如果内部Scroll的ContentOffset的Y小于0，说明内部ScrollView到顶了，外部_main_scrollView的ContentOffset的Y又大于0，这时候向下移动应该将外部_main_scrollView拉下来，一直设置内部ScrollView的Y轴为0，以禁止它的滚动。
                [scrollView setContentOffset:CGPointMake(0, 0)];
            }
            //只在主ScrollView滚动了的条件下记录它的坐标。
            mainScrollContentY = _main_scrollView.contentOffset.y;
        }
        qctv.tableY = scrollView.contentOffset.y;
    }else if(scrollView==_main_scrollView){
        //外部主ScrollView
        //这里主要是设置边界，也就是头部的高度，不允许_main_scrollView的contentOffset的Y轴大于116或小于0。
        NSLog(@"滚动MainScroll");
        if (scrollView.contentOffset.y>116) {
            [scrollView setContentOffset:CGPointMake(0, 116)];
        }else if(scrollView.contentOffset.y<0){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
}

#pragma mark - Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _products.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *productsInfo = _products[section];
    return [productsInfo[@"products"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *productsInfo = _products[section];
    NSString *title = productsInfo[@"title"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 200, 20)];
    [titleLbl setFont:MediumFont(20.0)];
    [titleLbl setTextColor:UIColorRGB(0x333333)];
    [titleLbl setText:title];
    [headerView addSubview:titleLbl];
    UILabel *subTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, 200, 12)];
    [subTitleLbl setFont:Font(12.0)];
    [subTitleLbl setTextColor:UIColorRGB(0x999999)];
    [subTitleLbl setText:@"患病住院可报销，医保补充好搭档"];
    [headerView addSubview:subTitleLbl];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [footerView setBackgroundColor:UIColorRGB(0xf4f4f4)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *QCJXTJCellIdentify = @"QCJXTJCellIdentify";
    QCJXTJCell *cell = [tableView dequeueReusableCellWithIdentifier:QCJXTJCellIdentify];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"QCJXTJCell" bundle:nil] forCellReuseIdentifier:QCJXTJCellIdentify];
        cell = [tableView dequeueReusableCellWithIdentifier:QCJXTJCellIdentify forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
