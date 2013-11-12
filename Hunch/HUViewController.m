//
//  HUViewController.m
//  Hunch
//
//  Created by Jon Como on 11/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUViewController.h"

#import "JCGradientBackground.h"
#import "HUCircleLabel.h"

#import "JCCollectionView.h"
#import "HUHistoryCell.h"

#define HISTORY_PATH [NSString stringWithFormat:@"%@/history", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface HUViewController () <UIAlertViewDelegate>
{
    HUCircleLabel *labelToChange;
    
    NSString *decidedOption;
    
    __weak IBOutlet HUCircleLabel *labelA;
    __weak IBOutlet HUCircleLabel *labelB;
    
    UIView *viewHistory;
    JCCollectionView *collectionViewHistory;
    
    NSMutableArray *history;
}

@end

@implementation HUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOption:)];
    [labelA addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOption:)];
    [labelB addGestureRecognizer:tap2];
    
    [self changeColors];
    
    history = [self loadHistory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(float)randomFloat
{
    return (float)(arc4random()%100)/100.0f;
}

-(UIColor *)randomColor
{
    float r = [self randomFloat]*0.8;
    float g = [self randomFloat]*0.8;
    float b = [self randomFloat]*0.8;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

-(void)changeColors
{
    JCGradientBackground *gradient = (JCGradientBackground *)self.view;
    
    gradient.primary = [self randomColor];
    gradient.secondary = [self randomColor];
    
    labelA.color = gradient.primary;
    labelB.color = gradient.secondary;
}

-(void)tappedOption:(UITapGestureRecognizer *)tap
{
    labelToChange = (UILabel *)tap.view;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Option" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
    
    alert.tag = 100;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Option text";
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1) {
            UITextField *textField = (UITextField *)[alertView textFieldAtIndex:0];
            
            labelToChange.text = textField.text;
        }
    }else if(alertView.tag == 200)
    {
        NSString *title;
        NSString *finalChoice;
        
        if (buttonIndex == 1) {
            //show same option
            
            title = @"Great!";
            
        }else{
            //show other option
            
            title = @"Ok, then..";
            
            if ([decidedOption isEqualToString:labelA.text])
            {
                finalChoice = labelB.text;
            }else{
                finalChoice = labelA.text;
            }
        }
        
        UIAlertView *finalAlert = [[UIAlertView alloc] initWithTitle:title message:finalChoice delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        finalAlert.tag = 300;
        [finalAlert show];
        
        JCGradientBackground *view = (JCGradientBackground *)self.view;
        
        [self archiveProcess:@{@"A": labelA.text, @"B": labelB.text, @"RAND": decidedOption, @"FINAL": finalChoice ? finalChoice : decidedOption, @"PRIMARY": view.primary, @"SECONDARY": view.secondary}];
        
    }else if(alertView.tag == 300)
    {
        //final alert
        [self changeColors];
        labelA.text = @"A";
        labelB.text = @"B";
    }
}

-(NSMutableArray *)loadHistory
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:HISTORY_PATH isDirectory:NO])
    {
        //unarchive the array
        return  [NSKeyedUnarchiver unarchiveObjectWithFile:HISTORY_PATH];
    }
    
    return nil;
}

-(void)archiveProcess:(NSDictionary *)process
{
    history = [self loadHistory];
    
    if (!history) history = [NSMutableArray array];
    
    [history addObject:process];
    
    [NSKeyedArchiver archiveRootObject:history toFile:HISTORY_PATH];
}

- (IBAction)decide:(id)sender {
    int random = arc4random()%2;
    
    if (random)
    {
        decidedOption = labelA.text;
    }else{
        decidedOption = labelB.text;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do this:" message:decidedOption delegate:self cancelButtonTitle:@"NO!" otherButtonTitles:@"YEAH!", nil];
    
    alert.tag = 200;
    
    [alert show];
}

- (IBAction)showHistory:(id)sender {
    
    if (!viewHistory)
    {
        viewHistory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        viewHistory.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHistory)];
        [viewHistory addGestureRecognizer:tap];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(80, 30, 80, 30);
        CGSize size = CGSizeMake(self.view.bounds.size.width - insets.left - insets.right, self.view.bounds.size.height - insets.top - insets.bottom);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(size.width, 215);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        collectionViewHistory = [[JCCollectionView alloc] initWithFrame:CGRectMake(insets.left, insets.top, size.width, size.height) collectionViewLayout:layout cellConfigure:^UICollectionViewCell *(UICollectionViewCell *cell, NSIndexPath *indexPath) {
            
            NSDictionary *decision = collectionViewHistory.data[indexPath.row];
            
            HUHistoryCell *historyCell = (HUHistoryCell *)cell;
            
            historyCell.decision = decision;
            
            return cell;
            
        }];
        
        collectionViewHistory.cellName = @"historyCell";
        
        JCGradientBackground *view = (JCGradientBackground *)self.view;
        
        JCGradientBackground *viewBackground = [[JCGradientBackground alloc] initWithFrame:CGRectMake(0, 0, collectionViewHistory.backgroundView.bounds.size.width, collectionViewHistory.backgroundView.bounds.size.height)];
        
        viewBackground.primary = view.primary;
        viewBackground.secondary = view.secondary;
        
        collectionViewHistory.backgroundView = viewBackground;
        
        collectionViewHistory.layer.cornerRadius = 6;
        
        [viewHistory addSubview:collectionViewHistory];
    }
    
    if (!viewHistory.superview)
    {
        collectionViewHistory.data = history;
        [collectionViewHistory reloadData];
        
        JCGradientBackground *view = (JCGradientBackground *)self.view;
        JCGradientBackground *collectionBG = (JCGradientBackground *)collectionViewHistory.backgroundView;
        
        collectionBG.primary = view.primary;
        collectionBG.secondary = view.secondary;
        
        [self.view addSubview:viewHistory];
        
        viewHistory.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            viewHistory.alpha = 1;
        }];
    }
}

-(void)hideHistory
{
    if (viewHistory.superview){
        [UIView animateWithDuration:0.3 animations:^{
            viewHistory.alpha = 0;
        } completion:^(BOOL finished) {
            [viewHistory removeFromSuperview];
        }];
    }
}

@end
