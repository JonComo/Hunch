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
    __weak IBOutlet HUCircleLabel *labelLosing;
    __weak IBOutlet HUCircleLabel *labelWinning;
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
    
    labelWinning.text = decision[@"FINAL"];
    
    if ([labelWinning.text isEqualToString:decision[@"A"]])
    {
        labelLosing.text = decision[@"B"];
        labelWinning.color = primary;
        labelLosing.color = secondary;
        
        self.backgroundColor = primary;
    }else{
        labelLosing.text = decision[@"A"];
        labelWinning.color = secondary;
        labelLosing.color = primary;
        
        self.backgroundColor = secondary;
    }
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
