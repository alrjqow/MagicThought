//
//  MTTakePhotoPreseter.m
//  8kqw
//
//  Created by 王奕聪 on 2016/12/21.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTTakePhotoPreseter.h"
#import "MTTakePhotoPreseterModel.h"
#import "MTPhotoPreviewViewCellModel.h"
#import "MTPhotoPreviewViewModel.h"

#import "UIImage+Size.h"
#import "UIImage+Cut.h"

#import "MTBaseAlertController.h"

#import "MTConst.h"

//#import "MTVideoController.h"
#import "MTDelegateProtocol.h"


#import "MBProgressHUD.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


/*此处有依赖*/
#import "TZImagePickerController.h"
#import "TZImageManager.h"

/*此处有依赖*/
@interface MTTakePhotoPreseter ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate, MTDelegateProtocol>

@property(nonatomic,weak) UIViewController* vc;


@end


@implementation MTTakePhotoPreseter


+(instancetype)preseter {    
    static MTTakePhotoPreseter *singleton = nil;
    if (! singleton)
    {
        singleton = [super manager];
        singleton.vc = mt_rootViewController();           
    }
    return singleton;
}



#pragma mark - 展示
-(void)show
{
    if(self.model.onlyCamera)
    {
        [self takePhotoFromCamera];
        return;
    }
    
    if(self.model.allowCameraIn)
        [self pushImagePickerController];
    else if(self.model.alertController)
            [self.model.alertController alert];
    else
        [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil] showInView:self.vc.view];
}

#pragma mark - 拍照
-(void)takePhotoFromCamera
{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        [[[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] infoDictionary][@"CFBundleName"] message:@"您没有访问相机的权限,请去设置中开启." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"去开启", nil] show] ;
        [self.model.alertController dismissViewControllerAnimated:false completion:nil];
        return;
    }
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        [self.model.alertController dismissViewControllerAnimated:false completion:nil];
        return;
    }
    if(MTDidReceiveMemoryWarning)
    {
        [[[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] infoDictionary][@"CFBundleName"] message:@"当前内存不足，无法调起相机拍照" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil] show] ;
        return;
    }
    
//    MTVideoController* imagePicker = [MTVideoController new];
//    imagePicker.delegate = self;
//    imagePicker.imageWidth = 720;
//    imagePicker.maxImagesCount = self.model.maxCount;
    //这里先调用临时变量，而不调用持续占有的成员变量
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if(iOS8Later) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    if(self.model.alertController)
        [self.model.alertController presentViewController:imagePicker animated:YES completion:nil];
    else
        [self.vc presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 去相册
- (void)pushImagePickerController
{
    /*此处有依赖*/
    /**/
    [[TZImageManager manager].assetIdentifierDict removeAllObjects];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.model.maxCount columnNumber:self.model.columnNumber delegate:self pushPhotoPickerVc:YES];
    //    imagePickerVc.allowPickingImage = false;
    imagePickerVc.allowTakeVideo = false;
    imagePickerVc.allowTakePicture = self.model.allowCameraIn ? self.model.onlyCamera : false;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    
    __weak typeof (self) weakSelf = self;
    imagePickerVc.photoWidth = 720;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
//         NSLog(@"%@",NSStringFromCGSize(photos.firstObject.size));
         [weakSelf afterGetPhoto:photos];
     }];
    
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        
        if([weakSelf.model respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
            [weakSelf.model doSomeThingForMe:self withOrder:@"MTImagePickerControllerDidCancelOrder"];
        [weakSelf.model.alertController dismissViewControllerAnimated:false completion:nil];
    }];
    
    if([self.model respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.model doSomeThingForMe:self withOrder:@"MTBeforePushImagePickerControllerOrder"];
    
    if(self.model.alertController)
        [self.model.alertController presentViewController:imagePickerVc animated:YES completion:nil];
    else
        [self.vc presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)addCellModelFromImages:(NSArray<UIImage *> *)photos
{
    if(![self.model isKindOfClass:[MTPhotoPreviewViewModel class]])
        return;
    
    MTPhotoPreviewViewModel* model = (MTPhotoPreviewViewModel*)self.model;
    [model addCellModelFromImages:photos];    
}

#pragma mark - 获取到照片后
-(void)afterGetPhoto:(NSArray<UIImage*>*)photos
{
    [self addCellModelFromImages:photos];
    if(self.model.completion)self.model.completion();
    self.model.completion = nil;
    [self.model.alertController dismissViewControllerAnimated:false completion:nil];
}


#pragma mark - 代理

-(void)doSomeThingForMe:(id)obj withOrder:(NSString *)order withItem:(id)item
{
    if([order isEqualToString:@"MTVideoControllerDidFinishPickingImagesOrder"])
    {
//        NSLog(@"%@",NSStringFromCGSize(photos.firstObject.size));
        [self afterGetPhoto:(NSArray<UIImage*>*)item];
    }
}

-(void)doSomeThingForMe:(id)obj withOrder:(NSString *)order
{
    if([order isEqualToString:MTGetPhotoFromAlbumOrder])
        [self pushImagePickerController];
    else if([order isEqualToString:MTGetPhotoFromCameraOrder])
        [self takePhotoFromCamera];
    else if([self.model.alertController.modalController respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.model.alertController.modalController doSomeThingForMe:self.model withOrder:order];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)  // take photo / 去拍照
        [self takePhotoFromCamera];
    else if (buttonIndex == 1)
        [self pushImagePickerController];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
         UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self afterGetPhoto:@[image]];
//        [self saveImage:image];
    }
    
    
    return;
}

#pragma mark - 拍照之后的操作
//1.保存图片
-(void)saveImage:(UIImage*)image
{
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tzImagePickerVc showProgressHUD];
    });
    
    
    //这个才是奔溃的关键
    // save photo and get asset / 保存图片，获取到asset
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [tzImagePickerVc hideProgressHUD];
        });
        if (error)
            NSLog(@"图片保存失败 %@",error);
         else
            [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
    }];
}

//2.使用图片
- (void)useImage:(UIImage *)image
{
    UIImage* img = [image changeSizeAccordingToWidth:720];
    
        __weak __typeof(self) weakSelf = self;
    if(self.model.completion)
    {
        [weakSelf addCellModelFromImages:@[img]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.model.completion();
            weakSelf.model.completion = nil;
        });
    }
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        image = [image fixOrientation];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    return image;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
     隐私->照片界面
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
     
     隐私->相机界面
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
     */
    
    switch (buttonIndex)
    {
        case 1:
        {
            NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
//            if([UIDevice currentDevice].systemVersion.floatValue >= 10)
//                url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            else
//                url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            
            if([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
            
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 懒加载

-(void)setModel:(MTTakePhotoPreseterModel *)model
{
    _model = model;
    
    model.alertController.mt_delegate = self;
}

@end




