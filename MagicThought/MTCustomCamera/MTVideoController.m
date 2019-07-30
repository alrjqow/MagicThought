//
//  MTVideoController.m
//  photographDemo
//
//  Created by 王奕聪 on 2017/11/10.
//  Copyright © 2017年 Renford. All rights reserved.
//

#import "MTVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"

#import "MTDelegateProtocol.h"
#import "MTConst.h"
#import "MTVideoView.h"
#import "MTCountingView.h"
#import "MTDeviceManager.h"
#import "UIImage+Size.h"
#import "UIView+MBHud.h"
#import "UIImage+Cut.h"

@interface MTVideoController ()<CAAnimationDelegate, UIAlertViewDelegate, AVCaptureFileOutputRecordingDelegate>

//需要硬件设备、一个输入、一个输出、一个连接会话

@property(nonatomic,strong) AVCaptureDevice* device;

@property(nonatomic,strong) AVCaptureDeviceInput* input;

@property(nonatomic,strong) AVCaptureDeviceInput* audioInput;

@property(nonatomic,strong) AVCaptureStillImageOutput* imageOutput;

@property (nonatomic,strong) AVCaptureMovieFileOutput* movieOutput;

@property(nonatomic,strong) AVCaptureSession* session;

@property(nonatomic,strong) AVCaptureSession* movieSession;

//需要一个图像预览层
@property(nonatomic,strong) AVCaptureVideoPreviewLayer* layer;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer* movieLayer;


//转换摄像头
@property(nonatomic,strong) UIButton *changeCameraBtn;

// 背景
@property (nonatomic,strong) UIImageView *bgView;

/**视频播放层*/
@property (nonatomic,strong) MTVideoView* videoView;

//显示拍出来的图片
@property(nonatomic,strong) UIImageView* imageView;

//拍照按钮
@property(nonatomic,strong) UIButton* photoBtn;
@property(nonatomic,strong) UIImageView* photoImageView;

//读秒器
@property (nonatomic,strong) MTCountingView* countView;


//确定按钮
@property(nonatomic,strong) UIButton* okBtn;

//重拍或取消按钮
@property(nonatomic,strong) UIButton* cancelBtn;

//闪光灯按钮
@property(nonatomic,strong) UIButton* flashBtn;

//退出按钮
@property(nonatomic,strong) UIButton* closeBtn;

//聚焦视图
@property(nonatomic,strong) UIView* focusView;

//拍过保存的所有图片
@property(nonatomic,strong) NSMutableArray<UIImage*>* photoArr;


//最大缩放值
@property(nonatomic,assign) CGFloat maxZoomFactor;

//最小缩放值
@property(nonatomic,assign) CGFloat minZoomFactor;

//当前缩放值
@property(nonatomic,assign) CGFloat currentZoomFactor;

/**录像时长*/
@property (nonatomic,assign) CGFloat currentRecordSeconds;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (nonatomic,assign) BOOL isFinish;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

@end

@implementation MTVideoController

-(void)setIsFinish:(BOOL)isFinish
{
    _isFinish = isFinish;
    
    if(!isFinish)
    {
        self.videoView.hidden = YES;
        self.imageView.hidden = YES;
    }
    else
    {
        self.videoView.hidden = !self.isVideo;
        self.imageView.hidden = self.isVideo;
    }
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
        
        UIPinchGestureRecognizer *zoomGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomGesture:)];
        
        [_bgView addGestureRecognizer:tapGesture];
        [_bgView addGestureRecognizer:zoomGesture];
    }
    return _bgView;
}

-(NSMutableArray<UIImage *> *)photoArr
{
    if(!_photoArr)
    {
        _photoArr = [NSMutableArray array];
    }
    
    return _photoArr;
}

-(UIView *)focusView
{
    if(!_focusView)
    {
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor =[UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.hidden = YES;
    }
    
    return _focusView;
}

-(UIButton *)closeBtn
{
    
    if(!_closeBtn)
    {
        UIButton* closeBtn = [UIButton new];
        [closeBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/backDown"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(tapCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _closeBtn = closeBtn;
    }
    
    return _closeBtn;
}


-(UIButton *)flashBtn
{
    if(!_flashBtn)
    {
        UIButton* flashBtn = [UIButton new];
        [flashBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/flashing_off"] forState:UIControlStateNormal];
//        [flashBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/flashing_auto"] forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(tapFlashButton) forControlEvents:UIControlEventTouchUpInside];
        flashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _flashBtn = flashBtn;
    }
    
    return _flashBtn;
}

-(UIButton *)cancelBtn
{
    if(!_cancelBtn)
    {
        UIButton* cancelBtn = [UIButton new];
        [cancelBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/photographBack"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(restartCamera) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = cancelBtn;
    }
    
    return _cancelBtn;
}

-(UIButton *)okBtn
{
    if(!_okBtn)
    {
        UIButton* okBtn = [UIButton new];
        [okBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/photographConfrim"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        
        _okBtn = okBtn;
    }
    
    return _okBtn;
}

-(UIButton *)photoBtn
{
    if(!_photoBtn)
    {
        UIButton* photoBtn = [UIButton new];
        [photoBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/photograph"] forState: UIControlStateNormal];
        [photoBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/photograph_Select"] forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
        
        _photoBtn = photoBtn;
    }
    
    return _photoBtn;
}

-(UIImageView *)photoImageView
{
    if(!_photoImageView)
    {
        UIImageView* photoImageView = [UIImageView new];
        photoImageView.image = [UIImage imageNamed:@"MTVideoController.bundle/photograph"];
        photoImageView.userInteractionEnabled = YES;
        
        _photoImageView = photoImageView;
    }
    
    return _photoImageView;
}

-(MTCountingView *)countView
{
    if(!_countView)
    {
        MTCountingView* countView = [MTCountingView new];
        countView.translatesAutoresizingMaskIntoConstraints = false;
        countView.defaultColor = hex(0x2976f4);
        countView.mt_delegate = self;
        countView.totalTime = self.recordSeconds - 1;
        countView.ringCenterBackgroundColor = [UIColor clearColor];
        countView.ringThickness = 7;
//        countView.isAnimate = false;
        
        _countView = countView;
    }
    
    return _countView;
}

-(UIButton *)changeCameraBtn
{
    if(!_changeCameraBtn)
    {
        UIButton *changeCameraBtn = [UIButton new];
        [changeCameraBtn setImage:[UIImage imageNamed:@"MTVideoController.bundle/switchover"] forState:UIControlStateNormal];
        [changeCameraBtn addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
        changeCameraBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _changeCameraBtn = changeCameraBtn;
    }
    
    return _changeCameraBtn;
}

-(AVCaptureDevice *)device
{
    if(!_device)
    {
        //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if(![_device lockForConfiguration:nil]) return _device;
        
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto])
            [_device setFlashMode:AVCaptureFlashModeAuto];
        
        //自动白平衡
        if([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        
        //注意添加区域改变捕获通知必须首先设置设备允许捕获
        _device.subjectAreaChangeMonitoringEnabled = YES;
        
        [_device unlockForConfiguration];
                
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:_device];
    }
    
    return _device;
}

-(AVCaptureDeviceInput *)input
{
    if(!_input)
    {
        //使用设备初始化输入
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    }
    
    return _input;
}

-(AVCaptureDeviceInput *)audioInput
{
    if(!_audioInput)
    {
        //添加一个音频输入设备
        AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        _audioInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:nil];
    }
    
    return _audioInput;
}

-(AVCaptureStillImageOutput *)imageOutput
{
    if(!_imageOutput)
    {
        //生成输出对象
        _imageOutput = [AVCaptureStillImageOutput new];
    }
    
    return _imageOutput;
}

-(AVCaptureMovieFileOutput *)movieOutput
{
    if(!_movieOutput)
    {
        _movieOutput = [AVCaptureMovieFileOutput new];
    }
    
    return _movieOutput;
}

-(AVCaptureSession *)session
{
    if(!_session)
    {
        //生成会话，用来结合输入输出
        _session = [AVCaptureSession new];
        
        if([_session canSetSessionPreset: AVCaptureSessionPresetHigh])
            _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        if([_session canAddInput:self.input])
            [_session addInput:self.input];
        
        if([_session canAddOutput:self.imageOutput])
            [_session addOutput:self.imageOutput];
    }
    
    return  _session;
}

-(AVCaptureSession *)movieSession
{
    if(!_movieSession)
    {
        //生成会话，用来结合输入输出
        _movieSession = [AVCaptureSession new];
        
        if([_movieSession canSetSessionPreset: AVCaptureSessionPresetHigh])
            _movieSession.sessionPreset = AVCaptureSessionPresetHigh;
        
        if([_movieSession canAddInput:self.input])
        {
            [_movieSession addInput:self.input];
            [_movieSession addInput:self.audioInput];
            
            //设置视频防抖
            AVCaptureConnection *connection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported]) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
            }
        }
        
        
        if([_movieSession canAddOutput:self.movieOutput])
            [_movieSession addOutput:self.movieOutput];
    }
    
    return _movieSession;
}

-(AVCaptureVideoPreviewLayer *)layer
{
    if(!_layer)
    {
        _layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _layer.frame = [UIScreen mainScreen].bounds;
        _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _layer;
}


-(AVCaptureVideoPreviewLayer *)movieLayer
{
    if(!_movieLayer)
    {
        _movieLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.movieSession];
        _movieLayer.frame = [UIScreen mainScreen].bounds;
        _movieLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _movieLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOpenVideo = YES;
    self.recordSeconds = self.recordSeconds < 1 ? 12 : self.recordSeconds;
    self.view.mt_hudStyle = MBHudStyleBlack;
    [self setupZoomFactor];
    
    self.maxImagesCount = self.maxImagesCount ? self.maxImagesCount : 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view.layer addSublayer:self.movieLayer];
    [self.movieSession startRunning];
    
//    [self.view.layer addSublayer:self.layer];
//    [self.session startRunning];
    [self setupUI];
}
//{1080, 1920}
//{720, 1280}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - 设置缩放

-(void)setupZoomFactor
{
    CGFloat maxZoomFactor = self.device.activeFormat.videoMaxZoomFactor;
    if (@available(iOS 11.0, *)) {
        maxZoomFactor = self.device.maxAvailableVideoZoomFactor;
    }
    
    if (maxZoomFactor > 6.0) {
        maxZoomFactor = 6.0;
    }
    
    self.maxZoomFactor = maxZoomFactor;
    
    self.minZoomFactor = 1;
    self.currentZoomFactor = self.minZoomFactor;
}

#pragma mark - 设置UI
-(void)setupUI
{
    self.videoView = [[MTVideoView alloc] initWithFrame:self.view.bounds];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.focusView];
    [self.view addSubview:self.flashBtn];
    [self.view addSubview:self.changeCameraBtn];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.countView];
    [self.view addSubview:self.photoImageView];
//    [self.view addSubview:self.photoBtn];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.okBtn];
    [self.view addSubview:self.cancelBtn];
    
    self.isFinish = false;
    [self hideOkBtn:YES];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@60);
        make.width.equalTo(@150);
        make.top.equalTo(self.view).with.offset(16);
        make.left.equalTo(self.view).with.offset(14);
    }];
    
    [self.changeCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.equalTo(@60);
        make.top.equalTo(self.view).with.offset(16);
        make.right.equalTo(self.view).with.offset(-14);
    }];
    
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(70);
        make.width.and.height.equalTo(@80);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view).with.offset(-70);
        make.width.and.height.equalTo(@80);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];
    
//    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(self.view);
//
//        make.width.and.height.equalTo(@60);
//        make.bottom.equalTo(self.view).with.offset(-50);
//    }];
//
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.and.height.equalTo(@60);
//        make.centerY.equalTo(self.photoBtn);
//        make.left.equalTo(self.view).with.offset(10);
//    }];

    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.view);

        make.width.and.height.equalTo(@60);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.and.height.equalTo(@60);
        make.centerY.equalTo(self.photoImageView);
        make.left.equalTo(self.view).with.offset(10);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@70);
        make.height.equalTo(@70);
        make.center.equalTo(self.photoImageView);
    }];
}

#pragma mark - 点击事件

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([[touches anyObject] view] == self.photoImageView) {
        
            __weak __typeof(self) weakSelf = self;
        [MTDeviceManager getOrientationWithHandler:^BOOL(UIDeviceOrientation deviceOrientation) {
            
            NSLog(@"点击了拍照按钮");
            //根据设备输出获得连接
            AVCaptureConnection *connection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
            //        connection.videoOrientation = self.movieLayer.connection.videoOrientation;
            
            //预览图层和视频方向保持一致
            if ([connection isVideoOrientationSupported])
                connection.videoOrientation = [self getCaptureVideoOrientation: deviceOrientation];
            
            
            NSURL *fileUrl=[NSURL fileURLWithPath:[NSTemporaryDirectory()
                                                   stringByAppendingPathComponent:@"myMovie.mov"]];
            NSLog(@"fileUrl:%@",fileUrl);
            
            [weakSelf.movieOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:weakSelf];
            
            return YES;
        }];
    }
}

- (AVCaptureVideoOrientation)getCaptureVideoOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result;
    
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    NSLog(@"%zd",deviceOrientation);
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown，则视频方向和拍摄时的方向是相反的。
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            result = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return result;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([[touches anyObject] view] == self.photoImageView) {
        NSLog(@"结束触摸");
        [self endRecord];
    }
}

- (void)endRecord {
//    [self.movieSession stopRunning];
    [self.movieOutput stopRecording];//停止录制
}

#pragma mark - 是否显示或隐藏确定按钮
-(void)hideOkBtn:(BOOL)isHidden
{
    self.okBtn.hidden = isHidden;
    self.cancelBtn.hidden = isHidden;
    
    self.countView.hidden = !isHidden;
    self.countView.currentTime = 0;
    self.photoImageView.hidden = !isHidden;
    self.photoBtn.hidden = !isHidden;
    self.photoBtn.selected = !isHidden;
    self.changeCameraBtn.hidden = !isHidden;
    self.flashBtn.hidden = !isHidden;
    self.closeBtn.hidden = !isHidden;
}


#pragma mark - 捏合聚焦
//缩放手势
- (void)zoomGesture:(UIPinchGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGFloat currentZoomFactor = self.currentZoomFactor * gesture.scale;
            
            if(currentZoomFactor > self.maxZoomFactor)
                currentZoomFactor = self.maxZoomFactor;
            
            if(currentZoomFactor < self.minZoomFactor)
                currentZoomFactor = self.minZoomFactor;
            
            
                NSError *error = nil;
                if ([self.device lockForConfiguration:&error] ) {
                    self.device.videoZoomFactor = currentZoomFactor;
                    [self.device unlockForConfiguration];
                }
                else {
                    NSLog( @"Could not lock device for configuration: %@", error );
                }
            
            break;
        }
            
        default:
            self.currentZoomFactor = self.device.videoZoomFactor;
            break;
    }
}

#pragma mark - 触摸聚焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    if(self.photoImageView.hidden) return;
    if(self.photoBtn.hidden) return;
    
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y / size.height, 1 - point.x / size.width);
    NSError *error;
    if (![self.device lockForConfiguration:&error]) return;
    
    if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.device setFocusPointOfInterest:focusPoint];
        [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    
    if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
        [self.device setExposurePointOfInterest:focusPoint];
        [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    
    [self.device unlockForConfiguration];
    
    
    _focusView.center = point;
    _focusView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
    }];
}

#pragma mark - 捕获区域发生改变
- (void)captureAreaDidChange:(NSNotification *)notification
{
//    NSLog(@"subjectAreaDidChange");
    [self focusAtPoint:self.view.center];
}
-(void)setFocusCursorWithPoint:(CGPoint)point{
    //下面是手触碰屏幕后对焦的效果
    _focusView.center = point;
    _focusView.hidden = NO;
    
        __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            weakSelf.focusView.hidden = YES;
        }];
    }];
    
}


#pragma mark - 点击闪光灯按钮切换闪光灯模式
-(void)tapFlashButton
{
    [self.flashBtn setImage:[UIImage imageNamed:[MTDeviceManager openOrCloseFlash] ? @"MTVideoController.bundle/flashing_on" : @"MTVideoController.bundle/flashing_off"] forState:UIControlStateNormal];
    return;
    
//    if(![_device lockForConfiguration:nil]) return;
//
//    AVCaptureFlashMode flasfMode = (self.device.flashMode + 1) % 3;
//
//    if([self.device isFlashModeSupported:flasfMode])
//    {
//        [self.device setFlashMode:flasfMode];
//
//        [self.flashBtn setImage:[UIImage imageNamed:flasfMode == 0 ? @"MTVideoController.bundle/flashing_off" : (flasfMode == 1 ? @"MTVideoController.bundle/flashing_on" : @"MTVideoController.bundle/flashing_auto")] forState:UIControlStateNormal];
//    }
//
//    [self.device unlockForConfiguration];
}


#pragma mark - 切换前后摄像头
- (void)changeCamera{
    
    if(!self.changeCameraBtn.enabled) return;
    self.changeCameraBtn.enabled = false;
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount <= 1) return;
    
    //转场动画
    CATransition *animation = [CATransition animation];
    animation.duration = .3f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
//    [self.layer addAnimation:animation forKey:@"animation"];
    [self.movieLayer addAnimation:animation forKey:@"animation"];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

#pragma mark - 点击拍照按钮拍照
- (void) shutterCamera
{
    if(self.photoBtn.selected) return;
    
    self.photoBtn.selected = YES;
    
    AVCaptureConnection * videoConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage* image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        
        self.imageView.image = image;
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
        
        [self hideOkBtn:false];
    }];
}

#pragma mark - 点击确定按钮后保存图片

- (void)confirmAction
{
    self.saveVideoUrl ? [self saveVideo] : [self savePhoto];
}

-(void)saveVideo
{
    [self.view showMsg:@"请稍候"];
        __weak __typeof(self) weakSelf = self;
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:self.saveVideoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"outputUrl:%@",weakSelf.saveVideoUrl);
  
//        if (weakSelf.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
//            [[UIApplication sharedApplication] endBackgroundTask:weakSelf.lastBackgroundTaskIdentifier];
//        }
        if (error) {
            [self.view showError:@"保存视频到相簿过程中发生错误"];
            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        } else {
            [self.view dismissIndicator];
            NSLog(@"成功保存视频到相簿.");
            [weakSelf restartCamera];
        }
    }];
}

-(void)savePhoto
{
    if(!self.imageView.image) return;
    if(self.okBtn.selected) return;
    
    self.okBtn.selected = YES;
    self.cancelBtn.selected = YES;
    
    [self.view showMsg:@"请稍候"];
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [self.view dismissIndicator];
    self.okBtn.selected = false;
    self.cancelBtn.selected = false;
    if(error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                        message:@"保存图片失败"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
        
        return;
    }
    
    [self alertView:[UIAlertView new] clickedButtonAtIndex:0];
}


#pragma mark - 按了确定或者取消按钮以后重启相机
-(void)restartCamera
{
    if(self.cancelBtn.selected) return;
    
    self.imageView.image = nil;
//    [self.session startRunning];
//    [self.movieSession startRunning];
    [self hideOkBtn:YES];
    self.isFinish = false;
    [self.videoView stopPlayer];
}

#pragma mark - 关闭照相机
-(void)tapCloseBtn
{
//    [self.session stopRunning];
    [self.movieSession stopRunning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if([self.delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
        {
            [self.delegate doSomeThingForMe:self withOrder:MTVideoControllerDidFinishPickingImagesOrder withItem:self.photoArr];
            [self.photoArr removeAllObjects];
        }
    }];
}

#pragma mark - 代理

-(void)animationDidStart:(CAAnimation *)anim
{
    NSError *error;
    AVCaptureDevice *newCamera;
    AVCaptureDeviceInput *newInput;
    AVCaptureDevicePosition position = [[_input device] position];  //获取当前设备所在手机的位置
    
    //获取新设备
    newCamera = [self cameraWithPosition:position == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront];
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error]; //创建新的输入流
    
    //重新配置会话
    if (newInput) {
        [self.movieSession beginConfiguration];
        [self.movieSession removeInput:_input];
        if ([self.movieSession canAddInput:newInput])
        {
            [self.movieSession addInput:newInput];
            self.input = newInput;
        } else
        {
            [self.movieSession addInput:self.input];
        }
        
        [self.movieSession commitConfiguration];
//    if (newInput) {
//        [self.session beginConfiguration];
//        [self.session removeInput:_input];
//        if ([self.session canAddInput:newInput])
//        {
//            [self.session addInput:newInput];
//            self.input = newInput;
//        } else
//        {
//            [self.session addInput:self.input];
//        }
//
//        [self.session commitConfiguration];
    
    } else if (error) {
        NSLog(@"toggle carema failed, error = %@", error);
    }
}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.changeCameraBtn.enabled = YES;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImage* image = self.imageView.image;
    if(self.imageWidth)
       image = [image changeSizeAccordingToWidth:self.imageWidth];
    [self.photoArr addObject:image];
    
    
    if(self.photoArr.count < self.maxImagesCount)
        [self restartCamera];
    else
        [self tapCloseBtn];
}



#pragma mark - AVCaptureFileOutputRecordingDelegate

-(void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections
{
    NSLog(@"开始录制...");
    self.isVideo = false;
    self.currentRecordSeconds = self.recordSeconds;
    self.countView.currentTime = 1;
    if(self.isOpenVideo)
        [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}

- (void)onStartTranscribe:(NSURL *)fileURL {
    
    if ([self.movieOutput isRecording]) {
        self.currentRecordSeconds--;
        self.countView.currentTime = self.recordSeconds - self.currentRecordSeconds;
        if (self.currentRecordSeconds > 0) {
            NSLog(@"%lf", self.currentRecordSeconds);
            
            self.isVideo = YES; // 长按时间超过TimeMax 表示是视频录制
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.movieOutput isRecording]) {
                [self.movieOutput stopRecording];
            }
        }
    }
}

-(void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error
{
    NSLog(@"视频录制完成.");
    
    if (self.isVideo) {
        self.saveVideoUrl = outputFileURL;
        self.videoView.videoUrl = outputFileURL;
    } else {
        //照片
        self.saveVideoUrl = nil;
        if(![self videoHandlePhoto:outputFileURL] )
            return;
    }
    
    [self hideOkBtn:false];
    self.isFinish = YES;
}

- (BOOL)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    
//    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
//    NSLog(@"%zd",duration);
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
        return false;
    }
    
    NSLog(@"%zd",image.imageOrientation);
    
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    
    [self imageResizeWithOrientation:UIDeviceOrientationPortrait Image:image];
//    [self imageResizeWithOrientation:duration Image:image];
    return YES;
}

- (void)imageResizeWithOrientation:(UIDeviceOrientation)duration Image:(UIImage*)image{
    
    NSLog(@"image size = %@",NSStringFromCGSize(image.size));
    if(duration != UIDeviceOrientationLandscapeLeft && duration != UIDeviceOrientationLandscapeRight)
    {
        self.imageView.image = image;
        return;
    }
    
    
    /**
     * UIImageOrientationUp,            // default orientation
     * UIImageOrientationDown,          // 180 deg rotation
     * UIImageOrientationLeft,          // 90 deg CCW
     * UIImageOrientationRight,         // 90 deg CW
     */
    
    UIImageOrientation orientation;
    switch (duration) {
        case UIDeviceOrientationLandscapeLeft:
            orientation = UIImageOrientationLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orientation = UIImageOrientationRight;
            break;
            
        default:
            orientation = UIImageOrientationUp;
            break;
    }
    
    
    CGFloat imageScale = image.scale;
    CGFloat imageWidth = image.size.width * imageScale;
    CGFloat imageHeight = image.size.height * imageScale;
    
    CGFloat scale = imageWidth / self.imageView.bounds.size.width;
    
    CGRect cropFrame = self.imageView.bounds;
    
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    
    CGFloat referenceWidth = self.imageView.bounds.size.width;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 宽高比不变，所以宽度高度的比例是一样
        CGFloat orgX = cropFrame.origin.x * scale;
        CGFloat orgY = cropFrame.origin.y * scale;
        CGFloat width = cropFrame.size.width * scale;
        CGFloat height = cropFrame.size.height * scale;
        CGRect cropRect = CGRectMake(orgX, orgY, width, height);
        
        if (orgX < 0) {
            cropRect.origin.x = 0;
            cropRect.size.width += -orgX;
        }
        
        if (orgY < 0) {
            cropRect.origin.y = 0;
            cropRect.size.height += -orgY;
        }
        
        CGFloat cropMaxX = CGRectGetMaxX(cropRect);
        if (cropMaxX > imageWidth) {
            CGFloat diffW = cropMaxX - imageWidth;
            cropRect.size.width -= diffW;
        }
        
        CGFloat cropMaxY = CGRectGetMaxY(cropRect);
        if (cropMaxY > imageHeight) {
            CGFloat diffH = cropMaxY - imageHeight;
            cropRect.size.height -= diffH;
        }
        
        
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
        
        UIImage *resizeImg = [UIImage imageWithCGImage:imgRef];
        resizeImg = [resizeImg fixOrientationWithOrientation:orientation];
        
        CGImageRelease(imgRef);
        
        // 有小数的情况下，边界会多出白线，需要把小数点去掉
        CGFloat cropScale = imageWidth / referenceWidth;
        CGSize cropSize = CGSizeMake(floor(resizeImg.size.width / cropScale), floor(resizeImg.size.height / cropScale));
        if (cropSize.width < 1) cropSize.width = 1;
        if (cropSize.height < 1) cropSize.height = 1;
        
        /**
         * 参考：http://www.jb51.net/article/81318.htm
         * 这里要注意一点CGContextDrawImage这个函数的坐标系和UIKIt的坐标系上下颠倒，需对坐标系处理如下：
         - 1.CGContextTranslateCTM(context, 0, cropSize.height);
         - 2.CGContextScaleCTM(context, 1, -1);
         */
        
        UIGraphicsBeginImageContextWithOptions(cropSize, 0, deviceScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, cropSize.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRectMake(0, 0, cropSize.width, cropSize.height), resizeImg.CGImage);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        resizeImg = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = newImage;
        });
    });
}


@end


