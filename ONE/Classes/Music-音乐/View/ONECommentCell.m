//
//  ONECommentCell.m
//  ONE
//
//  Created by 任玉祥 on 16/4/2.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "ONECommentCell.h"
#import "ONEMusicCommentItem.h"
#import "ONEPersonDetailViewController.h"
#import "ONENavigationController.h"
#import "UIViewController+Extension.h"
#import "NSMutableAttributedString+string.h"
#import "ONEDataRequest.h"
#import "UIImageView+WebCache.h"
#import "UIImage+image.h"

@interface ONECommentCell ()
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *commentContectLabel;
/** 喜欢 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *praisenumBtn;

/** 评论时间 */
@property (weak, nonatomic) IBOutlet UILabel *inputDateLabel;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ONECommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ONECommentCell" owner:nil options:nil].firstObject;        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.commentContectLabel.preferredMaxLayoutWidth = ONEScreenWidth - 80;
}

- (void)setCommentItem:(ONEMusicCommentItem *)commentItem
{
    
    _commentItem = commentItem;
    
    self.inputDateLabel.text      = commentItem.input_date;
    self.commentContectLabel.attributedText = [NSMutableAttributedString attributedStringWithString:commentItem.content];
    [self.commentContectLabel sizeToFit];
    
    [self.praisenumBtn setTitle:[NSString stringWithFormat:@"%zd", commentItem.praisenum] forState:UIControlStateNormal];
    
    ONEAuthorItem *author    = commentItem.user;
    self.userNameLabel.text  = author.user_name;
    
   [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:author.web_url] placeholderImage:[UIImage imageNamed:@"author_cover"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       self.iconImageView.image = image.circleImage;
   }];
}

#pragma mark - Event
- (IBAction)praisenumBtnClick
{
    if (!(self.commentType.length + self.commentItem.comment_id.length + self.commentType.length)) return;
    
    self.praisenumBtn.selected = !self.praisenumBtn.selected;

    NSDictionary *parameters = @{
                                 @"cmtid" : _commentItem.comment_id,
                                 @"itemid" : _detail_id,  // detailID
                                 @"type" : self.commentType,
                                 };
    
    [ONEDataRequest addPraise:comment_praise parameters:parameters success:^(BOOL isSuccess, NSString *message) {
        
        if (!isSuccess) // 失败
        {
            [SVProgressHUD showErrorWithStatus:message];
            _praisenumBtn.selected = !_praisenumBtn.selected;
            
        }else{ // 成功
            
             NSInteger praisenum = _praisenumBtn.selected ? ++_commentItem.praisenum : --_commentItem.praisenum;
            
            [_praisenumBtn setTitle:[NSString stringWithFormat:@"%zd", praisenum] forState:UIControlStateNormal];
            [_praisenumBtn setTitle:[NSString stringWithFormat:@"%zd", praisenum] forState:UIControlStateSelected];
            
        }
        
    } failure:nil];
    
}

- (IBAction)iconBtnClick
{
    ONEPersonDetailViewController *detailVc = [ONEPersonDetailViewController new];
    detailVc.user_id = _commentItem.user.user_id;
    ONENavigationController *nav = [[ONENavigationController alloc] initWithRootViewController:detailVc];
    [self.window.rootViewController.topViewController presentViewController:nav animated:true completion:nil];
}

- (CGFloat)rowHeight
{
    [self layoutIfNeeded];
    return 60 + self.commentContectLabel.height + 10;
    // return CGRectGetMaxY(self.commentContectLabel.frame) + 15;
}
@end
