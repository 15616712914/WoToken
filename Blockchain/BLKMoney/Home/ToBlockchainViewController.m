//
//  ToBlockchainViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/19.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ToBlockchainViewController.h"
#import "PaymentTableViewCell.h"
#import "PayPasswordViewController.h"
#import "ForgetPayViewController.h"

@interface ToBlockchainViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    
    UITableView *mainTable;
    NSArray     *dataArray;
    UITextField *numberTextField;
    UIButton    *sureButton;
    
    UIView *backgroundView;
    UIView *typeView;
    UITableView *typeTable;
    NSMutableArray *typeArray;
    NSMutableArray *typeArray1;
    UITableView *addressTable;
    NSMutableArray *addressArray;
    NSMutableArray *addressArray1;
    BOOL isType;
    NSString *blockchainImage;
    NSString *blockchainType;
    NSString *blockchainAddress;
    
    UIView *passwordView;
    CGFloat v_h;
    UIView *alertView;
    UIImageView *dot1;
    UIImageView *dot2;
    UIImageView *dot3;
    UIImageView *dot4;
    UIImageView *dot5;
    UIImageView *dot6;
    UITextField *passwordTextField;
}

@end

@implementation ToBlockchainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *asset   = [bundle localizedStringForKey:@"asset type" value:nil table:@"localizable"];
    NSString *address = [bundle localizedStringForKey:@"block_address" value:nil table:@"localizable"];
    NSString *leftMoney = YHBunldeLocalString(@"block_leftmoney", bundle);
    dataArray  = @[asset,address];
    typeArray  = [[NSMutableArray alloc] init];
    typeArray1 = [[NSMutableArray alloc] init];
    addressArray  = [[NSMutableArray alloc] init];
    addressArray1 = [[NSMutableArray alloc] init];
    [self createTable];
}

- (void)getAssetsList {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAssetsList];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"status":@"1"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            [typeArray  removeAllObjects];
            [typeArray1 removeAllObjects];
            NSDictionary *dictionary = responseObject;
            if ([dictionary[@"list"] count]) {
                for (NSDictionary *dic in dictionary[@"list"]) {
                    AssetsTypeModel *item = [[AssetsTypeModel alloc] init];
                    [item initWithData:dic];
                    [typeArray addObject:item];
                    [typeArray1 addObject:@"0"];
                }
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self createTypeTable];
                });
                
            } else {
                NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
                NSString *acount = [bundle localizedStringForKey:@"acount_not" value:nil table:@"localizable"];
                NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:acount preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
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
}

- (void)getAddressList {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        
        if (blockchainType) {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [urlStr returnType:InterfaceGetPresentAddress];
            NSString *token  = [userDefaults objectForKey:USER_TOKEN];
            NSDictionary *parameters = @{@"assets_type":blockchainType};
            [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                [addressArray  removeAllObjects];
                [addressArray1 removeAllObjects];
                NSDictionary *dictionary = responseObject;
                if ([dictionary[@"list"] count]) {
                    for (NSString *address in dictionary[@"list"]) {
                        [addressArray addObject:address];
                        [addressArray1 addObject:@"0"];
                    }
                    [self createTypeTable];
                } else {
                    NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
                    NSString *address = [bundle localizedStringForKey:@"asset_address" value:nil table:@"localizable"];
                    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:address preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                
            } falure:^(NSError *error) {
                
                [DXLoadingHUD dismissHUDFromView:self.view];
                NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
                NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
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
            
        } else {
            NSString *asset = [bundle localizedStringForKey:@"asset_type1" value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:asset];
        }
    }
}

- (void)patchData {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetSureAccounts];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        NSString *money = numberTextField.text;
        NSString *password = passwordTextField.text;
        NSDictionary *parameters = @{@"exchange_target":blockchainAddress,@"note":@"",@"amount":money,@"pay_auth":password,@"account_type":blockchainType};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = YHBunldeLocalString(dictionary[@"message"], bundle);
                [hudText showActiveHud:tip];
            });
            
        } falure:^(NSError *error) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                if ([errorString hasSuffix:@")"] == YES) {
                    NSArray  *array  = [errorString componentsSeparatedByString:@"("];
                    NSString *codeString = [array[1] stringByReplacingOccurrencesOfString:@")" withString:@""];
                    if ([codeString isEqualToString:@"500"]) {
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:falure];
                    } else {
                        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                        id dic = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                        //id dic = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        if (dic) {
                            NSDictionary *dictionary = dic;
                            NSString *string = [NSString stringWithFormat:@"%@",dictionary[@"message"]];
                            hudText = [[ZZPhotoHud alloc] init];
                            [hudText showActiveHud:string];
                        }
                    }
                    
                } else {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:timeout];
                }
            });
        }];
    }
}

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    CGFloat t_h = 50;
    CGFloat b_y = 15;
    CGFloat b_h = 45;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, t_h+b_y+b_h)];
    footerView.backgroundColor = CLEARCOLOR;
    mainTable.tableFooterView = footerView;
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, t_h)];
    textView.backgroundColor = WHITECOLOR;
    [footerView addSubview:textView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, t_h-0.5, SCREEN_W, 0.5)];
    line.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    
    NSString *number  = [bundle localizedStringForKey:@"number" value:nil table:@"localizable"];
    NSString *number1 = [bundle localizedStringForKey:@"enter_number" value:nil table:@"localizable"];
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    CGFloat l_x = 15;
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, 95, t_h)];
    otherLabel.text = number;
    otherLabel.font = TEXTFONT6;
    otherLabel.textColor = TEXTCOLOR;
    [textView addSubview:otherLabel];
    
    CGFloat t_w = SCREEN_W-otherLabel.right-10;
    numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(otherLabel.right, 0, t_w, t_h)];
    numberTextField.delegate = self;
    numberTextField.placeholder = number1;
//    numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    numberTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    numberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberTextField.font = TEXTFONT6;
    numberTextField.textColor = TEXTCOLOR;
    [textView addSubview:numberTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(b_y, textView.bottom+b_y, SCREEN_W-b_y*2, b_h);
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [sureButton setTitle:confirm forState:UIControlStateNormal];
    [sureButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    sureButton.titleLabel.font = TEXTFONT6;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sureButton];
    sureButton.userInteractionEnabled = NO;
}

- (void)createTypeTable {
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:backgroundView];
    
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 300)];
    typeView.backgroundColor = WHITECOLOR;
    [backgroundView addSubview:typeView];
    
    CGFloat l_h = 45;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h-line_h, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    [typeView addSubview:line];
    
    CGFloat b_x = 10;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(b_x, b_x, l_h-b_x*2, l_h-b_x*2);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(closeButton.right+5, 0, SCREEN_W-closeButton.right*2-10, l_h)];
    titleLabel.font = TEXTFONT6;
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [typeView addSubview:titleLabel];
    
    if (isType == YES) {
        titleLabel.text = [bundle localizedStringForKey:@"asset_type" value:nil table:@"localizable"];
        
        typeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, typeView.height-l_h)];
        typeTable.delegate = self;
        typeTable.dataSource = self;
        typeTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [self setExtraCellLineHidden:typeTable];
        [typeView addSubview:typeTable];
        
    } else {
        titleLabel.text = [bundle localizedStringForKey:@"block_address1" value:nil table:@"localizable"];
        
        addressTable = [[UITableView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, typeView.height-l_h)];
        addressTable.delegate = self;
        addressTable.dataSource = self;
        addressTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [self setExtraCellLineHidden:addressTable];
        [typeView addSubview:addressTable];
    }
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        typeView.frame = CGRectMake(0, SCREEN_H-typeView.height, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == mainTable) {
        
        return dataArray.count;
        
    } else if (tableView == typeTable) {
        
        return typeArray.count;
        
    } else {
        return addressArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == mainTable) {
        
        static NSString *cellId = @"tableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            
            CGFloat l_x = 15;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, 44.5, SCREEN_W-l_x*2, 0.5)];
            line.backgroundColor = LINECOLOR;
            [cell addSubview:line];
        }
        if (dataArray.count) {
            cell.textLabel.text = dataArray[indexPath.row];
            cell.textLabel.font = TEXTFONT6;
            cell.textLabel.textColor = TEXTCOLOR;
            cell.detailTextLabel.textColor = GRAYCOLOR;
            cell.detailTextLabel.font = TEXTFONT5;
        }
        
        if ([self.type isEqualToString:@"1"]) {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = blockchainType;
            } else {
                cell.detailTextLabel.text = blockchainAddress;
            }
            
        } else {
            if (indexPath.row == 0) {
                if (!blockchainType) {
                    blockchainType = [NSString stringWithFormat:@"%@",self.type];
                }
                cell.detailTextLabel.text = blockchainType;
            } else {
                cell.detailTextLabel.text = blockchainAddress;
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    } else if (tableView == typeTable) {
        
        static NSString *cellId = @"PaymentTableViewCell";
        PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            CGFloat l_x = 20;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, 44.5, SCREEN_W-l_x*2, 0.5)];
            line.backgroundColor = LINECOLOR;
            [cell addSubview:line];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (typeArray.count) {
            AssetsTypeModel *item = typeArray[indexPath.row];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
            UIImage *image = [UIImage imageNamed:@"icon_type"];
            [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
            cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
            if (typeArray1.count) {
                if ([typeArray1[indexPath.row] isEqualToString:@"1"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = MAINCOLOR;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        static NSString *cellId = @"TableViewCell";
        PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            CGFloat l_x = 20;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, 44.5, SCREEN_W-l_x*2, 0.5)];
            line.backgroundColor = LINECOLOR;
            [cell addSubview:line];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSURL *url;
        if ([self.imageUrl isEqualToString:@"1"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",blockchainImage]];
            
        } else {
            if (!blockchainImage) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageUrl]];
            } else {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",blockchainImage]];
            }
        }
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        
        if (addressArray.count) {
            cell.typeLabel.text  = [NSString stringWithFormat:@"%@",addressArray[indexPath.row]];
            if (addressArray1.count) {
                if ([addressArray1[indexPath.row] isEqualToString:@"1"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = MAINCOLOR;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == mainTable) {
        if (indexPath.row == 0) {
            isType = YES;
            [self getAssetsList];
        } else if (indexPath.row == 1) {
            isType = NO;
            [self getAddressList];
        }
        
    } else if (tableView == typeTable) {
        [typeArray1 removeAllObjects];
        if (typeArray.count) {
            for (int i = 0; i < typeArray.count; i ++) {
                [typeArray1 addObject:@"0"];
            }
            [typeArray1 replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [typeTable reloadData];
            AssetsTypeModel *item = typeArray[indexPath.row];
            blockchainType  = [NSString stringWithFormat:@"%@",item.type];
            blockchainImage = [NSString stringWithFormat:@"%@",item.path];
        }

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mainTable reloadData];
            [self closeClick];
        });
        
    } else {
        [addressArray1 removeAllObjects];
        if (addressArray.count) {
            for (int i = 0; i < addressArray.count; i ++) {
                [addressArray1 addObject:@"0"];
            }
            [addressArray1 replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [addressTable reloadData];
            blockchainAddress  = [NSString stringWithFormat:@"%@",addressArray[indexPath.row]];
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mainTable reloadData];
            [self closeClick];
        });
    }
}

- (void)closeClick {
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
        typeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [typeView removeFromSuperview];
        if (isType == YES) {
            [typeTable removeFromSuperview];
        } else {
            [addressTable removeFromSuperview];
        }
    }];
}

- (BOOL)testNumber {
    
    NSString *account = numberTextField.text;
    //去除回车
    account = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    account = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *asset = [bundle localizedStringForKey:@"asset_type1" value:nil table:@"localizable"];
    NSString *address = [bundle localizedStringForKey:@"block_address1" value:nil table:@"localizable"];
    NSString *number  = [bundle localizedStringForKey:@"enter_number" value:nil table:@"localizable"];
    if (!blockchainType) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:asset];
        return NO;
    } else if (!blockchainAddress) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:address];
        return NO;
    } else if ([account isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:number];
        return NO;
    }
    return YES;
}

- (void)createTextField {
    
    passwordView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W , SCREEN_H)];
    passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:passwordView];
    
    CGFloat i_x = 10;
    CGFloat i_y = 10;
    CGFloat i_w = 25;
    CGFloat l_x = i_x*2+i_w;
    CGFloat l_w = SCREEN_W-l_x*2;
    CGFloat l_h = 45;
    CGFloat t_x = 20;
    CGFloat t_y = 20;
    CGFloat t_w = SCREEN_W-t_x*2;
    CGFloat t_h = t_w/6;
    CGFloat l_h1 = 30;
    CGFloat v_y = (SCREEN_H-l_h-t_y-t_h-l_h1)/2;
    v_h = SCREEN_H-v_y;
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, v_h)];
    alertView.backgroundColor = TABLEBLACK;
    [passwordView addSubview:alertView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xc3c3c3);
    [alertView addSubview:line];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(i_x, i_y, i_w, i_w);
    [cancelButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelButton];
    
    NSString *_password = [bundle localizedStringForKey:@"pay_password1" value:nil table:@"localizable"];
    NSString *forgot = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, l_h)];
    inputLabel.text = _password;
    inputLabel.font = TEXTFONT6;
    inputLabel.textColor = UIColorFromRGB(0x303030);
    inputLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:inputLabel];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom+t_y, t_w, t_h)];
    textView.backgroundColor = WHITECOLOR;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColorFromRGB(0x8c8c8c) CGColor];
    [alertView addSubview:textView];
    
    for (int i = 0; i < 5; i ++) {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(t_h+t_h*i, 0, 0.5, t_h)];
        line1.backgroundColor = UIColorFromRGB(0xe0e0e0);
        [textView addSubview:line1];
    }
    
    CGFloat d_w = t_h/5;
    CGFloat d_x = (t_h-d_w)/2;
    CGFloat t_l = t_h-d_w;
    dot1 = [[UIImageView alloc]initWithFrame:CGRectMake(d_x, d_x, d_w, d_w)];
    dot1.backgroundColor = BLACKCOLOR;
    dot1.layer.cornerRadius = t_h/10;
    dot1.layer.masksToBounds = YES;
    [textView addSubview:dot1];
    
    dot2 = [[UIImageView alloc]initWithFrame:CGRectMake(dot1.right+t_l, d_x, d_w, d_w)];
    dot2.backgroundColor = BLACKCOLOR;
    dot2.layer.cornerRadius = t_h/10;
    dot2.layer.masksToBounds = YES;
    [textView addSubview:dot2];
    
    dot3 = [[UIImageView alloc]initWithFrame:CGRectMake(dot2.right+t_l, d_x, d_w, d_w)];
    dot3.backgroundColor = BLACKCOLOR;
    dot3.layer.cornerRadius = t_h/10;
    dot3.layer.masksToBounds = YES;
    [textView addSubview:dot3];
    
    dot4 = [[UIImageView alloc]initWithFrame:CGRectMake(dot3.right+t_l, d_x, d_w, d_w)];
    dot4.backgroundColor = BLACKCOLOR;
    dot4.layer.cornerRadius = t_h/10;
    dot4.layer.masksToBounds = YES;
    [textView addSubview:dot4];
    
    dot5 = [[UIImageView alloc]initWithFrame:CGRectMake(dot4.right+t_l, d_x, d_w, d_w)];
    dot5.backgroundColor = BLACKCOLOR;
    dot5.layer.cornerRadius = t_h/10;
    dot5.layer.masksToBounds = YES;
    [textView addSubview:dot5];
    
    dot6 = [[UIImageView alloc]initWithFrame:CGRectMake(dot5.right+t_l, d_x, d_w, d_w)];
    dot6.backgroundColor = BLACKCOLOR;
    dot6.layer.cornerRadius = t_h/10;
    dot6.layer.masksToBounds = YES;
    [textView addSubview:dot6];
    
    dot1.hidden = YES;
    dot2.hidden = YES;
    dot3.hidden = YES;
    dot4.hidden = YES;
    dot5.hidden = YES;
    dot6.hidden = YES;
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom+t_y, t_w/2, t_h+l_h1)];
    passwordTextField.delegate = self;
//    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordTextField.tintColor = CLEARCOLOR;
    passwordTextField.textColor = CLEARCOLOR;
    [alertView addSubview:passwordTextField];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(passwordTextField.right, textView.bottom, t_w/2, l_h1);
    [forgetButton setTitle:forgot forState:UIControlStateNormal];
    forgetButton.titleLabel.font = TEXTFONT3;
    [forgetButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:forgetButton];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        alertView.frame = CGRectMake(0, v_y, SCREEN_W, v_h);
        [passwordTextField becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidChanged {
    
    if (numberTextField) {
        if (numberTextField.text.length > 0) {
            sureButton.userInteractionEnabled = YES;
            sureButton.backgroundColor = MAINCOLOR;
        } else {
            sureButton.userInteractionEnabled = NO;
            sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
        }
    }
    
    if (passwordTextField.text.length == 0) {
        dot1.hidden = YES;
        dot2.hidden = YES;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 1) {
        dot1.hidden = NO;
        dot2.hidden = YES;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 2) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 3) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 4) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 5) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 6) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = NO;
        
        [passwordTextField resignFirstResponder];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
            alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, v_h);
            
        } completion:^(BOOL finished) {
            [passwordView removeFromSuperview];
            [alertView removeFromSuperview];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self patchData];
            });
        }];
    }
}

- (void)cancelClick {
    
    [passwordTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, v_h);
        
    } completion:^(BOOL finished) {
        [passwordView removeFromSuperview];
        [alertView removeFromSuperview];
    }];
}

- (void)sureClick {

    [numberTextField resignFirstResponder];
    if ([self testNumber]) {
        if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
            [self createTextField];
        } else {
            NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
            NSString *set = [bundle localizedStringForKey:@"pay_set_not" value:nil table:@"localizable"];
            NSString *cansel = [bundle localizedStringForKey:@"cansel" value:nil table:@"localizable"];
            NSString *setting = [bundle localizedStringForKey:@"setting" value:nil table:@"localizable"];
            NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
            NSString *pay = [bundle localizedStringForKey:@"payment_password" value:nil table:@"localizable"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:set preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                PayPasswordViewController *payVC = [[PayPasswordViewController alloc] init];
                payVC.isColor = YES;
                payVC.back = back;
                payVC.navigationTitle = pay;
                [self.navigationController pushViewController:payVC animated:YES];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)forgetClick {
    
    NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
    NSString *forget = [bundle localizedStringForKey:@"forget_pay_password" value:nil table:@"localizable"];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, v_h);
        [passwordTextField resignFirstResponder];
        
    } completion:^(BOOL finished) {
        [passwordView removeFromSuperview];
        [alertView removeFromSuperview];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
            forgetVC.isColor = YES;
            forgetVC.navigationTitle = forget;
            forgetVC.back = back;
            [self.navigationController pushViewController:forgetVC animated:YES];
        });
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

@implementation AssetsTypeModel

- (void)initWithData:(NSDictionary *)dic {
    self.path         = dic[@"path"];
    self.type         = dic[@"type"];
    self.detail_color = dic[@"detail_color"];
    self.detail_path  = dic[@"detail_path"];
}

@end


















