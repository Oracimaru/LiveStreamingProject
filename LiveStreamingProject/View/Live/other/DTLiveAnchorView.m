//
//  DTLiveAnchorView.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTLiveAnchorView.h"

#import "HotLiveCommand.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"
@interface DTLiveAnchorView ()
@property (weak, nonatomic) IBOutlet UIView* anchorView;
@property (weak, nonatomic) IBOutlet UIImageView* headImageView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton* careBtn;
@property (weak, nonatomic) IBOutlet UIButton* giftView;
@property (strong, nonatomic) NSTimer* timer;
@end

@implementation DTLiveAnchorView

+ (instancetype)liveAnchorView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self maskViewToBounds:self.anchorView];
    [self maskViewToBounds:self.headImageView];
    [self maskViewToBounds:self.careBtn];
    [self maskViewToBounds:self.giftView];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:KeyColor size:self.careBtn.size] forState:UIControlStateNormal];
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];
    
    // 默认是关闭的
    [self Device:self.careBtn];
}

- (void)maskViewToBounds:(UIView*)view
{
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
}

static int randomNum = 0;
- (void)setLive:(HotLiveCommand*)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = live.myname;
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", live.allnum];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
}

- (void)updateNum
{
    randomNum += arc4random_uniform(5);
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", self.live.allnum + randomNum];
    [self.giftView setTitle:[NSString stringWithFormat:@"猫粮:%u  娃娃%u", 1993045 + randomNum, 124593 + randomNum] forState:UIControlStateNormal];
}

- (IBAction)Device:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (self.clickDeviceShow) {
        self.clickDeviceShow(sender.selected);
    }
}

@end
