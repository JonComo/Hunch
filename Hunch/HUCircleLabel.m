//
//  HUCircleLabel.m
//  Hunch
//
//  Created by Jon Como on 11/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUCircleLabel.h"

@implementation HUCircleLabel
{
    UIColor *highlightColor;
    UIColor *savedColor;
}

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
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    savedColor = color;
    highlightColor = [UIColor colorWithRed:red+0.5 green:green+0.5 blue:blue+0.5 alpha:1];
    
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    float inset = rect.size.width/6;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(inset, inset, inset, inset);
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _color = highlightColor;
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if ([self pointInside:point withEvent:event])
    {
        _color = highlightColor;
        [self setNeedsDisplay];
    }else{
        _color = savedColor;
        [self setNeedsDisplay];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _color = savedColor;
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _color = savedColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //// Color Declarations
    UIColor* fillColor = _color;
    
    //// Frames
    CGRect frame = CGRectMake(3, 3, rect.size.width-6, rect.size.height-6);
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
    ovalPath.lineWidth = 3;
    [fillColor setFill];
    [highlightColor setStroke];
    [ovalPath fill];
    [ovalPath stroke];
    
    [super drawRect:rect];
}


@end
