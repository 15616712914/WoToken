//
//  AssetsDetailViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AssetsDetailViewController.h"
#import "GiroRecordViewController.h"
#import "DealNoteViewController.h"
#import "PaymentViewController.h"
#import "GiroViewController.h"
#import "PresentAddressViewController.h"

@interface AssetsDetailViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *mainTable;
    NSMutableArray *dataArray;
    UIImageView *avatarImageV;
    UILabel *typeLabel;
    UILabel *moneyLabel;
    NSInteger integer;
    
    UIView *backgroundView;
    UIView *downView;
}

@property (strong,nonatomic) UILabel *addressLabel;
@property (strong,nonatomic) UILabel *noteLabel;
@property (strong,nonatomic) UIView  *noteView1;
@property (strong,nonatomic) UIView  *noteView2;

@end

@implementation AssetsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    integer = 1;
    NSString *titl = YHBunldeLocalString(@"asset_details", bundle);
    if (self.isOnlyAddress) {
        self.navigationItem.title = titl;
    }
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"转账记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];[UIColor colorWithPatternImage:[UIImage imageNamed:@"assets_more"]]
    
    [self createTable];
    [self getAssetsDetails];
}

- (void)createRightBarButton {
    
    CGFloat v_w = 50;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, v_w, v_w)];
    rightView.backgroundColor = CLEARCOLOR;
    
    CGFloat i_w = 25;
    CGFloat i_x = (v_w-i_w)/2+5;
    CGFloat i_y = (v_w-i_w)/2;
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    rightImage.image = [UIImage imageNamed:@"assets_more"];
    [rightView addSubview:rightImage];
    
    CGFloat l_w = 15;
    self.noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(v_w-l_w, v_w/2-l_w, l_w, l_w)];
    self.noteLabel.backgroundColor = [UIColor redColor];
    self.noteLabel.layer.cornerRadius = l_w/2;
    self.noteLabel.layer.masksToBounds = YES;
    self.noteLabel.text = @"6";
    self.noteLabel.font = TEXTFONT3;
    self.noteLabel.textColor = WHITECOLOR;
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:self.noteLabel];
    
    UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton.frame = CGRectMake(0, 0, v_w, v_w);
    [noteButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:noteButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightAction {
    
    [self createDownView];
}

- (void)getAssetsDetails {
    
    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetAssetsDetails];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"asset_type":self.type};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [dataArray removeAllObjects];
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"account"] count]) {
            AssetsDetailModel *item = [[AssetsDetailModel alloc] init];
            [item initWithData:dictionary[@"account"]];
            [dataArray addObject:item];
            [self refreshUI];
        }
        
    } falure:^(NSError *error) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
        NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
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

- (void)refreshUI {
    
    if (dataArray.count) {
        AssetsDetailModel *item = dataArray[0];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [avatarImageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        typeLabel.text = [NSString stringWithFormat:@"%@",item.type];
        NSString *balance = [bundle localizedStringForKey:@"balance" value:nil table:@"localizable"];
        moneyLabel.text = [NSString stringWithFormat:@"%@  %f",balance,item.balance.doubleValue];
        NSString *add = [NSString stringWithFormat:@"%@",item.address];
        if ([add isEqualToString:@"<null>"]) {
            self.addressLabel.text = @"";
        }else{
            self.addressLabel.text = add;
        }
        
    }
}

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    CGFloat i_x = 15;
    CGFloat i_y = 15;
    CGFloat i_w = SCREEN_W > 320 ? 70 : 60;
    UIView *avatarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, i_y*2+i_w)];
    avatarView.backgroundColor = self.color;
    [headerView addSubview:avatarView];
    
    avatarImageV = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    avatarImageV.image = [UIImage imageNamed:@"icon_type"];
    avatarImageV.layer.cornerRadius = i_w/2;
    avatarImageV.layer.masksToBounds = YES;
    [avatarView addSubview:avatarImageV];
    
    CGFloat l_x  = avatarImageV.right+i_x;
    CGFloat l_w  = SCREEN_W-l_x-10;
    CGFloat l_h  = 20;
    CGFloat l_y  = (avatarView.height-l_h*2)/2;
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
    typeLabel.text = [NSString stringWithFormat:@"%@",self.type];
    typeLabel.font = [UIFont boldSystemFontOfSize:16];
    typeLabel.textColor = WHITECOLOR;
    [avatarView addSubview:typeLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, typeLabel.bottom, l_w, l_h)];
    moneyLabel.font = TEXTFONT3;
    moneyLabel.textColor = WHITECOLOR;
    [avatarView addSubview:moneyLabel];
    
    CGFloat v_l   = 10;
    CGFloat vl_l  = 10;
    CGFloat vl_h1 = 15;
    CGFloat vl_h2 = 30;
    CGFloat v_h   = vl_l+vl_h1+vl_h2+5;
    
    CGFloat bottomValue = avatarView.bottom;
    
    if (self.isOnlyAddress) {
        UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, avatarView.bottom+v_l, SCREEN_W, v_h)];
        addressView.backgroundColor = WHITECOLOR;
        [headerView addSubview:addressView];
        
        NSString *address = [bundle localizedStringForKey:@"recharge_address" value:nil table:@"localizable"];
        NSString *copy    = [bundle localizedStringForKey:@"copy" value:nil table:@"localizable"];
        CGFloat vl_x = 10;
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(vl_x, vl_l, SCREEN_W-vl_x*2, vl_h1)];
        addressLabel.text = [NSString stringWithFormat:@"%@ %@",self.type,address];
        addressLabel.font = TEXTFONT3;
        addressLabel.textColor = GRAYCOLOR;
        [addressView addSubview:addressLabel];
        CGFloat vb_w = 60;
        CGFloat vl_w = SCREEN_W-vl_x-vb_w;
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(vl_x, addressLabel.bottom, vl_w, vl_h2)];
        self.addressLabel.font = TEXTFONT5;
        self.addressLabel.textColor = TEXTCOLOR;
        [addressView addSubview:self.addressLabel];
        UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        copyButton.frame = CGRectMake(self.addressLabel.right, addressLabel.bottom, vb_w, vl_h2);
        [copyButton setTitle:copy forState:UIControlStateNormal];
        copyButton.titleLabel.font = TEXTFONT6;
        [copyButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [copyButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [addressView addSubview:copyButton];
        
        bottomValue = addressView.bottom;
       
    }
    
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomValue+v_l, SCREEN_W, SCREEN_W/3*2)];
    typeView.backgroundColor = CLEARCOLOR;
    [headerView addSubview:typeView];
    if (!self.isOnlyAddress) {
        NSArray *imageArray = @[@"assets_giro",@"assets_address",@"assets_note1",@"assets_note2"];
        NSString *transfer  = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
        NSString *_address  = [bundle localizedStringForKey:@"present_address" value:nil table:@"localizable"];
        NSString *transfer1 = [bundle localizedStringForKey:@"transfer_record" value:nil table:@"localizable"];
        NSString *recharge  = [bundle localizedStringForKey:@"recharge_record" value:nil table:@"localizable"];
        NSArray *titleArray = @[transfer,_address,transfer1,recharge];
        CGFloat t_wl = 1;
        CGFloat t_w  = (SCREEN_W-t_wl*2)/3;
        CGFloat ti_w = t_w/3.5;
        CGFloat tl_l = 10;
        CGFloat tl_h = 15;
        CGFloat ti_x = (t_w-ti_w)/2;
        CGFloat ti_y = (t_w-ti_w-tl_l-tl_h)/2;
        CGFloat tl_x = 5;
        CGFloat tl_y = ti_y+ti_w+tl_l;
        CGFloat tl_w = t_w-tl_x*2;
        //    CGFloat ti_w1 = 6;
        for (int i = 0; i < titleArray.count; i ++) {
            
            UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake((t_w+t_wl)*(i%3),(t_w+t_wl)*(i/3),t_w,t_w)];
            tapView.backgroundColor = WHITECOLOR;
            tapView.userInteractionEnabled = YES;
            tapView.tag = 100+i;
            [typeView addSubview:tapView];
            
            UIImageView *typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
            typeImageView.image = [UIImage imageNamed:imageArray[i]];
            [tapView addSubview:typeImageView];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, tl_y, tl_w, tl_h)];
            nameLabel.text = titleArray[i];
            nameLabel.font = TEXTFONT3;
            nameLabel.textColor = TEXTCOLOR;
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [tapView addSubview:nameLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction:)];
            [tapView addGestureRecognizer:tap];
            
            //        if (i == 2) {
            //
            //            self.noteView1 = [[UIView alloc]initWithFrame:CGRectMake(ti_w-ti_w1, 0, ti_w1, ti_w1)];
            //            self.noteView1.backgroundColor = [UIColor redColor];
            //            self.noteView1.layer.cornerRadius = ti_w1/2;
            //            self.noteView1.layer.masksToBounds = YES;
            //            [typeImageView addSubview:self.noteView1];
            //
            //        } else if (i == 3) {
            //
            //            self.noteView2 = [[UIView alloc]initWithFrame:CGRectMake(ti_w-ti_w1/2, 0, ti_w1, ti_w1)];
            //            self.noteView2.backgroundColor = [UIColor redColor];
            //            self.noteView2.layer.cornerRadius = ti_w1/2;
            //            self.noteView2.layer.masksToBounds = YES;
            //            [typeImageView addSubview:self.noteView2];
            //        }
        }
    }
    
    headerView.frame = CGRectMake(0, 0, SCREEN_W, typeView.bottom);
}

- (void)downRefresh {
    
    [self getAssetsDetails];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = CLEARCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)menuClick:(UIButton*)button {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    //防止点击多次创建
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    } else {
        NSString *copy = [bundle localizedStringForKey:@"copy_address" value:nil table:@"localizable"];
        UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:copy action:@selector(copyClick:)];
        menuController.menuItems = @[menuItem];
        [menuController setTargetRect:CGRectMake(button.x+button.width/2, 130, 0, 0) inView:mainTable];
        [menuController setMenuVisible:YES animated:YES];
        
    }
}

//设置控件可以成为第一响应者，注意不是每个控件都可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (void)copyClick:(UIMenuController *)menu {
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.addressLabel.text;
}

- (void)typeAction:(UITapGestureRecognizer*)tap {
    
    NSString *transfer  = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
    NSString *address  = [bundle localizedStringForKey:@"present_address" value:nil table:@"localizable"];
    NSString *transfer1 = [bundle localizedStringForKey:@"transfer_record" value:nil table:@"localizable"];
    NSString *recharge  = [bundle localizedStringForKey:@"recharge_record" value:nil table:@"localizable"];
    if (tap.view.tag == 100) {
        GiroViewController *giroVC = [[GiroViewController alloc] init];
        giroVC.isColor = NO;
        giroVC.navigationTitle = transfer;
        giroVC.back = self.navigationItem.title;
        giroVC.type = self.type;
        giroVC.imageUrl = self.imageUrl;
        [self.navigationController pushViewController:giroVC animated:YES];
        
    } else if (tap.view.tag == 101) {
        if (dataArray.count) {
            AssetsDetailModel *item = dataArray[0];
            PresentAddressViewController *addressVC = [[PresentAddressViewController alloc] init];
            addressVC.isColor = NO;
            addressVC.navigationTitle = address;
            addressVC.type = self.type;
            addressVC.color = self.color;
            addressVC.imageUrl = [NSString stringWithFormat:@"%@",item.path];
            addressVC.back = self.navigationItem.title;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        
    } else if (tap.view.tag == 102) {
        if (dataArray.count) {
            AssetsDetailModel *item = dataArray[0];
            GiroRecordViewController *giroRecord = [[GiroRecordViewController alloc] init];
            giroRecord.isColor = NO;
            giroRecord.navigationTitle = transfer1;
            giroRecord.back = self.navigationItem.title;
            giroRecord.type   = self.type;
            giroRecord.imageUrl = [NSString stringWithFormat:@"%@",item.path];
            giroRecord.color = self.color;
            giroRecord.balance = [NSString stringWithFormat:@"%@",item.balance];
            [self.navigationController pushViewController:giroRecord animated:YES];
        }
        
    } else if (tap.view.tag == 103) {
        DealNoteViewController *dealNoteVC = [[DealNoteViewController alloc] init];
        dealNoteVC.assetType = self.type;
        dealNoteVC.isColor = NO;
        dealNoteVC.navigationTitle = recharge;
        dealNoteVC.back = self.navigationItem.title;
        [self.navigationController pushViewController:dealNoteVC animated:YES];
        
    }
}

- (void)createDownView {
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
    [self.view.window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    
    CGFloat v_w = 110;
    CGFloat v_h = 100;
    downView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W-70, 15, v_w, v_h)];
    downView.backgroundColor = UIColorFromRGB(0x1e5e86);
    downView.layer.anchorPoint = CGPointMake(1.0, 0);// 定点
    downView.transform =CGAffineTransformMakeScale(0.0001, 0.0001);
    [backgroundView addSubview:downView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v_h/2, v_w, 0.5)];
    line.backgroundColor = UIColorFromRGB(0x16405b);
    [downView addSubview:line];
    
    CGFloat l_x = 10;
    CGFloat l_w = 70;
    UILabel *noteLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, v_h/2)];
    noteLabel1.text = @"转账记录";
    noteLabel1.font = TEXTFONT6;
    noteLabel1.textColor = WHITECOLOR;
    [downView addSubview:noteLabel1];
    
    UIButton *noteButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton1.frame = CGRectMake(0, 0, v_w, v_h/2);
    noteButton1.tag = 100;
    [noteButton1 addTarget:self action:@selector(noteClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:noteButton1];
    
    UILabel *noteLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(l_x, v_h/2, l_w, v_h/2)];
    noteLabel2.text = @"提现记录";
    noteLabel2.font = TEXTFONT6;
    noteLabel2.textColor = WHITECOLOR;
    [downView addSubview:noteLabel2];
    
    UIButton *noteButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton2.frame = CGRectMake(0, v_h/2, v_w, v_h/2);
    noteButton2.tag = 200;
    [noteButton2 addTarget:self action:@selector(noteClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:noteButton2];
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        downView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)tapBackgroundClick {
    
    [self hiden];
}

- (void)hiden {
    
    [UIView animateWithDuration:0.2 animations:^{
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        downView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [downView removeFromSuperview];
    }];
}

- (void)noteClick:(UIButton*)button {
    
    [self hiden];
    
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

@implementation AssetsDetailModel

- (void)initWithData:(NSDictionary *)dic {
    
    self.address = dic[@"address"];
    self.balance = dic[@"balance"];
    self.path    = dic[@"path"];
    self.type    = dic[@"type"];
}

@end





















