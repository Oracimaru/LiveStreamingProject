//
//  DTHotViewController.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTHotViewController.h"
#import "DTRefreshGifHeader.h"
#import "DTHotLiveCell.h"
#import "DTLiveCollectionViewController.h"
#import "HotLiveCommand.h"

@interface DTHotViewController ()
/** 当前页 */
@property (nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property (nonatomic, strong) NSMutableArray* lives;
@end

static NSString* reuseIdentifier = @"DTHotLiveCell";
@implementation DTHotViewController
- (NSMutableArray*)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"直播列表";
    [self setup];
}

- (void)setup
{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DTHotLiveCell class]) bundle:nil]
         forCellReuseIdentifier:
             reuseIdentifier];

    self.currentPage = 1;
    self.tableView.mj_header = [DTRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        [self getHotLiveList];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];

    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//得到直播列表  FIX-ME
- (void)getHotLiveList
{
    [[NetworkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage]
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSArray* result = [HotLiveCommand mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if ([self isNotEmpty:result]) {
                [self.lives addObjectsFromArray:result];
                [self.tableView reloadData];
            } else {
                [self showHint:@"暂时没有更多最新数据"];
                // 恢复当前页
                self.currentPage--;
            }
        }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.currentPage--;
            [self showHint:@"网络异常"];
        }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.lives.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 465;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DTHotLiveCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (self.lives.count) {
        HotLiveCommand* live = self.lives[indexPath.row];
        cell.live = live;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    DTLiveCollectionViewController* liveVc = [[DTLiveCollectionViewController alloc] init];
    liveVc.lives = self.lives;
    liveVc.currentIndex = indexPath.row;
    [self presentViewController:liveVc animated:YES completion:nil];
}

@end