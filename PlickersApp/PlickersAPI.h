//
//  PlickersAPI.h
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlickersAPI : NSObject {
    
}

+(void)getJSON:(void (^)(NSArray *jsonArray, NSError *error))block;
+(void)getImageFromURL:(NSURL *)url  block:(void (^)(UIImage *image, NSError *error))block;

@end
