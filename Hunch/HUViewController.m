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

@interface HUViewController () <UIAlertViewDelegate>
{
    HUCircleLabel *labelToChange;
    
    NSString *decidedOption;
    
    __weak IBOutlet HUCircleLabel *labelOption1;
    __weak IBOutlet HUCircleLabel *labelOption2;
}

@end

@implementation HUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOption:)];
    [labelOption1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOption:)];
    [labelOption2 addGestureRecognizer:tap2];
    
    [self changeColors];
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
    float r = [self randomFloat];
    float g = [self randomFloat];
    float b = [self randomFloat];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

-(void)changeColors
{
    JCGradientBackground *gradient = (JCGradientBackground *)self.view;
    
    gradient.primary = [self randomColor];
    gradient.secondary = [self randomColor];
    
    labelOption1.color = gradient.primary;
    labelOption2.color = gradient.secondary;
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
        
        if (buttonIndex == 1) {
            //show same option
            
            title = @"Great!";
            
        }else{
            //show other option
            
            title = @"Ok, then..";
            
            if ([decidedOption isEqualToString:labelOption1.text])
            {
                decidedOption = labelOption2.text;
            }else{
                decidedOption = labelOption1.text;
            }
        }
        
        UIAlertView *finalAlert = [[UIAlertView alloc] initWithTitle:title message:decidedOption delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        finalAlert.tag = 300;
        [finalAlert show];
    }else if(alertView.tag == 300)
    {
        //final alert
        [self changeColors];
        labelOption1.text = @"A";
        labelOption2.text = @"B";
    }
}

- (IBAction)decide:(id)sender {
    int random = arc4random()%2;
    
    if (random)
    {
        decidedOption = labelOption1.text;
    }else{
        decidedOption = labelOption2.text;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do this:" message:decidedOption delegate:self cancelButtonTitle:@"NO!" otherButtonTitles:@"YEAH!", nil];
    
    alert.tag = 200;
    
    [alert show];
}

@end
