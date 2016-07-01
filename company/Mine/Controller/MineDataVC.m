//
//  MineDataVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineDataVC.h"
#import "MyDataIconCell.h"
#import "MyDataArrowCell.h"
#import "MyDataHeaderCell.h"
#import "MyDataNoArrowCell.h"
#import "MineRingCodeVC.h"
#import "PlatformIdentityVC.h"
#import "MyDataCompanyVC.h"

#import "RenzhengViewController.h"

#import "MineViewController.h"

#import "MIneAreaVC.h"

#define AUTHENTICQUICK @"requestAuthenticQuick"
#define MODIFYCITY @"requestModifyCity"
#define MODIFYPOSITION @"requestModifyPosition"
#define MODIFYCOMPANY @"requestModifyCompany"
#define CHANGEHEADERPIC @"requestChangeHeaderPicture"
#define INVITECODE @"requestInviteCode"
@interface MineDataVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UIImagePickerController *imagePicker;
}

@property (nonatomic, strong) NSArray *textArray;    //
@property (nonatomic, strong) NSMutableArray *dataArray;    //
@property (nonatomic, strong) UIButton *bottomBtn;    // 底部btn
@property (nonatomic, strong) UILabel *bottomLabel;    //底部label

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, copy) NSString *authenticType; //身份标识

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifyType;
@property (nonatomic, copy) NSString *identifyNum;


@property (nonatomic, copy) NSString *invitePartner;
@property (nonatomic, copy) NSString *changeIconPartner;
@property (nonatomic, copy) NSString *companyPartner;
@property (nonatomic, copy) NSString *positionPartner;
@property (nonatomic, copy) NSString *cityPartner;
@property (nonatomic, copy) NSString *quickPartner;

@end

@implementation MineDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得partner
    self.invitePartner = [TDUtil encryKeyWithMD5:KEY action:INVITECODE];
    self.changeIconPartner = [TDUtil encryKeyWithMD5:KEY action:CHANGEHEADERPIC];
    self.companyPartner = [TDUtil encryKeyWithMD5:KEY action:MODIFYCOMPANY];
    self.positionPartner = [TDUtil encryKeyWithMD5:KEY action:MODIFYPOSITION];
    self.cityPartner = [TDUtil encryKeyWithMD5:KEY action:MODIFYCITY];
    self.quickPartner  = [TDUtil encryKeyWithMD5:KEY action:AUTHENTICQUICK];
    
    [self loadInviteCode];
    
    
    _textArray = [NSArray array];
    [self createLeftArray];
    
    [self setupNav];
    
    [self createTableView];
    
    [self createBottomView];
}

-(void)loadInviteCode
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.invitePartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUESTINVITECODE postParam:dic type:1 delegate:self sel:@selector(requestInviteCode:)];
}
-(void)requestInviteCode:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            _inviteCode = [jsonDic valueForKey:@"data"];
        }
    }
}
-(void)createLeftArray
{
    NSArray *authenticsArray = _authenticModel.authentics;
    ProjectAuthentics *authentics = authenticsArray[0];
    if ([authentics.authenticstatus.name isEqualToString:@"已认证"]) {
        _textArray = @[@"头像",@"指环码",@"实名认证信息(已认证)",@"姓名",@"平台身份",@"身份证号码",@"",@"公司",@"职位",@"所在地"];
        _authenticType = @"已认证";
    }
    if ([authentics.authenticstatus.name isEqualToString:@"认证中"]) {
        _textArray = @[@"头像",@"指环码",@"实名认证信息(认证中)",@"姓名",@"平台身份",@"身份证号码",@"",@"公司",@"职位",@"所在地"];
        _authenticType = @"认证中";
    }
    if ([authentics.authenticstatus.name isEqualToString:@"未认证"]) {
        _textArray = @[@"头像",@"指环码",@"实名认证信息(未认证)",@"姓名",@"平台身份",@"身份证号码",@"",@"公司",@"职位",@"所在地"];
        _authenticType = @"未认证";
    }
    if ([authentics.authenticstatus.name isEqualToString:@"认证失败"]) {
        _textArray = @[@"头像",@"指环码",@"实名认证信息(认证失败)",@"姓名",@"平台身份",@"身份证号码",@"",@"公司",@"职位",@"所在地"];
        _authenticType = @"认证失败";
    }
    
    _icon = _authenticModel.headSculpture;
    _name = authentics.name;
    _identifyType = authentics.identiytype.name;
    NSString *qian = [authentics.identiyCarNo substringToIndex:3];
    NSString *hou = [authentics.identiyCarNo substringFromIndex:14];
    _identifyNum = [NSString stringWithFormat:@"%@***********%@",qian,hou];
    _companyName = authentics.companyName;
    _position = authentics.position;
    
    NSString *province = authentics.city.province.name;
    NSString *city = authentics.city.name;
    _address = [NSString stringWithFormat:@"%@ | %@",province,city];
    
}
#pragma mark- 创建tableView
-(void)createTableView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView  = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(450*HEIGHTCONFIG);
    }];
    
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"我的资料";
}
#pragma mark -初始化底部视图
-(void)createBottomView
{
    //上边label
    _bottomLabel = [UILabel new];
    [_bottomLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    _bottomLabel.numberOfLines = 0;
    _bottomLabel.font = BGFont(13);
    _bottomLabel.textColor = color(74, 74, 74, 1);
    
    if ([_authenticType isEqualToString:@"未认证"]) {
        _bottomLabel.text = @"温馨提示:\r\n       实名认证用户可以获得更多的权限，只有实名认证用户才可以参与平台股权投融资";
    }
    if ([_authenticType isEqualToString:@"认证中"]) {
        _bottomLabel.text = @"温馨提示:\r\n       1.实名认证用户可以获得更多的权限，只有实名认证用户才可以参与平台股权投融资\r\n       2.将于两个工作日内进行审核";
    }
    
    if ([_authenticType isEqualToString:@"认证失败"]) {
        _bottomLabel.text = @"温馨提示:\r\n       您的认证信息未通过审核，具体原因请查看短信或系统通知";
    }
    
    
    [self.view addSubview:_bottomLabel];
    
    
    
    _bottomLabel.sd_layout
    .leftSpaceToView(self.view,10*WIDTHCONFIG)
    .rightSpaceToView(self.view,10*WIDTHCONFIG)
    .topSpaceToView(_tableView,10*HEIGHTCONFIG)
    .autoHeightRatio(0);
    
    
    //底部button
    _bottomBtn = [UIButton new];
    _bottomBtn.layer.cornerRadius = 3;
    _bottomBtn.layer.masksToBounds = YES;
    _bottomBtn.backgroundColor = orangeColor;
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = BGFont(17);
    [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
    
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10*HEIGHTCONFIG);
        make.height.mas_equalTo(35*HEIGHTCONFIG);
        make.width.mas_equalTo(288*WIDTHCONFIG);
    }];
    
    if ([_authenticType isEqualToString:@"已认证"]) {
        [_bottomBtn setHidden:YES];
    }
    if ([_authenticType isEqualToString:@"未认证"]) {
        [_bottomBtn setTitle:@"立即认证" forState:UIControlStateNormal];
    }
    if ([_authenticType isEqualToString:@"认证中"]) {
        [_bottomBtn setTitle:@"催一催" forState:UIControlStateNormal];
    }
    if ([_authenticType isEqualToString:@"认证失败"]) {
        [_bottomBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    }
}
#pragma mark-----------------底部执行按钮-------------------
-(void)bottomBtnClick
{
    if ([_authenticType isEqualToString:@"未认证"]) {
        RenzhengViewController  * renzheng = [RenzhengViewController new];
        renzheng.identifyType = [NSString stringWithFormat:@"%ld",(long)self.identiyTypeId];
        [self.navigationController.navigationBar setHidden:YES];
        [self.navigationController pushViewController:renzheng animated:YES];
    }
    if ([_authenticType isEqualToString:@"认证中"]) {
        
        [self authenticQuick];
    }
    if ([_authenticType isEqualToString:@"认证失败"]) {
        RenzhengViewController  * renzheng = [RenzhengViewController new];
        renzheng.identifyType = [NSString stringWithFormat:@"%ld",(long)self.identiyTypeId];
        [self.navigationController.navigationBar setHidden:YES];
        [self.navigationController pushViewController:renzheng animated:YES];
    }
}
-(void)authenticQuick
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.quickPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.authId],@"authId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_AUTHENTIC_QUICK postParam:dic type:1 delegate:self sel:@selector(requestAuthQuick:)];
}
-(void)requestAuthQuick:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 98*HEIGHTCONFIG;
    }

    if (indexPath.row == 6) {
        return 9*HEIGHTCONFIG;
    }
    if (indexPath.row == 2) {
        return 35*HEIGHTCONFIG;
    }
    return 44*HEIGHTCONFIG;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * cellId = @"MyDataIconCell";
        MyDataIconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        cell.titleLabel.text = _textArray[indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_icon]] placeholderImage:[UIImage new]];
        _iconImage = cell.iconImage;
        return cell;
    }
    if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) {
        static NSString *cellId = @"MyDataArrowCell";
        MyDataArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        
        if (indexPath.row == 1 || indexPath.row == 9) {
            cell.bottomLine.hidden = YES;
        }
        cell.leftLabel.text = _textArray[indexPath.row];
        //平台身份   ----不变
        if (indexPath.row == 1) {
            cell.rightLabel.text = _inviteCode;
            cell.rightLabel.textColor = color47;
        }
        if (indexPath.row == 4) {
            cell.rightLabel.text = _identifyType;
            cell.rightLabel.textColor = color47;
        }
        if ([_authenticType isEqualToString:@"认证失败"]) {
            if (indexPath.row == 7) {
                cell.rightLabel.text = @"";
            }
            if (indexPath.row == 8) {
                cell.rightLabel.text = @"";
            }
            if (indexPath.row == 9) {
                cell.rightLabel.text = @"";
            }
        }
        if ([_authenticType isEqualToString:@"认证中"]) {
            if (indexPath.row == 7) {
                cell.rightLabel.text = @"认证中";
            }
            if (indexPath.row == 8) {
                cell.rightLabel.text = @"认证中";
            }
            if (indexPath.row == 9) {
                cell.rightLabel.text = @"认证中";
            }
        }
        if ([_authenticType isEqualToString:@"已认证"]) {
            if (indexPath.row == 7) {
                cell.rightLabel.text = _companyName;
            }
            if (indexPath.row == 8) {
                cell.rightLabel.text = _position;
            }
            if (indexPath.row == 9) {
                cell.rightLabel.text = _address;
            }
        }
        if ([_authenticType isEqualToString:@"未认证"]) {
            cell.rightLabel.textColor = [UIColor redColor];
            if (indexPath.row == 7) {
                cell.rightLabel.text = @"未认证";
            }
            if (indexPath.row == 8) {
                cell.rightLabel.text = @"未认证";
            }
            if (indexPath.row == 9) {
                cell.rightLabel.text = @"未认证";
            }
            
            if(indexPath.row == 1 || indexPath.row==4)
            {
                cell.rightLabel.textColor = color47;
            }
            
            NSLog(@"cell row:%ld",(long)indexPath.row);
        }
        
        
        
        return cell;
    }
    if (indexPath.row == 2 || indexPath.row == 6) {
        static NSString *cellId =@"MyDataHeaderCell";
        MyDataHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        cell.titleLabel.text = _textArray[indexPath.row];
        
        return cell;
    }
    
    static NSString *cellId = @"MyDataNoArrowCell";
    MyDataNoArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 5) {
        cell.bottomLine.hidden = YES;
    }
    cell.leftLabel.text = _textArray[indexPath.row];
    if ([_authenticType isEqualToString:@"认证失败"]) {
        if (indexPath.row == 3) {
            cell.rightLabel.text = @"";
        }
        if (indexPath.row == 5) {
            cell.rightLabel.text = @"认证失败";
            cell.rightLabel.textColor = [UIColor redColor];
        }
    }
    if ([_authenticType isEqualToString:@"已认证"]) {
        if (indexPath.row == 3) {
            cell.rightLabel.text = _name;
        }
        if (indexPath.row == 5) {
            cell.rightLabel.text = _identifyNum;
        }
    }
    if ([_authenticType isEqualToString:@"未认证"]) {
        if (indexPath.row == 3) {
            cell.rightLabel.text = @"未认证";
        }
        if (indexPath.row == 5) {
            cell.rightLabel.text = @"未认证";
        }
        cell.rightLabel.textColor = [UIColor redColor];
    }
    if ([_authenticType isEqualToString:@"认证中"]) {
        if (indexPath.row == 3) {
            cell.rightLabel.text = @"认证中";
        }
        if (indexPath.row == 5) {
            cell.rightLabel.text = @"认证中";
        }
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self chooseicon];
        
    }
    
    if (indexPath.row == 1) {
        MineRingCodeVC *vc = [MineRingCodeVC new];
        vc.inviteCode = _inviteCode;
        vc.icon = _icon;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 4) {
        PlatformIdentityVC *vc = [PlatformIdentityVC new];
        vc.identifyType = _identifyType;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 8) {
        MyDataCompanyVC *vc = [MyDataCompanyVC new];
        vc.titleName = @"职位";
        vc.datavc = self;
        vc.placorText = _position;
        [self.navigationController  pushViewController:vc animated:YES];
    }
    if (indexPath.row == 7) {
        MyDataCompanyVC *vc = [MyDataCompanyVC new];
        vc.titleName = @"公司";
        vc.placorText = _companyName;
        vc.datavc = self;
        [self.navigationController  pushViewController:vc animated:YES];
    }
    if (indexPath.row == 9) {
        MIneAreaVC *vc = [MIneAreaVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

#pragma mark ------选择头像
-(void)chooseicon
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    __block MineDataVC* blockSelf = self;
    // Create the actions.
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf takePhoto];
    }];
    
    UIAlertAction *chooiceAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf pickImageFromAlbum];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    // Add the actions.
    [alertController addAction:takePhotoAction];
    [alertController addAction:chooiceAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//从相册选择
-(void)pickImageFromAlbum
{
    imagePicker = [[UIImagePickerController alloc]init];
    //从相片库中加载图片
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    //允许编辑
    [imagePicker setAllowsEditing:YES];
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    
}
//拍照
-(void)takePhoto
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark - UIImagePickerControllerDelegate
//得到照片后，调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_iconImage setImage:image];
    //更换头像
    [self changeIcon];
    
   
    
}

//点击cancle
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark-------更改头像-----------------
-(void)changeIcon
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.changeIconPartner,@"partner", nil];
    UIImage *iconImage = _iconImage.image;
    //压缩图片
    iconImage = [TDUtil drawInRectImage:iconImage size:CGSizeMake(300, 300)];
    //保存图片
    [TDUtil saveContent:iconImage fileName:@"iconImage"];
    //上传图片字典
    NSDictionary *picDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"iconImage",@"file", nil];
    
    [self.httpUtil getDataFromAPIWithOps:REQUEST_CHANGE_HEADERPIC postParam:dic files:picDic type:0 delegate:self sel:@selector(requestChangeIcon:)];
}
-(void)requestChangeIcon:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            for (UIViewController *VC in self.navigationController.viewControllers)
            {
                if ([VC isKindOfClass:[MineViewController class]]) {
                    MineViewController *vc = (MineViewController*)VC;
                    
                    
                    [vc loadAuthenData];
                    
                }
            }
            
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
@end
