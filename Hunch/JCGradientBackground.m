//
//  JCGradientBackground.m
//  Hunch
//
//  Created by Jon Como on 11/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "JCGradientBackground.h"

@implementation JCGradientBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPrimary:(UIColor *)primary
{
    _primary = primary;
    
    [self setNeedsDisplay];
}

-(void)setSecondary:(UIColor *)secondary
{
    _secondary = secondary;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* primary = self.primary;
    CGFloat pR,pG,pB;
    [primary getRed:&pR green:&pG blue:&pB alpha:nil];
    UIColor* primaryTransparent = [UIColor colorWithRed:pR green:pG blue:pB alpha:0];
    
    
    UIColor* secondary = self.secondary;
    CGFloat sR,sG,sB;
    [primary getRed:&sR green:&sG blue:&sB alpha:nil];
    UIColor* secondaryTransparent = [UIColor colorWithRed:sR green:sG blue:sB alpha:0];
    
    //// Gradient Declarations
    NSArray* glowPrimaryColors = [NSArray arrayWithObjects:
                                  (id)primary.CGColor,
                                  (id)primaryTransparent.CGColor, nil];
    CGFloat glowPrimaryLocations[] = {0, 1};
    CGGradientRef glowPrimary = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)glowPrimaryColors, glowPrimaryLocations);
    NSArray* glowSecondaryColors = [NSArray arrayWithObjects:
                                    (id)secondary.CGColor,
                                    (id)secondaryTransparent.CGColor, nil];
    CGFloat glowSecondaryLocations[] = {0, 1};
    CGGradientRef glowSecondary = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)glowSecondaryColors, glowSecondaryLocations);
    
    //// Frames
    CGRect frame = CGRectMake(0, 0, 320, 568);
    
    
    //// ovalSecondary Drawing
    UIBezierPath* ovalSecondaryPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-481, -138, 1096, 1096)];
    CGContextSaveGState(context);
    [ovalSecondaryPath addClip];
    CGContextDrawRadialGradient(context, glowSecondary,
                                CGPointMake(67, 410), 0,
                                CGPointMake(67, 410), 528.04,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// ovalSecondary 2 Drawing
    CGRect ovalSecondary2Rect = CGRectMake(CGRectGetMinX(frame) - 135, CGRectGetMinY(frame) + 96, 909, 909);
    UIBezierPath* ovalSecondary2Path = [UIBezierPath bezierPathWithOvalInRect: ovalSecondary2Rect];
    CGContextSaveGState(context);
    [ovalSecondary2Path addClip];
    CGFloat ovalSecondary2ResizeRatio = MIN(CGRectGetWidth(ovalSecondary2Rect) / 909, CGRectGetHeight(ovalSecondary2Rect) / 909);
    CGContextDrawRadialGradient(context, glowSecondary,
                                CGPointMake(CGRectGetMidX(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio, CGRectGetMidY(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio), 0 * ovalSecondary2ResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio, CGRectGetMidY(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio), 437.95 * ovalSecondary2ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Oval Drawing
    CGRect ovalRect = CGRectMake(CGRectGetMinX(frame) - 353, CGRectGetMinY(frame) - 295, 705, 705);
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: ovalRect];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGFloat ovalResizeRatio = MIN(CGRectGetWidth(ovalRect) / 705, CGRectGetHeight(ovalRect) / 705);
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(ovalRect) + 0 * ovalResizeRatio, CGRectGetMidY(ovalRect) + 0 * ovalResizeRatio), 0 * ovalResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalRect) + 0 * ovalResizeRatio, CGRectGetMidY(ovalRect) + 0 * ovalResizeRatio), 339.66 * ovalResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Oval 2 Drawing
    CGRect oval2Rect = CGRectMake(CGRectGetMinX(frame) + 152, CGRectGetMinY(frame) - 11, 463, 463);
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: oval2Rect];
    CGContextSaveGState(context);
    [oval2Path addClip];
    CGFloat oval2ResizeRatio = MIN(CGRectGetWidth(oval2Rect) / 463, CGRectGetHeight(oval2Rect) / 463);
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(oval2Rect) + 0 * oval2ResizeRatio, CGRectGetMidY(oval2Rect) + 0 * oval2ResizeRatio), 0 * oval2ResizeRatio,
                                CGPointMake(CGRectGetMidX(oval2Rect) + 0 * oval2ResizeRatio, CGRectGetMidY(oval2Rect) + 0 * oval2ResizeRatio), 223.07 * oval2ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Oval 3 Drawing
    CGRect oval3Rect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) - 354, 685, 685);
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: oval3Rect];
    CGContextSaveGState(context);
    [oval3Path addClip];
    CGFloat oval3ResizeRatio = MIN(CGRectGetWidth(oval3Rect) / 685, CGRectGetHeight(oval3Rect) / 685);
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(oval3Rect) + 0 * oval3ResizeRatio, CGRectGetMidY(oval3Rect) + 0 * oval3ResizeRatio), 0 * oval3ResizeRatio,
                                CGPointMake(CGRectGetMidX(oval3Rect) + 0 * oval3ResizeRatio, CGRectGetMidY(oval3Rect) + 0 * oval3ResizeRatio), 330.03 * oval3ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(-17, -241, 361, 821)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, glowPrimary, CGPointMake(163.5, 580), CGPointMake(163.5, -241), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(glowPrimary);
    CGGradientRelease(glowSecondary);
    CGColorSpaceRelease(colorSpace);
}


@end
