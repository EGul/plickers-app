//
//  ChoicesView.m
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "ChoicesView.h"

@interface ChoicesView () {
    
}

-(NSString *)getRatio;
-(int)getCorrectAnswer;

@end

@implementation ChoicesView

-(id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)setup {
    
    int currentY = 0;
    int currentX = 0;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    NSDictionary *convertDictionary = @{
                                        @"0": @"A",
                                        @"1": @"B",
                                        @"2": @"C",
                                        @"3": @"D"
                                        };
    
    UILabel *percentLabel = [[UILabel alloc]init];
    percentLabel.frame = CGRectMake(0, 0, width, 25);
    percentLabel.text = [self getRatio];
    percentLabel.textColor = [UIColor redColor];

    if ([[[percentLabel.text componentsSeparatedByString:@"%"]objectAtIndex:0]intValue] > 50) {
        percentLabel.textColor = [UIColor greenColor];
    }
    
    [self addSubview:percentLabel];
    
    float tempHeight = height - percentLabel.frame.size.height;
    currentY = percentLabel.frame.size.height;
    
    for (int i = 0; i < self.choices.count; i++) {
        
        UILabel *choiceLabel = [[UILabel alloc]init];
        choiceLabel.frame = CGRectMake(currentX * (width / 2), currentY, width / 2, (tempHeight / 2) - 50);
        choiceLabel.textAlignment = NSTextAlignmentCenter;
        choiceLabel.numberOfLines = 2;
        choiceLabel.text = [[self.choices objectAtIndex:i]valueForKey:@"body"];
        
        UILabel *indexLabel = [[UILabel alloc]init];
        indexLabel.frame = CGRectMake(currentX * (width / 2),
                                      choiceLabel.frame.origin.y + choiceLabel.frame.size.height,
                                      width / 2, 50);
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.text = [convertDictionary valueForKey:[NSString stringWithFormat:@"%d", i]];
        indexLabel.textColor = [UIColor redColor];
        
        if ([[[self.choices objectAtIndex:i]valueForKey:@"correct"]boolValue] == true) {
            indexLabel.textColor = [UIColor greenColor];
        }
        
        [self addSubview:choiceLabel];
        [self addSubview:indexLabel];
        
        currentX++;
        if (currentX == 2) {
            currentX = 0;
            currentY += tempHeight / 2;
        }
        
    }
    
}

-(int)getCorrectAnswer {
    
    int correctAnswer = -1;
    
    for (int i = 0; i < self.choices.count; i++) {
        if ([[[self.choices objectAtIndex:i]valueForKey:@"correct"]boolValue] == true) {
            correctAnswer = i;
            break;
        }
    }
    
    return correctAnswer;
}


-(NSString *)getRatio {
    
    int total = 0;
    int correctAnswer = [self getCorrectAnswer];
    
    NSDictionary *convertDictionary = @{
                                        @"A": @(0),
                                        @"B": @(1),
                                        @"C": @(2),
                                        @"D": @(3),
                                        @"E": @(4),
                                        @"G": @(5),
                                        @"G": @(6),
                                        @"H": @(7)
                                        };
    
    for (int i = 0; i < self.responses.count; i++) {
        NSString *answer = [[self.responses objectAtIndex:i]valueForKey:@"answer"];
        if ([[convertDictionary valueForKey:answer]intValue] == correctAnswer) {
            total++;
        }
    }
    
    int percentage = (total / (float)self.responses.count) * 100;
    NSString *ratio = [NSString stringWithFormat:@"%d/%lu", total, self.responses.count];
    
    return [NSString stringWithFormat:@"%d%@ %@", percentage, @"%", ratio];
    
}

@end
