//
//  HUHistoryCell.m
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUHistoryCell.h"

#import "JCGradientBackground.h"
#import "HUCircleLabel.h"

@implementation HUHistoryCell
{
    __weak IBOutlet HUCircleLabel *labelA;
    __weak IBOutlet HUCircleLabel *labelB;
    __weak IBOutlet HUCircleLabel *labelResult;
    
    __weak IBOutlet JCGradientBackground *viewGradient;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDecision:(NSDictionary *)decision
{
    _decision = decision;
    
    UIColor *primary = decision[@"PRIMARY"];
    UIColor *secondary = decision[@"SECONDARY"];
    
    labelA.text = decision[@"A"];
    labelB.text = decision[@"B"];
    labelResult.text = decision[@"FINAL"];
    
    labelA.color = primary;
    labelB.color = secondary;
    
    if ([labelResult.text isEqualToString:labelA.text])
    {
        labelResult.color = labelA.color;
    }else{
        labelResult.color = labelB.color;
    }
    
    viewGradient.primary = primary;
    viewGradient.secondary = secondary;
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
