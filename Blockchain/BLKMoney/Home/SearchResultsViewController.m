//
//  SearchResultsViewController.m
//  Search
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 MEDP. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating> {
    
    UITableView *mainTable;
    NSMutableArray *searchArray;
}

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchArray = [[NSMutableArray alloc] init];

    [self createTable];
}

- (void)createTable {
    
    CGFloat table_w = self.view.frame.size.width;
    CGFloat table_h = self.view.frame.size.height;
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, table_w, table_h)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (searchArray.count) {
        cell.textLabel.text = searchArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@", searchArray[indexPath.row]);
}

//搜索得到的数据
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"%@", [NSThread currentThread]);
    [searchArray removeAllObjects];
    NSString *searchString = searchController.searchBar.text;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    searchArray = [[self.dataSource filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    
    [mainTable reloadData];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
