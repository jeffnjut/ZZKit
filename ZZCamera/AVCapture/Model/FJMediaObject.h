//
//  FJMediaObject.h
//  FJCamera
//
//  Created by Fu Jie on 2018/11/21.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FJMediaObject : NSObject

@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData  *imageData;
@property (nonatomic, strong) NSURL   *imageURL;
@property (nonatomic, strong) NSURL   *videoURL;

@end
