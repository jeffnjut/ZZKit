//
//  NSURL+PreviewImage.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/22.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "NSURL+PreviewImage.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation NSURL (PreviewImage)

- (UIImage *)previewImage {
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:self] ;
    player.shouldAutoplay = NO;
    UIImage *image = [player thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
    return image;
}

@end
