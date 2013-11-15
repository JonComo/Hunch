//
//  HUInfoViewController.m
//  Hunch
//
//  Created by Jon Como on 11/15/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUInfoViewController.h"

#import "MBProgressHUD.h"
#import "ISColorWheel.h"

#import "JCGradientBackground.h"

#import "HUColorProbability.h"

@interface HUInfoViewController () <ISColorWheelDelegate>
{
    UIColor *pickedColor;
    
    __weak IBOutlet UIButton *buttonColor1;
    __weak IBOutlet UIButton *buttonColor2;
    
    __weak IBOutlet UITextView *textViewInfo;
    
    UIButton *buttonToSet;
    
    
    __weak IBOutlet UIView *maskView;
}

@end

@implementation HUInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *colors = [HUColorProbability userColors];
    
    [buttonColor1 setBackgroundColor:colors[0]];
    [buttonColor2 setBackgroundColor:colors[1]];
    
    buttonColor1.layer.cornerRadius = 6;
    buttonColor2.layer.cornerRadius = 6;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupMask];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupMask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupMask
{
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    
    maskLayer.colors = @[
                         (id)[UIColor clearColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor whiteColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    
    maskLayer.locations = @[ @0.0f, @0.05f, @0.95f, @1.0f ];
    maskLayer.frame = maskView.bounds;
    
    maskView.layer.mask = maskLayer;
}

- (IBAction)setColor1:(id)sender
{
    buttonToSet = sender;
    [self showColorWheel:sender];
}

- (IBAction)setColor2:(id)sender
{
    buttonToSet = sender;
    [self showColorWheel:sender];
}

-(void)updateColors
{
    buttonToSet.backgroundColor = pickedColor;
    
    NSArray *colors = @[buttonColor1.backgroundColor, buttonColor2.backgroundColor];
    
    [HUColorProbability setUserColors:colors];
    
    JCGradientBackground *view = (JCGradientBackground *)self.view;
    
    view.primary = colors[0];
    view.secondary = colors[1];
    
    [view setNeedsDisplay];
}

- (IBAction)resetPattern:(id)sender
{
    [HUColorProbability setRandomWinningColor];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [hud setMode:MBProgressHUDModeText];
    
    hud.labelText = @"Pattern Reset Successfully";
    
    [hud hide:YES afterDelay:1];
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showColorWheel:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [hud setMode:MBProgressHUDModeCustomView];
    
    hud.color = [UIColor colorWithWhite:0 alpha:0.2];
    
    ISColorWheel *wheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(20, 0, 160, 160)];
    
    wheel.delegate = self;
    wheel.continuous = YES;
    
    [wheel setCurrentColor:sender.backgroundColor];
    [wheel setNeedsDisplay];
    
    hud.customView = wheel;
}

-(void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    pickedColor = colorWheel.currentColor;
    
    [self updateColors];
}

-(void)colorWheelLiftedTap:(ISColorWheel *)colorWheel
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end