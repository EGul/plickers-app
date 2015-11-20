//
//  ViewController.m
//  PlickersApp
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "ViewController.h"
#import "SelectViewController.h"
#import "PlickersAPI.h"

#import "Reachability.h"
#import "DateTools.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    float DEVICE_WIDTH;
    float DEVICE_HEIGHT;
    
    NSArray *dataSource;
    
    Reachability *reach;
    
    NSIndexPath *selectedIndex;
    UITableView *mainTableView;
    
}

-(void)didGetJSON:(NSArray *)jsonArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    DEVICE_WIDTH = [[UIScreen mainScreen]bounds].size.width;
    DEVICE_HEIGHT = [[UIScreen mainScreen]bounds].size.height;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.topItem.title = @"Plickers";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2/255.0f green:27/255.0f blue:39/255.0f alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    mainTableView = [[UITableView alloc]init];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    
    [self.view addSubview:mainTableView];
    
    reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    __weak typeof(self) weakSelf = self;
    
    reach.reachableBlock = ^ (Reachability *reach) {
      
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (dataSource.count == 0) {
                [PlickersAPI getJSON:^ (NSArray *jsonArray, NSError *error) {
                    if (!error) {
                        [weakSelf didGetJSON:jsonArray];
                    }
                }];
            }
        });
        
    };
    
    [reach startNotifier];
    
    if (!reach.isReachable) {
        
        NSString *title = @"Turn Off Airplane Mode or Use WI-FI to Access Data";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:false completion:nil];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [mainTableView deselectRowAtIndexPath:selectedIndex animated:true];
}

-(void)didGetJSON:(NSArray *)jsonArray {
    dataSource = jsonArray;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [mainTableView reloadData];
    });
}

-(int)getCorrectAnswer:(int)index {
    
    int correctAnswer = 0;
    
    NSArray *choices = [[[dataSource objectAtIndex:index]valueForKey:@"question"]valueForKey:@"choices"];
    
    for (int i = 0; i < choices.count; i++) {
        if ([[[choices objectAtIndex:i]valueForKey:@"correct"]boolValue] == true) {
            correctAnswer = i;
            break;
        }
    }
    
    return correctAnswer;
}

-(int)getPercentageCorrect:(int)index {
    
    int total = 0;
    int correctAnswer = [self getCorrectAnswer:index];
    NSArray *responces = [[dataSource objectAtIndex:index]valueForKey:@"responses"];
    
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
    
    for (int i = 0; i < responces.count; i++) {
        NSString *answer = [[responces objectAtIndex:i]valueForKey:@"answer"];
        if ([[convertDictionary valueForKey:answer]intValue] == correctAnswer) {
            total++;
        }
    }
    
    return ((float)total / (float)responces.count) * 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"something"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"something"];
        cell.textLabel.numberOfLines = 4;
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    int percent = [self getPercentageCorrect:(int)indexPath.row];
    
    NSDictionary *selected = [dataSource objectAtIndex:indexPath.row];
    NSString *body = [[selected valueForKey:@"question"]valueForKey:@"body"];
    NSString *created = [[[selected valueForKey:@"created"]componentsSeparatedByString:@"T"]objectAtIndex:0];
    NSString *formattedCreated = @"";
    NSString *percentCorrect = [NSString stringWithFormat:@"%d%@", percent, @"%"];
    
    NSArray *createdArray = [created componentsSeparatedByString:@"-"];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setYear:[[createdArray objectAtIndex:0]intValue]];
    [components setMonth:[[createdArray objectAtIndex:1]intValue]];
    [components setDay:[[createdArray objectAtIndex:2]intValue]];
    
    formattedCreated = [[NSCalendar currentCalendar]dateFromComponents:components].timeAgoSinceNow;
    
    cell.textLabel.text = body;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", formattedCreated, percentCorrect];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:cell.detailTextLabel.attributedText];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(formattedCreated.length, percentCorrect.length + 1)];
    cell.detailTextLabel.attributedText = text;
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(formattedCreated.length, percentCorrect.length + 1)];
    cell.detailTextLabel.attributedText = text;
    
    if (percent > 50) {
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(formattedCreated.length, percentCorrect.length + 1)];
        cell.detailTextLabel.attributedText = text;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath;
    
    if (!reach.isReachable) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:false];
        
        NSString *title = @"Turn Off Airplane Mode or Use WI-FI to Access Data";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:false completion:nil];
        return;
    }
 
    SelectViewController *selectViewController = [[SelectViewController alloc]init];
    selectViewController.dataSource = [dataSource objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:selectViewController animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
