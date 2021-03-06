//
//  ONEHomeViewController.m
//  ONE
//
//  Created by 任玉祥 on 16/4/1.
//  Copyright © 2016年 任玉祥. All rights reserved.
//  首页

#import "ONEHomeViewController.h"
#import "ONEDraggableCardContainer.h"
#import "ONEDraggableCardView.h"
#import "ONEDataRequest.h"
#import "ONEHomeSubtotalItem.h"
#import "ONEMoviePastListVc.h"
#import "ONEShareTool.h"
#import "UIImageView+WebCache.h"


@interface ONEHomeViewController ()<ONEDraggableCardContainerDelegate, ONEDraggableCardContainerDataSource>

@property (nonatomic, weak) ONEDraggableCardContainer   *cardContainer;
@property (nonatomic, strong) NSArray                   *homeSubtotals;

@property (weak, nonatomic) IBOutlet UIButton           *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton           *shareButton;

@end

@implementation ONEHomeViewController

#pragma mark - lazy load
- (ONEDraggableCardContainer *)cardContainer
{
    if (_cardContainer == nil)
    {
        ONEDraggableCardContainer *cardContainer = [[ONEDraggableCardContainer alloc]init];
        cardContainer.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        cardContainer.backgroundColor = [UIColor clearColor];
        cardContainer.dataSource = self;
        cardContainer.delegate = self;
        cardContainer.canDraggableDirection = ONEDraggableDirectionLeft | ONEDraggableDirectionRight | ONEDraggableDirectionUp;
        [self.view insertSubview:_cardContainer = cardContainer atIndex:0];

    }
    return _cardContainer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:ONETabBarItemDidRepeatClickNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark - 加载数据 
- (void)loadData
{
    
    ONEWeakSelf
    [ONEDataRequest requestHomeSubtotal:@"more/0" paramrters:nil success:^(NSArray *homeSubtotal) {
        if (homeSubtotal.count)
        {
            weakSelf.homeSubtotals = homeSubtotal;
            [weakSelf.cardContainer reloadCardContainer];
        }
    } failure:nil];
}

#pragma mark - ONEDraggableCardContainerDataSource
- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return self.homeSubtotals.count;
}

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    ONEDraggableCardView *cardView = [[ONEDraggableCardView alloc]initWithFrame:CGRectMake(ONEDefaultMargin, ONENavBMaxY + ONEDefaultMargin, ONEScreenWidth - 20, ONEScreenWidth * 1.2)];
    cardView.subtotalItem = self.homeSubtotals[index];
    
    return cardView;
}

#pragma mark - ONEDraggableCardContainer Delegate
- (void)cardContainerView:(ONEDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(ONEDraggableDirection)draggableDirection
{
    if (draggableDirection == ONEDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:false];
    }
    
    if (draggableDirection == ONEDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:false];
    }
    
    if (draggableDirection == ONEDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:false];
    }
}

- (void)cardContainerViewDidCompleteAll:(ONEDraggableCardContainer *)container;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已经加载完毕" message:@"你还可以" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"再看一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [container reloadCardContainer];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"查看往期作品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [container reloadCardContainer];
        });
        
        [self allSubtotal];
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:true completion:nil];

}

- (void)cardContainerView:(ONEDraggableCardContainer *)cardContainerView didShowDraggableViewAtIndex:(NSInteger)index
{
    ONEHomeSubtotalItem *item = self.homeSubtotals[index];
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd", item.praisenum] forState:UIControlStateNormal];
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd", item.praisenum] forState:UIControlStateSelected];
    self.praiseButton.tag = index;
    self.shareButton.tag = index;
    self.praiseButton.selected = false;
    [self.praiseButton addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Events
- (IBAction)subtotalBtmClick
{
    [self allSubtotal];
}

/** 往期列表 */
- (void)allSubtotal
{
    ONEMoviePastListVc *pastListVc = [ONEMoviePastListVc new];
    pastListVc.endMonth = @"2012-10";
    [self.navigationController pushViewController:pastListVc animated:true];
}

- (IBAction)shareBtnClick
{
    ONEHomeSubtotalItem *item = self.homeSubtotals[self.praiseButton.tag];

    [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:item.hp_img_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [ONEShareTool showShareView:self content:item.hp_content url:item.web_url image:image];
    }];
    
}

- (void)praiseBtnClick
{
    ONEHomeSubtotalItem *item = self.homeSubtotals[self.praiseButton.tag];

   if (!item.hpcontent_id.length) return;
    NSDictionary *parameters = @{
                                 @"deviceid" : NSUUID.UUID.UUIDString,
                                 @"devicetype" : @"ios",
                                 @"itemid" : item.hpcontent_id,
                                 @"type" : @"hpcontent"
                                 };
    
    [ONEDataRequest addPraise:praise_add parameters:parameters success:^(BOOL isSuccess, NSString *message) {
        
        if (!isSuccess)
        {
            [SVProgressHUD showErrorWithStatus:message];
            
        }else{
            self.praiseButton.selected = !self.praiseButton.selected;
            NSInteger praisenum = self.praiseButton.selected ? ++item.praisenum : --item.praisenum;
            [_praiseButton setTitle:[NSString stringWithFormat:@"%zd", praisenum] forState:UIControlStateNormal];
            [_praiseButton setTitle:[NSString stringWithFormat:@"%zd", praisenum] forState:UIControlStateSelected];
            
        }
    } failure:nil];
}

@end
