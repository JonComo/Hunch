//
//  HUResultView.m
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUResultView.h"

#import "HUCircleLabel.h"

@implementation HUResultView
{
    __weak IBOutlet HUCircleLabel *labelResult;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)good:(id)sender {
    if (self.action) self.action(YES);
}

- (IBAction)bad:(id)sender {
    if (self.action) self.action(NO);
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
