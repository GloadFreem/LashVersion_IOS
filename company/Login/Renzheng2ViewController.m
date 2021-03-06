//
//  Renzheng2ViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "Renzheng2ViewController.h"
#import "Renzheng3ViewController.h"
#import "LoadingBlackView.h"
@interface Renzheng2ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

{
    UIActivityIndicatorView *activity;
    UIImagePickerController *imagePicker;
}

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, assign) BOOL isSelectedImage;  //是否选择营业执照
@property (nonatomic, strong) LoadingBlackView *loadingBlackView;

@end

@implementation Renzheng2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化导航栏标题 和 下一步按钮标题
    if ([self.identifyType integerValue]== 1) {
        self.titleLabel.text = @"(2/2)";
        [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else if ([self.identifyType integerValue] == 3){
        self.titleLabel.text = @"(2/4)";
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }else if ([self.identifyType integerValue] == 4){
        self.titleLabel.text = @"(2/3)";
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    self.nextBtn.layer.cornerRadius = 20;
    self.nextBtn.layer.masksToBounds = YES;
    
    //打印数据字典
//    NSLog(@"数据字典：%@",self.dicData);
    
}

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
//    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (![textField.text isEqualToString:@""]) {
        
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.textField.text = textField.text;
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入营业执照号"];
    }
    
//    NSLog(@"结束编辑");
}
#pragma mark - 返回上一页
- (IBAction)leftBack:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -进入下一页验证信息
- (IBAction)nextStupClick:(UIButton *)sender {
    
    [self.textField resignFirstResponder];
    
    //判断营业执照照片是否存在
    if (!_isSelectedImage) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请添加营业执照照片"];
        return;
    }
    //判断营业执照号码
    if (self.textField.text.length == 0) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入营业执照号"];
        return;
    }
    //数据字典设置营业执照号码  key   partner
    [_dicData setObject:[NSString stringWithFormat:@"%@",self.textField.text] forKey:@"buinessLicenceNo"];
    
    
#pragma mark -项目方身份界面  提交数据 进入首页
    if ([self.identifyType integerValue] == 1) {
        //设置数据字典
        
        [_dicData setObject:[NSString stringWithFormat:@"%@",self.identifyType] forKey:@"identiyTypeId"];
        
//        NSLog(@"打印数据%@",_dicData);
        //读取图片加到图片字典 并请求数据
        //检验照片是否存在
        BOOL retA =[TDUtil checkImageExists:@"identiyCarA"];
        
        BOOL retB =[TDUtil checkImageExists:@"identiyCarB"];
        
        BOOL retC =[TDUtil checkImageExists:@"buinessLicence"];
        
        //加到上传文件字典
        if (retA && retB && retC) {
            NSDictionary *fileDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"identiyCarA",@"identiyCarA",@"identiyCarB",@"identiyCarB",@"buinessLicence",@"buinessLicence", nil];

            //上传文件
            self.loadingViewFrame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
            [self addBlackView];
            self.startLoading = YES;
            self.isTransparent = YES;
            self.isBlack = YES;
//            NSLog(@"打印字典---%@",_dicData);
            [self.httpUtil getDataFromAPIWithOps:AUTHENTICATE postParam:_dicData files:fileDic type:0 delegate:self sel:@selector(requestSetIdentifyType:)];

        }
    }
#pragma mark -投机机构身份验证界面  ||  智囊团身份验证界面
    if ([self.identifyType integerValue] == 3 || [self.identifyType integerValue] == 4) {
        Renzheng3ViewController * regist = [Renzheng3ViewController new];
        regist.identifyType = self.identifyType;
        regist.dicData = [NSMutableDictionary dictionaryWithDictionary:self.dicData];
        
        [self.navigationController pushViewController:regist animated:YES];
    }
}
-(void)addBlackView
{
    _loadingBlackView = [[LoadingBlackView alloc]initWithFrame:self.loadingViewFrame];
    [self.view addSubview:_loadingBlackView];
    
}
-(void)closeBlackView
{
    [_loadingBlackView removeFromSuperview];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LoadingBlackView class]]) {
            [view removeFromSuperview];
        }
    }
    //        NSLog(@"yichu");
}

#pragma mark -项目方注册身份方法
//注册身份
-(void)requestSetIdentifyType:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        
        if ([status integerValue] == 200) {
            [self closeBlackView];
            self.startLoading = NO;

            //进入应用
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            JTabBarController * tabBarController = [[JTabBarController alloc]init];
            tabBarController.delegate = delegate;
            delegate.tabBar = tabBarController;
//            delegate.nav = [[UINavigationController alloc]initWithRootViewController:delegate.tabBar];
            delegate.window.rootViewController = delegate.tabBar;
            
        }else{
            [self closeBlackView];
            self.startLoading = NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    [self closeBlackView];
    self.startLoading = NO;
}

#pragma mark -选择照片事件
- (IBAction)selectImageBtn:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    __block Renzheng2ViewController* blockSelf = self;
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
#pragma mark -从相册选择照片
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
#pragma mark -拍照选择照片
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
    
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.imageBtn setTitle:@"重新获取照片" forState:UIControlStateNormal];
    [self.imageBtn setImage:[UIImage new] forState:UIControlStateNormal];
    
    //压缩图片
    image = [TDUtil drawInRectImage:image size:CGSizeMake(1128, 800)];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.8);
    image = [UIImage imageWithData:imageData];
    
        //保存图片
        BOOL ret = [TDUtil saveContent:image fileName:@"buinessLicence"];
        if (ret) {
//            NSLog(@"身份证正面保存成功");
            _isSelectedImage = YES;
        }else{
//            NSLog(@"身份证正面保存失败");
        }
    
}
#pragma mark -结束代理方法
//点击cancle
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
@end
