//
//  ResizeImageView.h
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResizeImageView : UIView {
    
}

-(void)setup;
-(void)setImageFromURL:(NSURL *)url block:(void (^)(NSError *))block;

@end
