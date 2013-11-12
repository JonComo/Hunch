//
//  HUResultView.h
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Action)(NSInteger buttonIndex);

@interface HUResultView : UIView

+(HUResultView *)showResultWithTitle:(NSString *)title message:(NSString*)message color:(UIColor *)color inView:(UIView *)parentView buttonNames:(NSArray *)buttonNames action:(Action)action;

+(void)hideAlertAnimated:(BOOL)animated hideFade:(BOOL)hideFade;

@property (nonatomic, strong) Action action;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray *buttonNames;

@end
