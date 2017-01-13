//
//  DTLiveCollectionViewController.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTLiveCollectionViewController.h"
#import "DTRefreshGifHeader.h"
#import "DTLiveViewCell.h"

@interface DTLiveFlowLayout : UICollectionViewFlowLayout

@end

@implementation DTLiveFlowLayout
- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end

@interface DTLiveCollectionViewController ()
@end

@implementation DTLiveCollectionViewController

static NSString* const reuseIdentifier = @"LiveViewCell";

- (instancetype)init
{
    return [super initWithCollectionViewLayout:[[DTLiveFlowLayout alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[DTLiveViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    DTRefreshGifHeader* header = [DTRefreshGifHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
        self.currentIndex++;
        if (self.currentIndex == self.lives.count) {
            self.currentIndex = 0;
        }
        [self.collectionView reloadData];
    }];
    header.stateLabel.hidden = NO;
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    DTLiveViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.parentVc = self;
    cell.live = self.lives[self.currentIndex];
    NSUInteger relateIndex = self.currentIndex;
    if (self.currentIndex + 1 == self.lives.count) {
        relateIndex = 0;
    } else {
        relateIndex += 1;
    }
    cell.relateLive = self.lives[relateIndex];
    [cell setClickRelatedLive:^{
        self.currentIndex += 1;
        [self.collectionView reloadData];
    }];
    return cell;
}
@end