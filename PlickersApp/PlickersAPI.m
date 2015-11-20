//
//  PlickersAPI.m
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "PlickersAPI.h"

#define Plickers_URL @"https://plickers-interview.herokuapp.com/polls"

@interface PlickersAPI () {
    
}

@end

@implementation PlickersAPI

+(void)getJSON:(void (^)(NSArray *jsonArray, NSError *error))block {
    
    NSURL *url = [NSURL URLWithString:Plickers_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            block(nil, error);
            return;
        }
        
        NSError *jsonError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        block(jsonArray, nil);

    }];
    
    [dataTask resume];
    
}

+(void)getImageFromURL:(NSURL *)url block:(void (^)(UIImage *image, NSError *error))block {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
        
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            block(nil, error);
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        block(image, nil);
        
    }];
    
    [dataTask resume];
    
}

@end
