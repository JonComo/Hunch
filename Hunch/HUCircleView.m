//
//  HUCircleView.m
//  Hunch
//
//  Created by Jon Como on 11/23/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUCircleView.h"

@implementation HUCircleView
{
    UIColor *lightColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    lightColor = [UIColor colorWithRed:red*1.4 green:green*1.4 blue:blue*1.4 alpha:1];
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* fillColor = _color;
    
    //// Frames
    CGRect frame = CGRectMake(3, 3, rect.size.width-6, rect.size.height-6);
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
    ovalPath.lineWidth = 3;
    [fillColor setFill];
    [lightColor setStroke];
    [ovalPath fill];
    [ovalPath stroke];
    
    [super drawRect:rect];
}

@end
