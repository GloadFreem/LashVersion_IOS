//
//  RenzhengViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "RenzhengViewController.h"
#import "Renzheng2ViewController.h"
#import "AreaViewController.h"
#import "DetailAreaViewController.h"
#import "InvistViewController.h"

#import "Renzheng3ViewController.h"
#import "Renzheng4ViewController.h"

#import "IdentityTableViewCell.h"
#import "EditTableViewCell.h"

@interface RenzhengViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,IdentityTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UIImagePickerController *imagePicker;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) NSString *partner;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextStup;
@property (nonatomic, strong) NSArray * leftLableArr;
@property (nonatomic, strong) NSMutableArray *textFieldArr;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *btnImage;  //当前身份证button
@property (nonatomic, assign) BOOL selectedA; //选择正面照片
@property (nonatomic, assign) BOOL selectedB; //选择反面照片
@property (nonatomic, assign) NSInteger identifyNumber; //身份证照片tag
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation RenzhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:@"requestAuthentic"];
    
    //初始化投资领域
    self.investField = @"";
    self.companyAddress = @"";
    [self createTableView];
    
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    //初始化数据字典
    if (!_dataDic) {
        NSArray *keyArray = [NSArray arrayWithObjects:@"key",@"partner",@"areaId", @"identiyTypeId",@"industoryId",@"cityId",@"name",@"identiyCarNo",@"companyName",@"companyAddress",@"position",@"buinessLicenceNo",@"introduce",@"companyIntroduce",@"optional",nil];
        NSArray *objectArray = [NSArray arrayWithObjects:@"",@"",@"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
        _dataDic = [NSMutableDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
    }
    //初始化标题
    if ([self.identifyType integerValue] == 1) {
        self.titleLabel.text = @"(1/2)";
    }else if([self.identifyType integerValue] == 2 || [self.identifyType integerValue] == 4){
        self.titleLabel.text = @"(1/3)";
    }else{
        self.titleLabel.text = @"(1/4)";
    }
    
    //初始化tableView高度
    if ([self.identifyType integerValue] == 3 || [self.identifyType integerValue] == 4) {
        _tableViewHeight.constant = 510;
        
    }else if ([self.identifyType integerValue] == 1){
        _tableViewHeight.constant = 460;
    }
    else{
        _tableViewHeight.constant = 410;
    }
    
    [self createData];
}

-(void)createTableView
{
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.scrollEnabled = NO;
    _tableView.delegate =self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"IdentityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
    _nextStup.layer.cornerRadius = 20;
    _nextStup.layer.masksToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
//创建数据
-(void)createData{
    if ([self.identifyType integerValue] == 1) {
        _leftLableArr = [NSArray arrayWithObjects:@"身份证号码",@"真实姓名",@"公司名称",@"公司所在地",@"担任职位",nil];
        _textFieldArr  = [[NSMutableArray alloc]initWithObjects:@"请输入身份证号码",@"请输入真实姓名",@"请输入公司名称",@"请选择公司所在地",@"请输入职位", nil];
    }
    if ([self.identifyType integerValue] == 2) {
        _leftLableArr = [NSArray arrayWithObjects:@"身份证号码",@"真实姓名",@"所在地",@"投资领域", nil];
        _textFieldArr  = [[NSMutableArray alloc]initWithObjects:@"请输入身份证号码",@"请输入真实姓名",@"请选择所在地",@"请选择投资领域", nil];
    }
    if ([self.identifyType integerValue] == 3) {
        _leftLableArr = [NSArray arrayWithObjects:@"身份证号码",@"真实姓名",@"公司名称",@"公司所在地",@"担任职位",@"投资领域",nil];
        _textFieldArr  = [[NSMutableArray alloc]initWithObjects:@"请输入身份证号码",@"请输入真实姓名",@"请输入公司名称",@"请选择公司所在地",@"请输入职位",@"请选择投资领域", nil];
    }
    if ([self.identifyType integerValue] == 4) {
        _leftLableArr = [NSArray arrayWithObjects:@"身份证号码",@"真实姓名",@"公司名称",@"公司所在地",@"担任职位",@"服务领域" ,nil];
        _textFieldArr  = [[NSMutableArray alloc]initWithObjects:@"请输入身份证号码",@"请输入真实姓名",@"请输入公司名称(选填)",@"请选择公司所在地",@"请输入职位(选填)", @"请选择服务领域",nil];
    }
    
    for (NSInteger i=0; i<_leftLableArr.count; i++) {
        [self.dataArray addObject:@""];
    }
    
}

#pragma mark -- tableView  data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _leftLableArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    return 50;
}
//第二段区头高度为10
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
#pragma mark- tableView  delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"IdentityTableViewCell";
        IdentityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        cell.delegate = self;
        
        return cell;
    }
    
    static NSString * cellId = @"EditTableViewCell";
    EditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EditTableViewCell" owner:nil options:nil] lastObject];
        
    }

        if ([self.identifyType integerValue] ==1)
        {
            //项目方
            
            if (indexPath.row == 0) {
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            }
            //第四个cell的特殊属性
            if (indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.inputTextField.userInteractionEnabled = NO;
            }
            
        }else if ([self.identifyType integerValue] ==2){
            //投资人
            
            if (indexPath.row == 0) {
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            }
            //第三、四个cell的特殊属性
            if ( indexPath.row == 2 || indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.inputTextField.userInteractionEnabled = NO;
            }
            
           
        }else{
            
            if (indexPath.row == 0) {
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            }
            //第四、六个cell的特殊属性
            if ( indexPath.row == 3 || indexPath.row == 5) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.inputTextField.userInteractionEnabled = NO;
            }
        }
    
        //设置左边label的值
        cell.leftLabel.text = _leftLableArr[indexPath.row];
        cell.inputTextField.tag = indexPath.row;
        cell.inputTextField.placeholder = _textFieldArr[indexPath.row];
        cell.inputTextField.text = self.dataArray[indexPath.row];
        cell.inputTextField.delegate = self;
        //计算label的宽度
        CGFloat width =  [cell.leftLabel.text commonStringWidthForFont:16];
        cell.leftLabelWidth.constant = width + 16;
        return cell;
}

#pragma mark - tableView点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //项目方
    if ([self.identifyType integerValue] == 1) {
        if (indexPath.row == 3) {
//            NSLog(@"项目方选择地址");
            AreaViewController * area = [AreaViewController new];
            [self.navigationController pushViewController:area animated:YES];
        }
        
    }else if([self.identifyType integerValue] == 2){
        //投资人
      if (indexPath.row == 2) {
//          NSLog(@"投资人选择地址");
          AreaViewController * area = [AreaViewController new];
          [self.navigationController pushViewController:area animated:YES];
    }
      if (indexPath.row == 3) {
//          NSLog(@"投资人选择投资领域");
          InvistViewController *invest = [InvistViewController new];
          [self.navigationController pushViewController:invest animated:YES];
        }
    }else if ([self.identifyType integerValue] == 3 || [self.identifyType integerValue] == 4){
      if (indexPath.row == 3) {
//            NSLog(@"投资机构选择地址");
            AreaViewController * area = [AreaViewController new];
            [self.navigationController pushViewController:area animated:YES];
        }
        
        if (indexPath.row == 5) {
//            NSLog(@"投资机构选择投资领域");
            InvistViewController *invest = [InvistViewController new];
            [self.navigationController pushViewController:invest animated:YES];
        }
    }
    
}

-(void)refreshData
{
    //项目方
    if ([self.identifyType integerValue] == 1) {
        self.dataArray[3] = self.companyAddress;
        
    }
    //投资人
    if ([self.identifyType integerValue] == 2) {
        self.dataArray[2] = self.companyAddress;
        
        self.dataArray[3] = self.investField;
    }
    //投资机构  智囊团
    if ([self.identifyType integerValue] == 3 || [self.identifyType integerValue] == 4) {
        self.dataArray[3] = self.companyAddress;
        self.dataArray[5] = self.investField;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
//    NSLog(@"%@",_dataArray);
}

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
   
//    if (textField.tag == 1) {
//        UITextField *field = (UITextField*)[self.view viewWithTag:0];
//        if (field.text.length !=18) {
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请检查身份证位数"];
//            return;
//        }
//    }
    if (textField.tag == 0 && ![TDUtil validateIdentityCard:textField.text]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确的身份证号"];
                    return;
    }
    if (![textField.text isEqualToString:@""]) {
        
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        self.dataArray[textField.tag] = textField.text;
    }
    
    
    NSLog(@"结束编辑");
}

#pragma mark- 下一步按钮点击校验信息
- (IBAction)nextStupClick:(UIButton *)sender {
    NSLog(@"%@",_dataArray);
    
    //判断身份证照片是否存在
    if (!_selectedA) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请添加身份证正面照片"];
        return;
    }
    
    if (!_selectedB) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请添加身份证反面照片"];
        return;
    }
    //检验身份证号码
    NSString *identifyStr = _dataArray[0];
    if ([identifyStr isEqualToString:@""] || ![TDUtil validateIdentityCard:identifyStr]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确的身份证号"];
        return;
    }
    //检验姓名
    if([_dataArray[1] isEqualToString:@""]){
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入真实姓名"];
        return;
    }
#pragma mark ---------项目方身份界面--------------------
    //设置身份证和名字信息  所在地
    [_dataDic setObject:_dataArray[0] forKey:@"identiyCarNo"];
    [_dataDic setObject:_dataArray[1] forKey:@"name"];
    [_dataDic setObject:self.cityId forKey:@"cityId"];
    [_dataDic setObject:KEY forKey:@"key"];
    [_dataDic setObject:self.partner forKey:@"partner"];
    
    //项目方身份界面
    if ([self.identifyType integerValue] ==1) {
        //检验公司名称
        if([_dataArray[2] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入公司名称"];
            return;
        }
        //检验公司所在地
        if([_dataArray[3] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司地址"];
            return;
        }
        //检验担任职位
        if([_dataArray[4] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入担任职位"];
            return;
        }
        //进入营业执照界面
        Renzheng2ViewController * regist = [Renzheng2ViewController new];
        regist.identifyType = self.identifyType;
        
        [_dataDic setObject:_dataArray[2] forKey:@"companyName"];
        
        [_dataDic setObject:_dataArray[4] forKey:@"position"];
        //字典赋值
        regist.dicData = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
        
        [self.navigationController pushViewController:regist animated:YES];
    }
    
#pragma mark ---------投资人身份界面--------------------
    
    if ([self.identifyType integerValue] ==2) {
        //所在地
        if ([_dataArray[2] isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择所在地"];
            return;
        }
        if ([_dataArray[3] isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择投资领域"];
            return;
        }
        //进入个人介绍页面
        Renzheng3ViewController * regist = [Renzheng3ViewController new];
        regist.identifyType = self.identifyType;
        
        [_dataDic setObject:self.areaId forKey:@"areaId"];
        //字典赋值
        regist.dicData = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
        
        [self.navigationController pushViewController:regist animated:YES];
    }
    
#pragma mark ---------投资机构身份界面--------------------
    
    if ([self.identifyType integerValue] ==3) {
        //检验公司名称
        if([_dataArray[2] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入公司名称"];
            return;
        }
        //检验公司所在地
        if([_dataArray[3] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司所在地"];
            return;
        }
        //检验担任职位
        if([_dataArray[4] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入担任职位"];
            return;
        }
        //检验投资领域
        if ([_dataArray[5] isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择投资领域"];
            return;
        }
        //进入营业执照页面
        Renzheng2ViewController *regist = [Renzheng2ViewController new];
        regist.identifyType = self.identifyType;
        
        [_dataDic setObject:_dataArray[2] forKey:@"companyName"];
        [_dataDic setObject:_dataArray[4] forKey:@"position"];
        [_dataDic setObject:self.areaId forKey:@"areaId"];
        //字典赋值
        regist.dicData = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
        
        [self.navigationController pushViewController:regist animated:YES];
    }
    
#pragma mark ---------智囊团身份界面--------------------
    if ([self.identifyType integerValue] ==4){
        //检验公司名称
//        if([_dataArray[2] isEqualToString:@""]){
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入公司名称"];
//            return;
//        }
        //检验公司所在地
        if([_dataArray[3] isEqualToString:@""]){
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司所在地"];
            return;
        }
        //检验担任职位
//        if([_dataArray[4] isEqualToString:@""]){
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入担任职位"];
//            return;
//        }
        //检验服务领域
        if ([_dataArray[5] isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择服务领域"];
            return;
        }
        //进入营业执照页面
        Renzheng2ViewController *regist = [Renzheng2ViewController new];
        regist.identifyType = self.identifyType;
        regist.titleLabel.text = @"2/3";
        [regist.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_dataDic setObject:_dataArray[2] forKey:@"companyName"];
        [_dataDic setObject:_dataArray[4] forKey:@"position"];
        [_dataDic setObject:self.areaId forKey:@"areaId"];
        //字典赋值
        regist.dicData = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
        
        [self.navigationController pushViewController:regist animated:YES];
    }
    
    
}


#pragma mark -IdentityTableViewCellDelegate---
-(void)didClickBtnInCell:(IdentityTableViewCell *)cell andTag:(NSInteger)tag
{
    switch (tag) {
        case 1000://正面
            self.btnImage = cell.leftBtn;
            
            _identifyNumber = tag;
            break;
        case 1001://反面
            self.btnImage = cell.rightBtn;
            
            _identifyNumber = tag;
            break;
        default:
            break;
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    __block RenzhengViewController* blockSelf = self;
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
    
    [self.btnImage setBackgroundImage:image forState:UIControlStateNormal];
    [self.btnImage setTitle:@"重新获取照片" forState:UIControlStateNormal];
    [self.btnImage setImage:[UIImage new] forState:UIControlStateNormal];
    
    //压缩图片
    image = [TDUtil drawInRectImage:image size:CGSizeMake(856, 540)];
    
    if (_identifyNumber == 1000) {
        //保存图片
       BOOL ret = [TDUtil saveContent:image fileName:@"identiyCarA"];
        if (ret) {
            NSLog(@"身份证正面保存成功");
            _selectedA = YES;
        }else{
            NSLog(@"身份证正面保存失败");
        }
    }else{
        BOOL ret =[TDUtil saveContent:image fileName:@"identiyCarB"];
        if (ret) {
            NSLog(@"身份证反面保存成功");
            _selectedB = YES;
        }else{
            NSLog(@"身份证反面保存失败");
        }
    }
}

//点击cancle
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)leftBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
