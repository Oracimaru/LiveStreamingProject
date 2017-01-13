//
//  DTHotLiveCell.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTHotLiveCell.h"
#import "HotLiveCommand.h"
#import "UIImage+Extension.h"
#import <UIImageView+WebCache.h>

@interface DTHotLiveCell ()
@property (weak, nonatomic) IBOutlet UIImageView* headImageView;
@property (weak, nonatomic) IBOutlet UIButton* locationBtn;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView* startView;
@property (weak, nonatomic) IBOutlet UILabel* chaoyangLabel;
@property (weak, nonatomic) IBOutlet UIImageView* bigPicView;
@end
@implementation DTHotLiveCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setLive:(HotLiveCommand*)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic]
                          placeholderImage:[UIImage imageNamed:@"placeholder_head"]
                                   options:SDWebImageRefreshCached
                                 completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                     image = [UIImage circleImage:image borderColor:[UIColor redColor] borderWidth:1];
                                     self.headImageView.image = image;
                                 }];
    
    self.nameLabel.text = live.myname;
    // 如果没有地址, 给个默认的地址
    if (!live.gps.length) {
        live.gps = @"喵星";
    }
    [self.locationBtn setTitle:live.gps forState:UIControlStateNormal];
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:live.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    self.startView.image = live.starImage;
    self.startView.hidden = !live.starlevel;
    
    // 设置当前观众数量
    NSString* fullChaoyang = [NSString stringWithFormat:@"%ld人在看", live.allnum];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%ld", live.allnum]];
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:KeyColor range:range];
    self.chaoyangLabel.attributedText = attr;
}

@end
