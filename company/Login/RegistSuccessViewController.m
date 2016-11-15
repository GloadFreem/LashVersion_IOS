//
//  RegistSuccessViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/5.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "RegistSuccessViewController.h"
#import "RenzhengViewController.h"

#import "PhoneCerityViewController.h"
@interface RegistSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shiyongBtn;//完成注册，试用Btn
@property (weak, nonatomic) IBOutlet UILabel *ringLabel;//指环码label

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;

@end

@implementation RegistSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    
}

-(void)createUI{
    
    for (UIButton * btn in _btnArray) {
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
    }
//    _shiyongBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
//    _shiyongBtn.layer.borderWidth = 1;
    
    self.ringLabel.text = self.inviteCode;
//    NSLog(@"指环码%@",self.inviteCode);
}
- (IBAction)clickBtn:(UIButton*)sender {
    if (sender.tag == 1) {
        if ([self.wxIcon containsString:@"http"]) {
            PhoneCerityViewController *cerity = [PhoneCerityViewController new];
            cerity.identifyType = self.identify;
            [self.navigationController pushViewController:cerity animated:YES];
        }else{
        RenzhengViewController  * renzheng = [RenzhengViewController new];
        renzheng.identifyType = self.identify;
        [self.navigationController pushViewController:renzheng animated:YES];
        }
    }

    
}

- (IBAction)probationBtn:(UIButton *)sender {
    
    //进入应用
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    JTabBarController * tabBarController = [[JTabBarController alloc]init];
    tabBarController.delegate = delegate;
    delegate.tabBar = tabBarController;
//    delegate.nav = [[UINavigationController alloc]initWithRootViewController:delegate.tabBar];
    delegate.window.rootViewController = delegate.tabBar;
    
}

@end
