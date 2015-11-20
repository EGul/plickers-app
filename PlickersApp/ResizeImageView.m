//
//  ResizeImageView.m
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "ResizeImageView.h"
#import "PlickersAPI.h"

@interface ResizeImageView () {
    
    UIImageView *imageView;
    
}

@end

@implementation ResizeImageView

-(id)init {
    
    if (self = [super init]) {
        
        self.layer.masksToBounds = true;
        
        imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0,
                                     self.frame.size.width,
                                     self.frame.size.height);
        
        [self addSubview:imageView];
        
    }
    
    return self;
}

-(void)setImageFromURL:(NSURL *)url block:(void (^)(NSError *))block {
    
    [PlickersAPI getImageFromURL:url block:^ (UIImage *image, NSError *error) {
        
        if (error) {
            block(error);
            return;
        }
        
        float differenceWidth = 0;
        float differenceHeight = 0;
        
        float difference = 0;
                
        float toWidth = self.frame.size.width;
        float toHeight = self.frame.size.height;
        
        if (image.size.width > self.frame.size.width) {
            differenceWidth = image.size.width - self.frame.size.width;
        }
        if (image.size.height > self.frame.size.height) {
            differenceHeight = image.size.height - self.frame.size.height;
        }
        
        if (differenceWidth > differenceHeight) {
            difference = differenceWidth;
            float percentage = self.frame.size.width / image.size.width;
            toWidth = image.size.width * percentage;
            toHeight = image.size.height * percentage;
        }
        
        if (differenceHeight > differenceWidth) {
            difference = differenceHeight;
            float percentage = self.frame.size.height / image.size.height;
            toWidth = image.size.width * percentage;
            toHeight = image.size.height * percentage;
        }
        
        imageView.frame = CGRectMake((self.frame.size.width / 2) - (toWidth / 2),
                                     (self.frame.size.height / 2) - (toHeight / 2),
                                     toWidth,
                                     toHeight);
        
        dispatch_async(dispatch_get_main_queue(), ^ () {
            imageView.image = image;
            block(nil);
        });
        
    }];
    
}

@end
