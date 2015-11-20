//
//  SelectViewController.m
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "SelectViewController.h"
#import "CardView.h"
#import "PlickersAPI.h"

@interface SelectViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    float DEVICE_WIDTH;
    float DEVICE_HEIGHT;
    float NAV_HEIGHT;
    float STAT_HEIGHT;
    
    NSDictionary *convertDictionary;
    
    CardView *cardView;
    UIView *cardIndentView;
    UITableView *answersTableView;
    
}

-(int)getCorrectAnswer:(int)index;

@end

@implementation SelectViewController

-(id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)viewDidLoad {
    
    DEVICE_WIDTH = [[UIScreen mainScreen]bounds].size.width;
    DEVICE_HEIGHT = [[UIScreen mainScreen]bounds].size.height;
    NAV_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    STAT_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    convertDictionary = @{
                            @"A": @(0),
                            @"B": @(1),
                            @"C": @(2),
                            @"D": @(3),
                            @"E": @(4),
                            @"G": @(5),
                            @"G": @(6),
                            @"H": @(7)
                            };
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    cardView = [[CardView alloc]init];
    cardView.frame = CGRectMake(20,
                                NAV_HEIGHT + STAT_HEIGHT + 20,
                                DEVICE_WIDTH - 40,
                                DEVICE_WIDTH - 120);
    
    cardIndentView = [[UIView alloc]init];
    cardIndentView.frame = CGRectMake(20 - 4,
                                         NAV_HEIGHT + STAT_HEIGHT + 20 - 4,
                                         DEVICE_WIDTH - 40 + 8,
                                         DEVICE_WIDTH - 120 + 8);
    cardIndentView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    cardIndentView.layer.cornerRadius = 10;
    cardIndentView.layer.zPosition = -100;
    
    answersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                    cardIndentView.frame.origin.y + cardIndentView.frame.size.height + 10,
                                                                    DEVICE_WIDTH,
                                                                    DEVICE_HEIGHT - (cardView.frame.origin.y + cardView.frame.size.height + 10))];
    
    cardView.dataSource = self.dataSource;
    [cardView setup];
    
    answersTableView.allowsSelection = false;
    answersTableView.dataSource = self;
    answersTableView.delegate = self;
    
    [self.view addSubview:cardIndentView];
    [self.view addSubview:cardView];
    [self.view addSubview:answersTableView];
        
}

-(int)getCorrectAnswer:(int)index {
    
    int correctAnswer = -1;
    
    NSArray *choices = [[self.dataSource valueForKey:@"question"]valueForKey:@"choices"];
    
    for (int i = 0; i < choices.count; i++) {
        if ([[[choices objectAtIndex:i]valueForKey:@"correct"]boolValue] == true) {
            correctAnswer = i;
            break;
        }
    }
    
    return correctAnswer;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self.dataSource valueForKey:@"responses"]).count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"something"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"something"];
        cell.textLabel.numberOfLines = 3;
        cell.imageView.backgroundColor = [UIColor redColor];
    }
    
    NSDictionary *student = [[self.dataSource valueForKey:@"responses"]objectAtIndex:indexPath.row];
    NSString *email = [student valueForKey:@"student"];
    NSString *name = [[[email componentsSeparatedByString:@"@"]objectAtIndex:0]capitalizedString];
    NSString *answer = [student valueForKey:@"answer"];
    
    cell.detailTextLabel.textColor = [UIColor redColor];
    
    if ([[convertDictionary valueForKey:answer]intValue] == [self getCorrectAnswer:(int)indexPath.row]) {
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", name, email];
    cell.detailTextLabel.text = answer;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:cell.textLabel.attributedText];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(name.length, email.length + 1)];
    cell.textLabel.attributedText = text;
    
    return cell;
}

@end
