//
//  HUResultView.m
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUResultView.h"

#import "HUCircleLabel.h"

static HUResultView *resultView;
static UIView *fade;

@implementation HUResultView
{
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet HUCircleLabel *labelResult;
}

+(HUResultView *)showResultWithTitle:(NSString *)title message:(NSString *)message color:(UIColor *)color inView:(UIView *)parentView buttonNames:(NSArray *)buttonNames action:(Action)action
{
    if (!fade){
        fade = [[UIView alloc] initWithFrame:parentView.bounds];
        fade.backgroundColor = color;
        fade.alpha = 0;
        [parentView addSubview:fade];
    }else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fade.backgroundColor = color;
        } completion:nil];
    }
    
    if (resultView) [self hideAlertAnimated:NO hideFade:NO];
    
    resultView = [[NSBundle mainBundle] loadNibNamed:@"resultView" owner:self options:nil][0];
    
    resultView.title = title;
    resultView.message = message;
    resultView.color = color;
    resultView.action = action;
    resultView.buttonNames = buttonNames;
    
    resultView.layer.cornerRadius = 6;
    
    resultView.frame = CGRectMake(parentView.bounds.size.width/2 - resultView.frame.size.width/2, parentView.bounds.size.height/2 - resultView.frame.size.height/2, resultView.frame.size.width, resultView.frame.size.height);
    
    [parentView addSubview:resultView];
    
    resultView.alpha = 0.5;
    resultView.layer.transform = CATransform3DMakeScale(.9, 0.9, 1);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        resultView.alpha = 1;
        fade.alpha = 0.8;
        resultView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:nil];
    
    
    return resultView;
}

+(void)hideAlertAnimated:(BOOL)animated hideFade:(BOOL)hideFade
{
    if (!resultView) return;
    
    if (!animated)
    {
        [resultView removeFromSuperview];
        resultView = nil;
        
        if (hideFade){
            [fade removeFromSuperview];
            fade = nil;
        }
        
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        resultView.alpha = 0;
        if (hideFade) fade.alpha = 0;
    } completion:^(BOOL finished) {
        [resultView removeFromSuperview];
        resultView = nil;
        
        if (hideFade){
            [fade removeFromSuperview];
            fade = nil;
        }
    }];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    labelTitle.text = title;
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    
    labelResult.text = message;
}

-(void)setButtonNames:(NSArray *)buttonNames
{
    _buttonNames = buttonNames;
    
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    if (buttonNames.count == 0) return;
    
    float width = self.frame.size.width/buttonNames.count;
    
    //iterate and create buttons
    for (int x = 0; x<buttonNames.count; x++) {
        NSString *name = buttonNames[x];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = x;
        [button addTarget:self action:@selector(hitButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(x * width, 236, width, 44);
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
    }
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    
    labelResult.color = color;
    
    self.backgroundColor = color;
}

-(void)hitButton:(UIButton *)button
{
    if (self.action) self.action(button.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
