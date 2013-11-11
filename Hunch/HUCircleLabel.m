//
//  HUCircleLabel.m
//  Hunch
//
//  Created by Jon Como on 11/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUCircleLabel.h"

@implementation HUCircleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor colorWithWhite:0 alpha:0];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //init
        _color = [UIColor colorWithWhite:0 alpha:0];
    }
    
    return self;
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //// Color Declarations
    UIColor* fillColor = self.color;
    
    //// Frames
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [fillColor setFill];
    [ovalPath fill];
    
    [super drawRect:rect];
}


@end
