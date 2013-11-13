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

#import "HUResultView.h"

#define DEFAULT_A @"Tap to edit option 1"
#define DEFAULT_B @"Tap to edit option 2"

#define HISTORY_PATH [NSString stringWithFormat:@"%@/history", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface HUViewController () <UIAlertViewDelegate>
{
    HUCircleLabel *labelToChange;
    
    __weak IBOutlet HUCircleLabel *labelA;
    __weak IBOutlet HUCircleLabel *labelB;
    
    __weak IBOutlet UIButton *buttonHistory;
    
    UIView *viewHistory;
    JCCollectionView *collectionViewHistory;
    
    NSMutableArray *history;
    
    BOOL showingAlert;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self reset];
    
    history = [self loadHistory];
    
    if (history.count != 0)
    {
        buttonHistory.alpha = 1;
        [buttonHistory setEnabled:YES];
    }else{
        buttonHistory.alpha = 0;
        [buttonHistory setEnabled:NO];
    }
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

-(void)reset
{
    [self changeColors];
    
    labelA.text = DEFAULT_A;
    labelB.text = DEFAULT_B;
}

-(void)changeColors
{
    JCGradientBackground *gradient = (JCGradientBackground *)self.view;
    
    gradient.primary = [self randomColor];
    gradient.secondary = [self randomColor];
    
    labelA.color = gradient.primary;
    labelB.color = gradient.secondary;
    
    [gradient setNeedsDisplay];
}

-(void)tappedOption:(UITapGestureRecognizer *)tap
{
    labelToChange = (HUCircleLabel *)tap.view;
    
    switch (tap.state) {
            
        case UIGestureRecognizerStateRecognized:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(labelToChange == labelA) ? @"First Option" : @"Second Option" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
            
            alert.tag = 100;
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alert textFieldAtIndex:0];
            textField.placeholder = @"Option text";
            
            [alert show];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1) {
            UITextField *textField = (UITextField *)[alertView textFieldAtIndex:0];
            
            labelToChange.text = textField.text;
        }
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
    
    [history insertObject:process atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:history toFile:HISTORY_PATH];
    
    buttonHistory.alpha = 1;
    [buttonHistory setEnabled:YES];
}

- (IBAction)decide:(id)sender
{
    BOOL isA;
    
    JCGradientBackground *view = (JCGradientBackground *)self.view;
    
    int random = arc4random()%2;
    if (random)
    {
        //A
        isA = YES;
    }else{
        //B
        isA = NO;
    }
    
    NSString *choice = isA ? labelA.text : labelB.text;
    UIColor *primary = isA ? view.primary : view.secondary;
    UIColor *secondary = isA ? view.secondary : view.primary;
    
    [HUResultView showResultWithTitle:@"Result" message:choice color:primary inView:self.view buttonNames:@[@"Disagree", @"Agree"] action:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            //good
            
            [HUResultView showResultWithTitle:@"Great! Then do" message:choice color:primary inView:self.view buttonNames:@[@"Ok"] action:^(NSInteger buttonIndex)
            {
                [self archiveProcess:@{@"A": labelA.text, @"B": labelB.text, @"RAND": choice, @"FINAL": choice, @"PRIMARY": primary, @"SECONDARY": secondary}];
                
                [self reset];
                [HUResultView hideAlertAnimated:YES hideFade:YES];
            }];
        }else{
            //bad
            
            NSString *choice = isA ? labelA.text : labelB.text;
            NSString *opposite = isA ? labelB.text : labelA.text;
            UIColor *primary = isA ? view.secondary : view.primary;
            UIColor *secondary = isA ? view.primary : view.secondary;
            
            [HUResultView showResultWithTitle:@"Ok, then do" message:opposite color:primary inView:self.view buttonNames:@[@"Ok"] action:^(NSInteger buttonIndex)
            {
                [self archiveProcess:@{@"A": labelA.text, @"B": labelB.text, @"RAND": choice, @"FINAL": opposite, @"PRIMARY": primary, @"SECONDARY": secondary}];
                
                [self reset];
                [HUResultView hideAlertAnimated:YES hideFade:YES];
            }];
        }
    }];
}

- (IBAction)showHistory:(id)sender
{
    if (history.count == 0) return;
    
    if (!viewHistory)
    {
        JCGradientBackground *view = (JCGradientBackground *)self.view;
        
        viewHistory = [[UIView alloc] initWithFrame:self.view.frame];
        
        CGFloat red;
        CGFloat blue;
        CGFloat green;

        [view.primary getRed:&red green:&green blue:&blue alpha:nil];
        
        viewHistory.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
        
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
            
            historyCell.buttonRemove.tag = indexPath.row;
            
            if (historyCell.buttonRemove.allTargets.count == 0)
            {
                [historyCell.buttonRemove addTarget:self action:@selector(deleteHistoryItem:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            return cell;
            
        }];
        
        collectionViewHistory.cellName = @"historyCell";
        
        
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

-(void)deleteHistoryItem:(UIButton *)button
{
    int index = button.tag;
    
    [history removeObjectAtIndex:index];
    
    if (history.count == 0)
    {
        [self hideHistory];
        
        buttonHistory.alpha = 0;
        [buttonHistory setEnabled:NO];
        
    }else{
        [collectionViewHistory reloadData];
    }
    
    [NSKeyedArchiver archiveRootObject:history toFile:HISTORY_PATH];
}

@end
