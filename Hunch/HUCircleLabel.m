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

- (void)drawTextInRect:(CGRect)rect
{
    float inset = rect.size.width/6;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(inset, inset, inset, inset);
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //// Color Declarations
    UIColor* fillColor = self.color;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    [fillColor getRed:&red green:&green blue:&blue alpha:nil];
    
    UIColor *strokeColor = [UIColor colorWithRed:red*1.2 green:green*1.2 blue:blue*1.2 alpha:1];
    
    //// Frames
    CGRect frame = CGRectMake(3, 3, rect.size.width-6, rect.size.height-6);
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
    ovalPath.lineWidth = 3;
    [fillColor setFill];
    [strokeColor setStroke];
    [ovalPath fill];
    [ovalPath stroke];
    
    [super drawRect:rect];
}


@end
