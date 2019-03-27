//
//  MTVideoView.m
//  DaYiProject
//
//  Created by monda on 2019/2/18.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface MTVideoView ()

@property (nonatomic,strong) AVPlayer *player;//播放器对象

@property (nonatomic,weak) AVPlayerLayer* playerLayer;

@end

@implementation MTVideoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        AVPlayerLayer* layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.frame = self.bounds;
        
        [self.layer addSublayer:layer];
        self.playerLayer = layer;
        
        self.backgroundColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopPlayer];
    self.player = nil;
}

- (AVPlayerItem *)getAVPlayerItem {
    
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.videoUrl];
    
    return playerItem;
}

- (void)playbackFinished:(NSNotification *)ntf {
    if(ntf.object != self.player.currentItem)
        return;
    
    NSLog(@"视频播放完成");
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

-(void)playNextItem
{
    [self.player seekToTime:CMTimeMakeWithSeconds(0, self.player.currentItem.duration.timescale)];
    [self.player replaceCurrentItemWithPlayerItem:[self getAVPlayerItem]];
    
    if(self.player.rate == 0)
       [self.player play];
}

- (void)stopPlayer {
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
}



#pragma mark - 生命周期

#pragma mark - 懒加载

-(void)setVideoUrl:(NSURL *)videoUrl
{
    _videoUrl = videoUrl;
    
    [self playNextItem];
}

-(AVPlayer *)player
{
    if(!_player)
    {
        _player = [AVPlayer playerWithPlayerItem:[self getAVPlayerItem]];
        
    }
    
    return _player;
}

@end
