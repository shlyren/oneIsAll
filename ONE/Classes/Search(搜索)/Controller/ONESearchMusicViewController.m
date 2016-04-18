//
//  ONESearchMusicViewController.m
//  ONE
//
//  Created by 任玉祥 on 16/4/18.
//  Copyright © 2016年 ONE. All rights reserved.
//

#import "ONESearchMusicViewController.h"
#import "ONEMusicViewController.h"
#import "ONESearchMusicItem.h"

@interface ONESearchMusicViewController ()

@end

@implementation ONESearchMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)setSearchKey:(NSString *)searchKey
{
    
    if ([self.searchKey isEqualToString:searchKey]) return;
    [super setSearchKey:searchKey];
    ONEWeakSelf
    [SVProgressHUD show];
    [ONEDataRequest requestSearchMusic:searchKey success:^(NSArray *musicResult) {
        [SVProgressHUD dismiss];
        if (musicResult.count) {
            self.searchResult = musicResult;
            [weakSelf.tableView reloadData];
        }
        
    } failure:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ONESearchTableViewCell *cell = (ONESearchTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.musicItem = self.searchResult[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    ONESearchMusicItem *item = self.searchResult[indexPath.row];
    ONEMusicViewController *musicDetailVc = [ONEMusicViewController new];
    musicDetailVc.detailIdUrl = item.music_detail_id;
    musicDetailVc.title = item.title;
    [self.navigationController pushViewController:musicDetailVc animated:true];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
