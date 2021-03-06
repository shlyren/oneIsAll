//
//  ONEMusicAuthorItem.h
//  ONE
//
//  Created by 任玉祥 on 16/4/2.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEAuthorItem : NSObject

@property (nonatomic, strong) NSString *wb_name;
/** 头像url */
@property (nonatomic, strong) NSString *web_url;

/** 用户id */
@property (nonatomic, strong) NSString *user_id;

/** 用户名 */
@property (nonatomic, strong) NSString *user_name;

/** 简介 */
@property (nonatomic, strong) NSString *desc;

/** 得分 */
@property (nonatomic, strong) NSString *score;


@end
