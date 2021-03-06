//
//  ONEReadQuestionViewController.m
//  ONE
//
//  Created by 任玉祥 on 16/4/14.
//  Copyright © 2016年 任玉祥. All rights reserved.
//

#import "ONEReadQuestionViewController.h"
#import "ONEQuestionDetailViewController.h"


@implementation ONEReadQuestionViewController

- (NSArray *)readItems
{
    return self.readList.question;
}
- (NSString *)readType
{
    return question;
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ONEReadCell *cell = (ONEReadCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.question = self.readItems[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ONEQuestionDetailViewController *questionVc = [ONEQuestionDetailViewController new];
    questionVc.detail_id = [self.readItems[indexPath.row] question_id];
    [self.navigationController pushViewController:questionVc animated:true];
}


@end
