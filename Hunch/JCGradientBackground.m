//
//  JCGradientBackground.m
//  Hunch
//
//  Created by Jon Como on 11/11/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "JCGradientBackground.h"

@implementation JCGradientBackground

-(void)setPrimary:(UIColor *)primary
{
    _primary = primary;
}

-(void)setSecondary:(UIColor *)secondary
{
    _secondary = secondary;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat r,g,b;
    
    [self.primary getRed:&r green:&g blue:&b alpha:nil];
    
    float m = 1;
    
    //// Color Declarations
    UIColor* primary = [UIColor colorWithRed:r*m green:g*m blue:b*m alpha:1];
    UIColor* primaryTransparent = [UIColor colorWithRed:r*m green:g*m blue:b*m alpha:0];
    
    [self.secondary getRed:&r green:&g blue:&b alpha:nil];
    
    UIColor* secondary = [UIColor colorWithRed:r*m green:g*m blue:b*m alpha:1];
    UIColor* secondaryTransparent = [UIColor colorWithRed:r*m green:g*m blue:b*m alpha:0];
    
    
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
    CGRect frame = rect;
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [secondary setFill];
    [rectanglePath fill];
    
    
    //// ovalSecondary 3 Drawing
    UIBezierPath* ovalSecondary3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-430, -158, 1122, 1122)];
    CGContextSaveGState(context);
    [ovalSecondary3Path addClip];
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(131, 403), 0,
                                CGPointMake(131, 403), 536.95,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// ovalSecondary 2 Drawing
    CGRect ovalSecondary2Rect = CGRectMake(CGRectGetMinX(frame) - 666, CGRectGetMinY(frame) + 144, 1087, 1087);
    UIBezierPath* ovalSecondary2Path = [UIBezierPath bezierPathWithOvalInRect: ovalSecondary2Rect];
    CGContextSaveGState(context);
    [ovalSecondary2Path addClip];
    CGFloat ovalSecondary2ResizeRatio = MIN(CGRectGetWidth(ovalSecondary2Rect) / 1087, CGRectGetHeight(ovalSecondary2Rect) / 1087);
    CGContextDrawRadialGradient(context, glowSecondary,
                                CGPointMake(CGRectGetMidX(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio, CGRectGetMidY(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio), 0 * ovalSecondary2ResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio, CGRectGetMidY(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio), 523.71 * ovalSecondary2ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// ovalSecondary Drawing
    CGRect ovalSecondaryRect = CGRectMake(CGRectGetMinX(frame) - 337, CGRectGetMinY(frame) - 658, 1122, 1122);
    UIBezierPath* ovalSecondaryPath = [UIBezierPath bezierPathWithOvalInRect: ovalSecondaryRect];
    CGContextSaveGState(context);
    [ovalSecondaryPath addClip];
    CGFloat ovalSecondaryResizeRatio = MIN(CGRectGetWidth(ovalSecondaryRect) / 1122, CGRectGetHeight(ovalSecondaryRect) / 1122);
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(ovalSecondaryRect) + 0 * ovalSecondaryResizeRatio, CGRectGetMidY(ovalSecondaryRect) + 0 * ovalSecondaryResizeRatio), 0 * ovalSecondaryResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalSecondaryRect) + 0 * ovalSecondaryResizeRatio, CGRectGetMidY(ovalSecondaryRect) + 0 * ovalSecondaryResizeRatio), 536.95 * ovalSecondaryResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(glowPrimary);
    CGGradientRelease(glowSecondary);
    CGColorSpaceRelease(colorSpace);

}


@end
