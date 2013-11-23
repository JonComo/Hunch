//
//  HUViewController.m
//  Hunch
//
//  Created by Jon Como on 11/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUViewController.h"

#import "JCGradientBackground.h"

#import "JCCollectionView.h"
#import "HUHistoryCell.h"

#import "HUResultView.h"

#import "HUAppDelegate.h"

#import "HUColorProbability.h"

#import "HUCircleView.h"

#define DEFAULT_TEXT @"Choice"

#define HISTORY_PATH [NSString stringWithFormat:@"%@/history", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface HUViewController () <UIAlertViewDelegate, UITextViewDelegate>
{
    __weak IBOutlet UIImageView *imageViewLogo;
    
    __weak IBOutlet UITextView *textViewA;
    __weak IBOutlet UITextView *textViewB;
    
    __weak IBOutlet HUCircleView *viewCircleA;
    __weak IBOutlet HUCircleView *viewCircleB;
    
    __weak IBOutlet NSLayoutConstraint *constraintA;
    __weak IBOutlet NSLayoutConstraint *constraintB;
    
    float defaultConstraint;
    
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
    
    defaultConstraint = constraintA.constant;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveHistory) name:ENTER_BG object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    [textViewA addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [textViewB addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateColors];
    
    [self centerTextView:textViewA];
    [self centerTextView:textViewB];
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
    
    textViewA.text = DEFAULT_TEXT;
    textViewB.text = DEFAULT_TEXT;
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
    
    viewCircleA.color = gradient.primary;
    viewCircleB.color = gradient.secondary;
    
    [gradient setNeedsDisplay];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardRect;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    NSLog(@"Rect: %@", NSStringFromCGRect(keyboardRect));
    
    if (keyboardRect.origin.y < self.view.bounds.size.height)
    {
        //visible
        [self moveTextViewsUp:YES];
    }else{
        [self moveTextViewsUp:NO];
    }
}

-(void)hideKeyboard
{
    [textViewB resignFirstResponder];
    [textViewA resignFirstResponder];
}

-(void)moveTextViewsUp:(BOOL)moveUp
{
    float targetConstraint = moveUp ? 80 : defaultConstraint;
    
    [UIView animateWithDuration:0.3 animations:^{
        constraintA.constant = targetConstraint;
        constraintB.constant = targetConstraint;
        
        imageViewLogo.alpha = moveUp ? 0 : 1;
        
        [self.view layoutSubviews];
    }];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:DEFAULT_TEXT]) {
        textView.text = @"";
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = DEFAULT_TEXT;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if (![self autoSelectFields]){
            [textView resignFirstResponder];
        }
        
        return NO;
    }
    
    if (textView.text.length + (text.length - range.length) >= 52)
    {
        return NO;
    }
    
    return YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[UITextView class]])
    {
        [self centerTextView:object];
    }
}

-(void)centerTextView:(UITextView *)textView
{
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height * [textView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    textView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
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

-(BOOL)unfilledFields
{
    if ([textViewA.text isEqualToString:DEFAULT_TEXT] || [textViewB.text isEqualToString:DEFAULT_TEXT])
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)autoSelectFields
{
    if ([textViewA.text isEqualToString:DEFAULT_TEXT])
    {
        [textViewA becomeFirstResponder];
        
        return YES;
    }
    
    if ([textViewB.text isEqualToString:DEFAULT_TEXT])
    {
        [textViewB becomeFirstResponder];
        
        return YES;
    }
    
    return NO;
}

- (IBAction)decide:(id)sender
{
    if ([self unfilledFields])
    {
        [self autoSelectFields];
        return;
    }
    
    BOOL isA = NO;
    
    UIColor *mostlyWinningColor = [HUColorProbability winningColor];
    
    if (arc4random()%100 > 40)
    {
        //mostly winning color should be shown
        
        if ([viewCircleA.color isEqual:mostlyWinningColor])
        {
            isA = YES;
        }else{
            isA = NO;
        }
        
    }else{
        //mostly losing color should be shown
        
        if ([viewCircleA.color isEqual:mostlyWinningColor])
        {
            isA = NO;
        }else{
            isA = YES;
        }
        
    }
    
    JCGradientBackground *view = (JCGradientBackground *)self.view;
    
    NSString *choice = isA ? textViewA.text : textViewB.text;
    UIColor *primary = isA ? view.primary : view.secondary;
    UIColor *secondary = isA ? view.secondary : view.primary;
    
    [HUResultView showResultWithTitle:@"Result:" message:choice color:primary inView:self.view buttonNames:@[@"Disagree", @"Agree"] action:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            //good
            NSDictionary *decision = @{@"A": textViewA.text, @"B": textViewB.text, @"RAND": choice, @"FINAL": choice, @"PRIMARY": primary, @"SECONDARY": secondary};
            
            HUResultView *resultView = [HUResultView showResultWithTitle:@"Great!" message:choice color:primary inView:self.view buttonNames:@[@"Ok"] action:^(NSInteger buttonIndex)
            {
                
                [self archiveProcess:decision];
                
                [self reset];
                [HUResultView hideAlertAnimated:YES hideFade:YES];
            }];
            
            resultView.decision = decision;
        }else{
            //bad
            
            NSString *choice = isA ? textViewA.text : textViewB.text;
            NSString *opposite = isA ? textViewB.text : textViewA.text;
            UIColor *primary = isA ? view.secondary : view.primary;
            UIColor *secondary = isA ? view.primary : view.secondary;
            
            NSDictionary *decision = @{@"A": textViewA.text, @"B": textViewB.text, @"RAND": choice, @"FINAL": opposite, @"PRIMARY": primary, @"SECONDARY": secondary};
            
            HUResultView *resultView = [HUResultView showResultWithTitle:@"Ok, then:" message:opposite color:primary inView:self.view buttonNames:@[@"Ok"] action:^(NSInteger buttonIndex)
            {
                [self archiveProcess:decision];
                
                [self reset];
                [HUResultView hideAlertAnimated:YES hideFade:YES];
            }];
            
            resultView.decision = decision;
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
