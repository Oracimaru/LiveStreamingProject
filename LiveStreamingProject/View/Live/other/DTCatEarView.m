//
//  DTCatEarView.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTCatEarView.h"
#import "HotLiveCommand.h"

@interface DTCatEarView()
@property (weak, nonatomic) IBOutlet UIView *playView;
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
@end

@implementation DTCatEarView

+ (instancetype)catEarView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.playView.layer.cornerRadius = self.playView.height * 0.5;
    self.playView.layer.masksToBounds = YES;
}

- (void)setLive:(HotLiveCommand *)live
{
    _live = live;
    
    // 设置只播放视频, 不播放声音
    
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionValue:@"1" forKey:@"an"];
    // 开启硬解码
    [option setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:live.flv withOptions:option];
    
    moviePlayer.view.frame = self.playView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放
    moviePlayer.shouldAutoplay = YES;
    
    [self.playView addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    self.moviePlayer = moviePlayer;
}

- (void)removeFromSuperview
{
    if (_moviePlayer) {
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
    }
    [super removeFromSuperview];
}

@end
