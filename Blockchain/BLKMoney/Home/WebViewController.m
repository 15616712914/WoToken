//
//  WebViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "WebViewController.h"
#import "PaymentTableViewCell.h"

#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

static void *KINWebBrowserContext = &KINWebBrowserContext;
static CGRect gRect;

@interface WebViewController () <WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    UIView         *backgroundView;
    UIView         *mainView;
    UIView         *typeView;
    UITableView    *mainTable;
    NSMutableArray *dataArray;
    NSMutableArray *typeArray;
}

@property (strong,nonatomic) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation WebViewController


- (void)viewWillAppear:(BOOL)animated {
    gRect = self.tabBarController.tabBar.frame;
    self.tabBarController.tabBar.frame = CGRectZero;
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.frame = gRect;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataArray = [[NSMutableArray alloc] init];
    typeArray = [[NSMutableArray alloc] init];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    backgroundView.backgroundColor = TABLEBLACK;
    [self.view addSubview:backgroundView];
    
    if (self.isList == YES) {
        [self getData];
    } else {
        [self createWKWebView:self.web_url];
    }
    
}
    
- (void)createWKWebView:(NSString*)url {
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, backgroundView.height)];
    webView.navigationDelegate = self;// 设置代理
    webView.UIDelegate = self;// 设置代理
    webView.allowsBackForwardNavigationGestures = YES;//允许左右划手势导航，默认允许
    self.wkWebView = webView;
    [backgroundView addSubview:self.wkWebView];
    self.wkWebView.alpha = 0.0;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.web_url]]];
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:KINWebBrowserContext];//监听网页进度
}

- (void)getData {
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetExchange];
    NSString *token = [userDefaults objectForKey:USER_TOKEN];
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
        [dataArray removeAllObjects];
        [typeArray  removeAllObjects];
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSDictionary *dic in dictionary[@"list"]) {
                ExchangeModel *item = [[ExchangeModel alloc] init];
                [item initWithData:dic];
                [dataArray addObject:item];
                [typeArray addObject:@"0"];
            }
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self createTable];
            });
        }
        
    } falure:^(NSError *error) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
        NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
        NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([errorString hasSuffix:@")"] == YES) {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:falure];
            } else {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:timeout];
            }
        });
    }];
}

- (void)createTable {
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, backgroundView.height)];
    mainView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
    [self.view addSubview:mainView];
    mainView.alpha = 0.0;
    
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 300)];
    typeView.backgroundColor = WHITECOLOR;
    [mainView addSubview:typeView];
    
    CGFloat l_h = 50;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h-line_h, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    [typeView addSubview:line];
    
    CGFloat l_x = 10;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, SCREEN_W-l_x*2, l_h)];
    titleLabel.text = [bundle localizedStringForKey:@"view_type" value:nil table:@"localizable"];
    titleLabel.font = TEXTFONT6;
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [typeView addSubview:titleLabel];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, typeView.height-l_h)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [typeView addSubview:mainTable];
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        mainView.alpha = 1.0;
        typeView.frame = CGRectMake(0, mainView.height-typeView.height, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 44.5, SCREEN_W-30, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (dataArray.count) {
        ExchangeModel *item = dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
    }
    
    if (typeArray.count) {
        if ([typeArray[indexPath.row] isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = MAINCOLOR;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [typeArray removeAllObjects];
    if (dataArray.count) {
        for (int i = 0; i < dataArray.count; i ++) {
            [typeArray addObject:@"0"];
        }
        [typeArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [mainTable reloadData];
        ExchangeModel *item = dataArray[indexPath.row];
        NSString *type     = [NSString stringWithFormat:@"%@",item.type];
        NSString *url = [NSString stringWithFormat:@"%@",item.url];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.web_url = url;
        webVC.navigationTitle = type;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)cancelClick:(NSString*)url {
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        mainView.alpha = 1.0;
        typeView.frame = CGRectMake(0, mainView.height, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        [mainView  removeFromSuperview];
        [typeView  removeFromSuperview];
        [mainTable removeFromSuperview];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self createWKWebView:url];
        });
    }];
}

// 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    // 创建进度条
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, SCREEN_W, self.progressView.frame.size.height);
    // 设置进度条的色彩
    [self.progressView setTrackTintColor:[UIColor clearColor]];
    self.progressView.progressTintColor = [UIColor redColor];
    //[self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    self.progressView.progress = 0.1;
    [backgroundView addSubview:self.progressView];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   
    [UIView animateWithDuration:0.3 animations:^{
        self.wkWebView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (!_isAgreement) {
            NSString *last = [bundle localizedStringForKey:@"last_page" value:nil table:@"localizable"];
            UIBarButtonItem *lastItem = [[UIBarButtonItem alloc]initWithTitle:last style:UIBarButtonItemStylePlain target:self action:@selector(lastAction)];
            self.navigationItem.rightBarButtonItem = lastItem;
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TEXTFONT5, NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
    }];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:timeout];
    });
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else if (newprogress > 0.1) {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)lastAction {
    
    if (self.wkWebView.canGoBack == YES) {
        [self.wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//移除监听
- (void)dealloc {
  
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    
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

@implementation ExchangeModel

- (void)initWithData:(NSDictionary *)dic {
    
    self.type = dic[@"type"];
    self.url  = dic[@"url"];
    self.path = dic[@"path"];
}

@end












