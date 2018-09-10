//
//  SearchResultsViewController.h
//  Search
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 MEDP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController <UISearchResultsUpdating>

@property (strong, nonatomic) NSArray *dataSource;

@end
