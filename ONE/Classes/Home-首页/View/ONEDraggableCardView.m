//
//  ONEDraggableCardView.m
//  ONE
//
//  Created by 任玉祥 on 16/4/17.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "ONEDraggableCardView.h"
#import "ONEHomeSubtotalItem.h"
#import "UIImageView+WebCache.h"
#import "NSMutableAttributedString+string.h"

@interface ONEDraggableCardView ()
/** 图片 */
@property (weak, nonatomic) UIImageView     *imageView;
/** 标题 */
@property (weak, nonatomic) UILabel         *hp_titleLabel;
/** 作者 */
@property (weak, nonatomic) UILabel         *hp_authorLabel;
/** 内容 */
@property (weak, nonatomic) UILabel         *hp_contentLabel;
/** 发表时间 */
@property (weak, nonatomic) UILabel         *hp_makettimeLabel;
/** 内容的scrollView */
@property (weak, nonatomic) UIScrollView    *contentScroll;
/** 间距 */
@property (nonatomic, assign) CGFloat margin;

@end
@implementation ONEDraggableCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self.margin = 5;
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor          = [UIColor whiteColor];
        
        /** 图片 */
        UIImageView *imageView        = [UIImageView new];
        CGFloat imageViewW            = self.width - ONEDefaultMargin;
        imageView.frame               = CGRectMake(self.margin, self.margin, imageViewW, imageViewW * 0.75);
        _imageView                    = imageView;
        imageView.userInteractionEnabled  = true;
        [imageView addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(bigImage)]];
        [self addSubview: imageView];
        
        /** 标题 */
        UILabel *hp_titleLabel        = [UILabel new];
        hp_titleLabel.font            = [UIFont systemFontOfSize:10];
        hp_titleLabel.textColor       = [UIColor lightGrayColor];
        hp_titleLabel.x               = imageView.x;
        hp_titleLabel.y               = CGRectGetMaxY(imageView.frame) + self.margin;
        _hp_titleLabel                = hp_titleLabel;
        [self addSubview:hp_titleLabel];
        
        /** 用户 */
        UILabel *hp_authorLabel       = [UILabel new];
        hp_authorLabel.font           = [UIFont systemFontOfSize:10];
        hp_authorLabel.textColor      = [UIColor lightGrayColor];
        _hp_authorLabel               = hp_authorLabel;
        [self addSubview:hp_authorLabel];
        
        UIScrollView *contentScroll   = [UIScrollView new];
        contentScroll.width           = imageViewW;
        contentScroll.x               = self.imageView.x;
        _contentScroll                = contentScroll;
        [self addSubview:contentScroll];
      
        /** 内容 */
        UILabel *hp_contentLabel      = [UILabel new];
        hp_contentLabel.numberOfLines = 0;
        hp_contentLabel.width         = imageView.width - 2 * ONEDefaultMargin;
        hp_contentLabel.font          = [UIFont systemFontOfSize:14];
        hp_contentLabel.textColor     = [UIColor darkGrayColor];
        hp_contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _hp_contentLabel              = hp_contentLabel;
        [contentScroll addSubview:hp_contentLabel];
        
        /** 发布时间 */
        UILabel *hp_makettimeLabel    = [UILabel new];
        hp_makettimeLabel.font        = [UIFont systemFontOfSize:10];
        hp_makettimeLabel.textColor   = [UIColor lightGrayColor];
        _hp_makettimeLabel            = hp_makettimeLabel;
        [self addSubview:hp_makettimeLabel];
  
    }
    return self;
}

/** 设置frame */
- (void)layoutSubviews
{
    [super layoutSubviews];
    /** 用户 */
    self.hp_authorLabel.x  = CGRectGetMaxX(self.imageView.frame) - self.hp_authorLabel.width;
    self.hp_authorLabel.y  = CGRectGetMaxY(self.imageView.frame) + self.margin;
    
    /** 发布时间 */
    self.hp_makettimeLabel.x =  CGRectGetMaxX(self.imageView.frame) - self.hp_makettimeLabel.width;
    self.hp_makettimeLabel.y = ONEScreenWidth * 1.2 - 15;
  
    /** 内容的滚动视图 */
    self.contentScroll.y = CGRectGetMaxY(self.hp_authorLabel.frame) + self.margin;
    self.contentScroll.height = self.hp_makettimeLabel.y - self.margin - self.contentScroll.y;
    self.contentScroll.contentSize = CGSizeMake(0, self.hp_contentLabel.height);
  
    /** 内容 */
    self.hp_contentLabel.x = self.contentScroll.x + self.margin;
    if (self.hp_contentLabel.height > self.contentScroll.height)
    {
        self.hp_contentLabel.y = 0;
    }else{
        self.hp_contentLabel.y = (self.contentScroll.height - self.hp_contentLabel.height ) * 0.5;
    }
    
}

/** 设置数据 */
- (void)setSubtotalItem:(ONEHomeSubtotalItem *)subtotalItem
{
    _subtotalItem = subtotalItem;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:subtotalItem.hp_img_url] placeholderImage:[UIImage imageNamed:@"home"]];
    self.hp_titleLabel.text = subtotalItem.hp_title;
    [self.hp_titleLabel sizeToFit];
    
    self.hp_authorLabel.text = subtotalItem.hp_author;
    [self.hp_authorLabel sizeToFit];
    
    self.hp_makettimeLabel.text = subtotalItem.hp_makettime;
    [self.hp_makettimeLabel sizeToFit];
    
    self.hp_contentLabel.attributedText = [NSMutableAttributedString attributedStringWithString:subtotalItem.hp_content];
    [self.hp_contentLabel sizeToFit];
}


- (void)bigImage
{
    ONELogFunc
}

@end


@implementation ONECardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (void)setupCardView
{
    self.backgroundColor = ONEColor(250, 250, 250, 1);
    
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 0.4f;
    self.layer.shouldRasterize = true;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 7.0;
}
@end
