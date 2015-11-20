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
        
    }
    
    return self;
}

-(void)setup {
    
    self.layer.masksToBounds = true;
    
    imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0,
                                 self.frame.size.width,
                                 self.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:imageView];
    
}

-(void)setImageFromURL:(NSURL *)url block:(void (^)(NSError *))block {
    
    [PlickersAPI getImageFromURL:url block:^(UIImage *image, NSError *error) {
       
        if (error) {
            block(error);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            block(nil);
        });
        
    }];
    
}

@end
