//
//  ONECommentCell.h
//  ONE
//
//  Created by 任玉祥 on 16/4/2.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEMusicCommentItem;

@interface ONECommentCell : UITableViewCell

/** 评论模型 */
@property (nonatomic, strong) ONEMusicCommentItem   *commentItem;

/** 详情id */
@property (nonatomic, strong) NSString              *detail_id;

/**  是属于哪一种评论的点赞参数 比如 阅读,还是音乐 */
@property (nonatomic, strong) NSString              *commentType;

/** 行高 */
@property (nonatomic, assign) CGFloat               rowHeight;

@end
