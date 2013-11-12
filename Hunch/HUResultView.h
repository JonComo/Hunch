//
//  HUResultView.h
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Action)(BOOL isGood);

@interface HUResultView : UIView

@property (nonatomic, strong) Action action;

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) UIColor *primary;

@end
