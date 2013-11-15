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

#import "HUAppDelegate.h"

#import "HUColorProbability.h"

#define DEFAULT_A @"Tap to Edit"
#define DEFAULT_B @"Tap to Edit"

#define HISTORY_PATH [NSString stringWithFormat:@"%@/history", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface HUViewController () <UIAlertViewDelegate, UITextFieldDelegate>
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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ENTER_BG object:nil queue:nil usingBlock:^(NSNotification *note) {
        //save history
        [self saveHistory];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateColors];
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

-(void)reset
{
    [self updateColors];
    
    labelA.text = DEFAULT_A;
    labelB.text = DEFAULT_B;
}

-(void)updateColors
{
    JCGradientBackground *gradient = (JCGradientBackground *)self.view;
    
    NSArray *userColors = [HUColorProbability userColors];
    
    if (arc4random()%2)
    {
        gradient.primary = userColors[0];
        gradient.secondary = userColors[1];
    }else{
        gradient.primary = userColors[1];
        gradient.secondary = userColors[0];
    }
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choice" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];
            
            alert.tag = 100;
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alert textFieldAtIndex:0];
            textField.placeholder = @"Option text";
            
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardAppearance = UIKeyboardAppearanceDefault;
            textField.delegate = self;
            
            
            [alert show];
        }
            
            break;
            
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
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
    if (!history) history = [NSMutableArray array];
    
    [history insertObject:process atIndex:0];
    
    buttonHistory.alpha = 1;
    [buttonHistory setEnabled:YES];
}

-(void)saveHistory
{
    [NSKeyedArchiver archiveRootObject:history toFile:HISTORY_PATH];
}

- (IBAction)decide:(id)sender
{
    BOOL isA = NO;
    
    UIColor *mostlyWinningColor = [HUColorProbability winningColor];
    
    if (arc4random()%100 > 40)
    {
        //mostly winning color should be shown
        
        if ([labelA.color isEqual:mostlyWinningColor])
        {
            isA = YES;
        }else{
            isA = NO;
        }
        
    }else{
        //mostly losing color should be shown
        
        if ([labelA.color isEqual:mostlyWinningColor])
        {
            isA = NO;
        }else{
            isA = YES;
        }
        
    }
    
    JCGradientBackground *view = (JCGradientBackground *)self.view;
    
    NSString *choice = isA ? labelA.text : labelB.text;
    UIColor *primary = isA ? view.primary : view.secondary;
    UIColor *secondary = isA ? view.secondary : view.primary;
    
    [HUResultView showResultWithTitle:@"Result:" message:choice color:primary inView:self.view buttonNames:@[@"Disagree", @"Agree"] action:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            //good
            
            [HUResultView showResultWithTitle:@"Great!" message:choice color:primary inView:self.view buttonNames:@[@"Ok"] action:^(NSInteger buttonIndex)
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
            
            [HUResultView showResultWithTitle:@"Ok, then:" message:opposite color:primary inView:self.view buttonNames:@[@"Ok"] action:^(NSInteger buttonIndex)
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
        
        viewHistory = [[UIView alloc] initWithFrame:self.view.bounds];
        
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
        
        collectionViewHistory.alwaysBounceVertical = YES;
        
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
