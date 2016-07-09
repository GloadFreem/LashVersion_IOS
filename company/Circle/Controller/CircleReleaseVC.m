//
//  CircleReleaseVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleReleaseVC.h"
#import "CircleViewController.h"
#import "MWPhotoBrowser.h"
#import "UIImage+Crop.h"
#import "PECropViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomImagePickerController.h"

#define textViewContent @"发布最新、最热、最前沿的投融资话题"
#define PUBLICFEEL @"requestPublicFeeling"
#define NUMBERFORTY 40
#define NUMBERTHIRTY 30
@interface CircleReleaseVC ()<UITextViewDelegate,MWPhotoBrowserDelegate,CustomImagePickerControllerDelegate>
{
    NSMutableArray *_selections;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) UIView *imgContentView;
@property (nonatomic, strong) NSMutableArray *imageSelectArray;
@property (nonatomic, strong) NSMutableArray *imgSelectAssetArray;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) MWPhotoBrowser *browser;
@property (nonatomic, assign) BOOL isSelectPic;

@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;
@property (nonatomic, strong) CircleViewController *controller;

@property (nonatomic, strong) CustomImagePickerController *customPicker;
@end

@implementation CircleReleaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    // Do any additional setup after loading the view.
    //取得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PUBLICFEEL];
    
    self.view.backgroundColor = colorGray;
    
    [self setupNav];
    
    [self createUI];
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.tag = 0;
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    
    UIButton *releaseBtn = [UIButton new];
    [releaseBtn setBackgroundImage:[UIImage imageNamed:@"icon_releaseBtn"] forState:UIControlStateNormal];
    
    releaseBtn.size = releaseBtn.currentBackgroundImage.size;
    [releaseBtn addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn];
    
    self.navigationItem.title = @"发布话题";
}

#pragma mark -初始化内容
-(void)createUI
{
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(230);
    }];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, SCREENWIDTH - 20, 200)];
    _textView.delegate = self;
    
    _textView.font = BGFont(15);
    _textView.textColor = color47;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.text = textViewContent;
    _textView.scrollEnabled = YES;
    
    [backView addSubview:_textView];
    
    _imgContentView = [[UIView alloc]initWithFrame:CGRectMake(_textView.frame.origin.x, 230 + 10 , _textView.frame.size.width, 80)];
    
    [self.view addSubview:_imgContentView];
    
    CGFloat width = (SCREENWIDTH - 50)/4;
    _btnSelect = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, width, width)];
    _btnSelect.backgroundColor = [UIColor whiteColor];
    
    [_btnSelect addTarget:self action:@selector(showSecureTextEntryAlert) forControlEvents:UIControlEventTouchUpInside];
    [_btnSelect setImage:[UIImage imageNamed:@"icon_releaseAdd"] forState:UIControlStateNormal];
    [_imgContentView addSubview:_btnSelect];

    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    _isSelectPic = NO;
    
    [self loadAssets];
}

#pragma mark -发布按钮 Action
-(BOOL)publishClick:(UIButton*)btn
{
    NSString *content = _textView.text;
    NSMutableArray *postArray = [NSMutableArray new];
    
        for (UIView *view in _imgContentView.subviews) {
            if ([view isKindOfClass:UIImageView.class]) {
                UIImage *image = ((UIImageView*)view).image;
                image = [image imageByCroppingSelf];
//                image = 
                [postArray addObject:image];
            }
        }
    
    
    if ([content isEqualToString:textViewContent] || [content isEqualToString:@""]) {
        if ((!postArray || postArray.count == 0)) {
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"发布内容不能为空"];
            return false;
        }
    }
    if ([content isEqualToString:textViewContent]) {
        content = @"";
    }
    //发布内容
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    [dataDic setValue:content forKey:@"content"];
    [dataDic setValue:postArray forKey:@"files"];
    
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        [self savePhoto:dataDic];
    });
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self performSelector:@selector(dissmissController) withObject:nil afterDelay:1];
    
    return true;
}
#pragma mark -保存照片
-(void)savePhoto:(NSDictionary*)dic
{
    NSMutableArray *uploadFiles = [NSMutableArray new];
    NSMutableArray *postArray = [dic valueForKey:@"files"];
    int i = 0;
    for (UIView *view in postArray) {
        UIImage *image = (UIImage*)view;
        //保存照片
        BOOL flag = [TDUtil saveContent:image fileName:[NSString stringWithFormat:@"file%d",i]];
        if (flag) {
            [uploadFiles addObject:[NSString stringWithFormat:@"file%d",i]];
            i++;
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"publish" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:uploadFiles,@"uploadFiles",[dic valueForKey:@"content" ],@"content", nil]];
    
//    [self publishPhotos:uploadFiles content:dic[@"content"]];
    
}

#pragma mark -发布内容
-(void)publishPhotos:(NSMutableArray*)filesArray content:(NSString*)content
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",content,@"content", nil];
    [self.httpUtil getDataFromAPIWithOps:CIRCLE_PUBLIC_FEELING postParam:dic files:filesArray postName:@"images" type:0 delegate:self sel:@selector(requestPublishContent:)];
}

-(void)requestPublishContent:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 200) {
//            [shareNewsView removeFromSuperview];
            
        }else{
//        self.startLoading = NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
        }
    }
}

#pragma mark -底部弹出选择器
- (void)showSecureTextEntryAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    __block CircleReleaseVC* blockSelf = self;
    // Create the actions.
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf takePhoto:nil];
    }];
    
    UIAlertAction *chooiceAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf btnSelect:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    // Add the actions.
    [alertController addAction:takePhotoAction];
    [alertController addAction:chooiceAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)btnSelect:(id)sender
{
    self.isSelectPic = YES;
    
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *thumbs = [NSMutableArray array];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    
    displayActionButton = NO;
    displaySelectionButtons = YES;
    startOnGrid = YES;
    enableGrid = YES;
    
    @synchronized(_assets) {
        NSMutableArray *copy = [_assets copy];
        if (NSClassFromString(@"PHAsset")) {
            // Photos library
            UIScreen *screen = [UIScreen mainScreen];
            CGFloat scale = screen.scale;
            // Sizing is very rough... more thought required in a real implementation
            CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
            CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
            CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
            for (PHAsset *asset in copy) {
                [photos addObject:[MWPhoto photoWithAsset:asset targetSize:imageTargetSize]];
                [thumbs addObject:[MWPhoto photoWithAsset:asset targetSize:thumbTargetSize]];
            }
        } else {
            // Assets library
            for (ALAsset *asset in copy) {
                MWPhoto *photo = [MWPhoto photoWithURL:asset.defaultRepresentation.url];
                [photos addObject:photo];
                MWPhoto *thumb = [MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]];
                [thumbs addObject:thumb];
                if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
                    photo.videoURL = asset.defaultRepresentation.url;
                    thumb.isVideo = true;
                }
            }
        }
    }

    _photos = photos;
    _thumbs = thumbs;
    
    if (!_browser) {
        _browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    }
    _browser.displayActionButton = displayActionButton;
    _browser.displayNavArrows = displayNavArrows;
    _browser.displaySelectionButtons = displaySelectionButtons;
    _browser.alwaysShowControls = displaySelectionButtons;
    _browser.zoomPhotosToFill = YES;
    _browser.maxSelected = 9;
    _browser.enableGrid = enableGrid;
    _browser.startOnGrid = startOnGrid;
    _browser.enableSwipeToDismiss = NO;
    _browser.autoPlayOnAppear = autoPlayOnAppear;
    [_browser setCurrentPhotoIndex:0];
    
    if (displaySelectionButtons) {
        if (!_selections) {
            _selections  = [NSMutableArray new];
            for (NSInteger i =0; i < photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.browser];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)back:(id)sender
{
    [self dissmissController];
}

-(void)getSelectImage:(NSArray*)imageArr
{
    _imageSelectArray = [NSMutableArray arrayWithArray:imageArr];
    //移除原有的视图
    for (UIView *view in _imgContentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *imageView;
    CGFloat pos_x = 0, pos_y = 10;
    CGFloat width = (SCREENWIDTH - 50)/4;
    if (_imageSelectArray.count > 0) {
        for (NSInteger i = 0; i < _imageSelectArray.count; i++) {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(pos_x, pos_y, width, width)];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)]];
            [_imgContentView addSubview:imageView];
            imageView.image = _imageSelectArray[i];
            
            pos_x += width + 10;
            if ((i+1)%4 == 0) {
                pos_x = 0;
                pos_y += width + 10;
            }
        }
        
        CGRect frame = _btnSelect.frame;
        [_btnSelect removeFromSuperview];
        if (_imageSelectArray.count < 9) {
            frame.origin.x = pos_x;
            frame.origin.y = pos_y;
            [_btnSelect setFrame:frame];
            [_imgContentView addSubview:_btnSelect];
        }
        
       
        [_imgContentView setFrame:CGRectMake(_imgContentView.frame.origin.x, _imgContentView.frame.origin.y, _imgContentView.frame.size.width, frame.size.height + frame.origin.y + 20)];
    }
    
}
#pragma mark -显示照片
-(void)showImage:(UITapGestureRecognizer*)sender
{
    UIImageView* imageView = (UIImageView*)(sender.view);
    self.isSelectPic = NO;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    
    displayActionButton = NO;
    displaySelectionButtons = YES;
    startOnGrid = YES;
    enableGrid = YES;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:imageView.tag];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark -MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (self.isSelectPic) {
        return _photos.count;
    }else{
        return _imageSelectArray.count;
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (self.isSelectPic) {
        if (index < _photos.count)
            return [_photos objectAtIndex:index];
        return nil;
    }else{
        return [self.imgSelectAssetArray objectAtIndex:index];
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    int count = 0;
    for (int i = 0; i < _selections.count; i++) {
        if ([_selections[i] boolValue]) {
            count ++;
        }
    }
    
    if (count<=self.browser.maxSelected) {
        if (count<self.browser.maxSelected) {
            photoBrowser.limit  =NO;
        }else{
            photoBrowser.limit  =YES;
        }
    }
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i < _selections.count; i++) {
        if ([_selections[i] boolValue]) {
            if (!self.imgSelectAssetArray) {
                self.imgSelectAssetArray = [NSMutableArray new];
            }
            [self.imgSelectAssetArray addObject:[_photos objectAtIndex:i]];
            UIImage* image;
            if (NSClassFromString(@"PHAsset")) {
                PHAsset* photo = [_assets objectAtIndex:i];
                
                // 在资源的集合中获取第一个集合，并获取其中的图片
                PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                [imageManager requestImageForAsset:photo
                                        targetSize:PHImageManagerMaximumSize
                                       contentMode:PHImageContentModeDefault
                                           options:nil
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         
                                         // 得到一张 UIImage，展示到界面上
                                         if (result) {
                                             [array addObject:result];
                                         }
                                         
                                         [self getSelectImage:array];
                                     }];
            }else{
                ALAsset* asset = _assets[i];
                image = [self fullResolutionImageFromALAsset:asset];
                [array addObject:image];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

#pragma mark - load Assets
-(void)loadAssets
{
    if (NSClassFromString(@"PHAsset")) {
        
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
        
    } else {
        
        // Assets library
        [self performLoadAssets];
        
    }
    
}
- (void)performLoadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
        });
        
    } else {
        
        // Assets Library iOS < 8
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Run in the background as it takes a while to get all assets from the library
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
            
            // Process assets
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url
                                          resultBlock:^(ALAsset *asset) {
                                              if (asset) {
                                                  @synchronized(_assets) {
                                                      [_assets addObject:asset];
                                                  }
                                              }
                                          }
                                         failureBlock:^(NSError *error){
                                             NSLog(@"operation was not successfull!");
                                         }];
                        
                    }
                }
            };
            
            // Process groups
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            // Process!
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:^(NSError *error) {
                                              NSLog(@"There is an error");
                                          }];
            
        });
        
    }
    
}

//照相功能
-(void)takePhoto:(NSDictionary*)dic
{
    [self showPicker];
}

-(void)showPicker
{
    CustomImagePickerController* picker = [[CustomImagePickerController alloc] init];
    
    //创建返回按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NUMBERFORTY, NUMBERTHIRTY)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [leftItem setStyle:UIBarButtonItemStylePlain];
    //创建设置按钮
    btn =  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NUMBERFORTY, NUMBERTHIRTY)];
    btn.tintColor = [UIColor whiteColor];
    btn.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    picker.navigationItem.leftBarButtonItem = leftItem;
    picker.navigationItem.rightBarButtonItem = rightItem;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [picker setCustomDelegate:self];
    self.customPicker=picker;
    
    [self presentViewController:self.customPicker animated:YES completion:nil];
    
//    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    [delegate.tabBar tabBarHidden:YES animated:NO];
}

- (void)cameraPhoto:(UIImage *)imageCamera  //选择完图片
{
    [self openEditor:imageCamera];
}

- (void)openEditor:(UIImage*)imageCamera
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = imageCamera;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    
    
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    MWPhoto* photo  = [MWPhoto photoWithImage:croppedImage];
    if (!self.imgSelectAssetArray) {
        self.imgSelectAssetArray = [[NSMutableArray alloc]init];
    }
    [self.imgSelectAssetArray addObject:photo];
    if (!self.imageSelectArray) {
        self.imageSelectArray = [[NSMutableArray alloc]init];
    }
    [self.imageSelectArray addObject:croppedImage];
    
    [self getSelectImage:self.imageSelectArray];
}


-(void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//取消照相
-(void)cancelCamera
{
    
}


//*********************************************************照相机功能结束*****************************************************//

#pragma mark -textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _textView.font= BGFont(18);
    if ([textView.text isEqualToString:textViewContent]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _textView.font = BGFont(15);
        _textView.text = textViewContent;
    }
    
}
#pragma mark -返回按钮
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark---
-(void)dissmissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -请求失败
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
}

@end
