//
//  CardView.m
//  PlickersApp
//
//  Created by Evan on 11/19/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "CardView.h"
#import "ResizeImageView.h"
#import "ChoicesView.h"

@interface CardView () {
    
    float DEVICE_WIDTH;
    float DEVICE_HEIGHT;
    
    BOOL isAnimating;
    BOOL isFlipped;
    
    UIView *shadowView;
    ResizeImageView *resizeImageView;
    UITextView *questionTextView;
    ChoicesView *choicesView;
    
}

@end

@implementation CardView

-(id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)setup {
    
    DEVICE_WIDTH = [[UIScreen mainScreen]bounds].size.width;
    DEVICE_HEIGHT = [[UIScreen mainScreen]bounds].size.height;
    
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    shadowView = [[UIView alloc]init];
    shadowView.frame = CGRectMake(0, 0,
                                  self.frame.size.width,
                                  self.frame.size.height);
    shadowView.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:0.1];
    
    resizeImageView = [[ResizeImageView alloc]init];
    resizeImageView.frame = CGRectMake(10, 10,
                                       self.frame.size.width - 20,
                                       self.frame.size.height - 100);
    
    questionTextView = [[UITextView alloc]initWithFrame:CGRectMake(10,
                                                                    resizeImageView.frame.origin.y + resizeImageView.frame.size.height + 10,
                                                                    self.frame.size.width - 20,
                                                                    self.frame.size.height - resizeImageView.frame.size.height - 10 - 10)];
    
    choicesView = [[ChoicesView alloc]initWithFrame:CGRectMake(10,
                                                               10,
                                                               self.frame.size.width - 20,
                                                               self.frame.size.height - 20)];
    
    NSURL *url = [NSURL URLWithString:[[self.dataSource valueForKey:@"question"]valueForKey:@"image"]];
    [resizeImageView setImageFromURL:url block:^ (NSError *error) {
        
    }];
    
    questionTextView.textAlignment = NSTextAlignmentCenter;
    questionTextView.userInteractionEnabled = false;
    questionTextView.text = [[self.dataSource valueForKey:@"question"]valueForKey:@"body"];
    
    choicesView.choices = [[self.dataSource valueForKey:@"question"]valueForKey:@"choices"];
    choicesView.responses = [self.dataSource valueForKey:@"responses"];
    [choicesView setup];
    
    [self addSubview:resizeImageView];
    [self addSubview:questionTextView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (isAnimating) {
        return;
    }
    
    [self addSubview:shadowView];
    self.layer.transform = CATransform3DMakeTranslation(2, 2, 0);
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (isAnimating) {
        return;
    }
    
    [shadowView removeFromSuperview];
    self.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
    
    isAnimating = true;
    
    if (!isFlipped) {
        [UIView animateWithDuration:0.25 animations:^ {
            self.layer.transform = CATransform3DMakeRotation(1.57, 0, 1, 0);
        }completion:^ (BOOL finished) {
            [resizeImageView removeFromSuperview];
            [questionTextView removeFromSuperview];
            [self addSubview:choicesView];
            [UIView animateWithDuration:0.25 animations:^ {
                self.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
            }completion:^ (BOOL finished) {
                isAnimating = false;
                isFlipped = true;
            }];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^ {
            self.layer.transform = CATransform3DMakeRotation(1.57, 0, 1, 0);
        }completion:^ (BOOL finished) {
            [choicesView removeFromSuperview];
            [self addSubview:resizeImageView];
            [self addSubview:questionTextView];
            [UIView animateWithDuration:0.25 animations:^ {
                self.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
            }completion:^ (BOOL finished) {
                isAnimating = false;
                isFlipped = false;
            }];
        }];
    }
    
}

@end
