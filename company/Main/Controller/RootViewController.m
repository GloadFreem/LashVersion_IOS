//
//  RootViewController.m
//  company
//
//  Created by Eugene on 16/6/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    LoadingView *loadingView;
    DataBaseHelper *_dataBase;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化网络请求对象
    self.httpUtil  =[[HttpUtils alloc]init];
    
    //数据库工具
    _dataBase = [DataBaseHelper sharedInstance];
}

/**
 *  网络请求错误
 *
 *  @param isNetRequestError 是否网络请求错误
 */
-(void)setIsNetRequestError:(BOOL)isNetRequestError
{
    
    self->_isNetRequestError = isNetRequestError;
    if (self.isNetRequestError) {
        if (!loadingView) {
            if (self.loadingViewFrame.size.height>0) {
                loadingView =[LoadingUtil shareInstance:self.view frame:self.loadingViewFrame];
            }else{
                loadingView = [LoadingUtil shareInstance:self.view];
            }
            loadingView.delegate  =self;
        }
        loadingView.isTransparent  = NO;
        loadingView.isError = YES;
    }else{
        [LoadingUtil close:loadingView];
        loadingView.isError = NO;
        loadingView.isTransparent  = YES;
    }
    
}
/**
 *  设置开始加载
 *
 *  @param startLoading 加载执行标致, true:开始加载动画 false:取消加载动画
 */
-(void)setStartLoading:(BOOL)startLoading
{
    
    self->_startLoading  = startLoading;
    if (self.startLoading) {
        if (!loadingView) {
            if (self.loadingViewFrame.size.height>0) {
                loadingView =[LoadingUtil shareInstance:self.view frame:self.loadingViewFrame];
            }else{
                loadingView = [LoadingUtil shareInstance:self.view];
            }
            loadingView.delegate  =self;
        }else{
            if (self.loadingViewFrame.size.height>0) {
                [loadingView setFrame:self.loadingViewFrame];
            }
        }
        
        self.isNetRequestError  =NO;
        loadingView.isTransparent  = NO;
        [LoadingUtil show:loadingView];
    }else{
        [LoadingUtil close:loadingView];
    }
    
}

/**
 *  设置全局视图是否透明
 *
 *  @param isTransparent 视图是否透明标志，true：透明显示，false：不透明
 */
-(void)setIsTransparent:(BOOL)isTransparent
{
    
    self->_isTransparent  =isTransparent;
    loadingView.isTransparent  =isTransparent;
    
}

/**
 *  设置加载视图内容大小
 *
 *  @param loadingViewFrame 视图内容大小
 */
-(void)setLoadingViewFrame:(CGRect)loadingViewFrame
{
    
    self->_loadingViewFrame =loadingViewFrame;
    
}

/**
 *  设置提示消息内容
 *
 *  @param content 消息内容信息
 */
-(void)setContent:(NSString *)content
{
    
    self->_content  =content;
    if ([TDUtil isValidString:self.content]) {
        loadingView.content  = self.content;
    }
    
}


/**
 *  设置数据字典
 *
 *  @param dataDic 数据字典
 */
-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    
    self->_dataDic = dataDic;
    if (self.dataDic) {
        int code = [[dataDic valueForKey:@"code"] intValue];
        //设置状态码
        [self setCode:code];
    }
    
}


/**
 *  重新加载，刷新
 */
-(void)refresh
{
    self.startLoading = YES;
}

/**
 *  重新设置加载视图内容大小
 */
-(void)resetLoadingView
{
    [self.view bringSubviewToFront:loadingView];
}

//==============================网络请求处理开始==============================//



-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);    
    self.isNetRequestError = YES;
}
//==============================网络请求处理结束==============================//


#pragma mark--------从数据库加载数据-------------
-(NSArray*)getDataFromBaseTable:(NSString*)tableName
{
    //    NSMutableString* data = [[NSMutableString alloc] init];
    NSArray *tableArr = [_dataBase queryWithTableName:tableName];
    if (tableArr.count) {
        NSDictionary* dict = tableArr[0];
//            for(NSString* key in dict.allKeys){
//                if ([key isEqualToString:@"data"]) {
//        //            [data appendFormat:@"%@: %@   ",key,dict[key]];
//        //            NSLog(@"打印字符串---%@",data);
//        //
//        //            NSLog(@"打印字典---%@",dic);
//        
//                }
//            }
        NSMutableDictionary *dic = [dict[@"data"] JSONValue];
        NSArray *dataArray =[NSArray arrayWithArray:dic[@"data"]];
        //    NSLog(@"打印数组---%@",dataArray);
        return dataArray;
    }
    return nil;
}
-(id)getOrgazinationDataFromBaseTable:(NSString*)tableName
{
    NSArray *tableArr = [_dataBase queryWithTableName:tableName];
    if (tableArr.count) {
        NSDictionary *dict = tableArr[0];
        NSMutableDictionary *dic = [dict[@"data"] JSONValue];
        return dic[@"data"];
    }
    return nil;
}
#pragma mark-------保存数据------
-(void)saveDataToBaseTable:(NSString*)tableName data:(NSDictionary*)dic
{
    BOOL rett = [_dataBase cleanTable:tableName];
    if (rett) {
//                NSLog(@"%@清理成功",tableName);
    }else{
        //        NSLog(@"%@清理失败",tableName);
    }
    BOOL ret = [_dataBase insertIntoTableName:tableName Dict:dic];
    if (ret) {
//                NSLog(@"%@插入成功",tableName);
    }else{
        //        NSLog(@"%@插入失败",tableName);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [MobClick beginLogPageView:self.navView.title];
    
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [MobClick endLogPageView:self.navView.title];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{

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
