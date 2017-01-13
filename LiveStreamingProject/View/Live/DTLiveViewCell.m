//
//  DTLiveViewCell.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTLiveViewCell.h"
#import "DTBottomToolView.h"
#import "DTCatEarView.h"
#import "DTLiveAnchorView.h"
#import "HotLiveCommand.h"
#import "IJKFFMoviePlayerHelper.h"
#import "RendererHelper.h"
#import "UIImage+Extension.h"
#import <SDWebImageDownloader.h>

@interface DTLiveViewCell () {
    RendererHelper* _renderer;
    NSTimer* _timer;
}
/** 直播播放器工具类 */
@property (nonatomic, strong) IJKFFMoviePlayerHelper* moviePlayerHelper;
/** 底部的工具栏 */
@property (nonatomic, weak) DTBottomToolView* toolView;
/** 顶部主播相关视图 */
@property (nonatomic, weak) DTLiveAnchorView* anchorView;
/** 同类型直播视图 */
@property (nonatomic, weak) DTCatEarView* catEarView;
/** 同一个工会的主播/相关主播 */
@property (nonatomic, weak) UIImageView* otherView;
/** 粒子动画 */
@property (nonatomic, weak) CAEmitterLayer* emitterLayer;
@end

@implementation DTLiveViewCell

#pragma mark-- lifeRecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //评论弹幕
        _renderer = [[RendererHelper alloc] init];
        [_renderer start];
        [self.contentView addSubview:_renderer.view];
        _moviePlayerHelper = [[IJKFFMoviePlayerHelper alloc] init];
        [self.contentView addSubview:_moviePlayerHelper];
        _moviePlayerHelper.frame = self.contentView.frame;
        _moviePlayerHelper.parentVc = self.parentVc;
        __weak typeof(self) weakself = self;
        _moviePlayerHelper.playerState = ^(PlayState stateType) {
            [weakself playStateMethed:stateType];
        };

        self.toolView.hidden = NO;
    }
    return self;
}

- (void)setLive:(HotLiveCommand*)live
{
    _live = live;
    self.anchorView.live = live;
    [self plarFLV:live.flv placeHolderUrl:live.bigpic];
}

- (void)setRelateLive:(HotLiveCommand*)relateLive
{
    _relateLive = relateLive;
    // 设置相关主播
    if (relateLive) {
        self.catEarView.live = relateLive;
    } else {
        self.catEarView.hidden = YES;
    }
}
- (void)plarFLV:(NSString*)flv placeHolderUrl:(NSString*)placeHolderUrl
{
    if (_moviePlayerHelper.moviePlayer) {
        if (_catEarView) {
            [_catEarView removeFromSuperview];
            _catEarView = nil;
        }
    }
    [_moviePlayerHelper plarFLV:flv placeHolderUrl:placeHolderUrl];

    // 如果切换主播, 取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }

    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl]
                                                          options:SDWebImageDownloaderUseNSURLCache
                                                         progress:nil
                                                        completed:^(UIImage* image, NSData* data, NSError* error, BOOL finished) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self.parentVc showGifLoding:nil inView:self.moviePlayerHelper.placeHolderView];
                                                                self.moviePlayerHelper.placeHolderView.image = [UIImage blurImage:image blur:0.8];
                                                            });
                                                        }];
    // 显示工会其他主播和类似主播
    [_moviePlayerHelper.moviePlayer.view bringSubviewToFront:self.otherView];

    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}

#pragma mark-- getter and setter
bool _isSelected = YES;
//底部退出,评论
- (DTBottomToolView*)toolView
{
    if (!_toolView) {
        DTBottomToolView* toolView = [[DTBottomToolView alloc] init];
        [toolView setClickToolBlock:^(LiveToolType type) {
            switch (type) {
            case LiveToolTypePublicTalk:
                _isSelected = !_isSelected;
                _isSelected ? [_renderer start] : [_renderer stop];
                break;
            case LiveToolTypeClose:
                [self quit];
                break;
            default:
                break;
            }
        }];
        [self.contentView insertSubview:toolView aboveSubview:self.moviePlayerHelper.placeHolderView];
        [toolView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-10);
            make.height.equalTo(@40);
        }];
        _toolView = toolView;
    }
    return _toolView;
}
//圆角view
- (UIImageView*)otherView
{
    if (!_otherView) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)]];
        [self.moviePlayerHelper.moviePlayer.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(self.catEarView);
            make.bottom.equalTo(self.catEarView.mas_top).offset(-40);
        }];
        _otherView = imageView;
    }
    return _otherView;
}

- (DTLiveAnchorView*)anchorView
{
    if (!_anchorView) {
        DTLiveAnchorView* anchorView = [DTLiveAnchorView liveAnchorView];
        [anchorView setClickDeviceShow:^(bool isSelected) {
            if (_moviePlayerHelper.moviePlayer) {
                _moviePlayerHelper.moviePlayer.shouldShowHudView = !isSelected;
            }
        }];
        [self.contentView insertSubview:anchorView aboveSubview:self.moviePlayerHelper.placeHolderView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@120);
            make.top.equalTo(@0);
        }];
        _anchorView = anchorView;
    }
    return _anchorView;
}
//同类型直播视图
- (DTCatEarView*)catEarView
{
    if (!_catEarView) {
        DTCatEarView* catEarView = [DTCatEarView catEarView];
        [self.moviePlayerHelper.moviePlayer.view addSubview:catEarView];
        [catEarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCatEar)]];
        [catEarView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(self.moviePlayerHelper.moviePlayer.view);
            make.width.height.equalTo(@98);
        }];
        _catEarView = catEarView;
    }
    return _catEarView;
}
//粒子动画
- (CAEmitterLayer*)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer* emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.contentView.frame.size.width - 50, self.contentView.frame.size.height - 50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray* array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i < 10; i++) {
            // 发射单元
            CAEmitterCell* stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI + M_PI_2;
            ;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2 / 6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }

        emitterLayer.emitterCells = array;
        [self.moviePlayerHelper.moviePlayer.view.layer insertSublayer:emitterLayer below:self.catEarView.layer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

#pragma mark--- events
- (void)clickCatEar
{
    if (self.clickRelatedLive) {
        self.clickRelatedLive();
    }
}

- (void)playStateMethed:(PlayState)stateType
{
    if (stateType == PlayState_DidChange) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_moviePlayerHelper.placeHolderView) {
                [_moviePlayerHelper.placeHolderView removeFromSuperview];
                _moviePlayerHelper.placeHolderView = nil;
                [_moviePlayerHelper.moviePlayer.view addSubview:_renderer.view];
            }
            [self.parentVc hideGufLoding];
        });
    } else if (stateType == PlayState_Finish) {
        //    方法：
        //      1、重新获取直播地址，服务端控制是否有地址返回。
        //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
        __weak typeof(self) weakSelf = self;
        [[NetworkTool shareTool] GET:self.live.flv
            parameters:nil
            progress:nil
            success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                NSLog(@"请求成功%@, 等待继续播放", responseObject);
            }
            failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
                [weakSelf.moviePlayerHelper.moviePlayer shutdown];
                [weakSelf.moviePlayerHelper.moviePlayer.view removeFromSuperview];
                weakSelf.moviePlayerHelper.moviePlayer = nil;
            }];
    }
}

- (void)quit
{
    if (_catEarView) {
        [_catEarView removeFromSuperview];
        _catEarView = nil;
    }

    if (_moviePlayerHelper.moviePlayer) {
        [self.moviePlayerHelper.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
    [self.parentVc dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickOther
{
    NSLog(@"相关的主播");
}

@end
