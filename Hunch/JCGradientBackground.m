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
    
    //// Color Declarations
    UIColor* primary = self.primary;
    CGFloat pR,pG,pB;
    [primary getRed:&pR green:&pG blue:&pB alpha:nil];
    UIColor* primaryTransparent = [UIColor colorWithRed:pR green:pG blue:pB alpha:0];
    
    
    UIColor* secondary = self.secondary;
    CGFloat sR,sG,sB;
    [primary getRed:&sR green:&sG blue:&sB alpha:nil];
    UIColor* secondaryTransparent = [UIColor colorWithRed:sR green:sG blue:sB alpha:0];
    
    
    if (self.simpleMode)
    {
        //// Gradient Declarations
        NSArray* primaryGradientColors = [NSArray arrayWithObjects:
                                          (id)primary.CGColor,
                                          (id)primaryTransparent.CGColor, nil];
        CGFloat primaryGradientLocations[] = {0, 1};
        CGGradientRef primaryGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)primaryGradientColors, primaryGradientLocations);
        
        //// Frames
        CGRect frame = CGRectMake(0, 0, 100, 100);
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 100, 100)];
        [secondary setFill];
        [rectanglePath fill];
        [primaryTransparent setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
        
        
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-31.5, -87.5, 375, 375)];
        CGContextSaveGState(context);
        [ovalPath addClip];
        CGContextDrawRadialGradient(context, primaryGradient,
                                    CGPointMake(156, 100), 0,
                                    CGPointMake(156, 100), 196.93,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-244.5, -259.5, 375, 375)];
        CGContextSaveGState(context);
        [oval2Path addClip];
        CGContextDrawRadialGradient(context, primaryGradient,
                                    CGPointMake(-57, -72), 0,
                                    CGPointMake(-57, -72), 196.93,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Cleanup
        CGGradientRelease(primaryGradient);
        CGColorSpaceRelease(colorSpace);
        
        return;
    }
    

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
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    
    //// Oval 2 Drawing
    CGRect oval2Rect = CGRectMake(CGRectGetMinX(frame) - 17, CGRectGetMinY(frame) - 337, 673, 673);
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: oval2Rect];
    CGContextSaveGState(context);
    [oval2Path addClip];
    CGFloat oval2ResizeRatio = MIN(CGRectGetWidth(oval2Rect) / 673, CGRectGetHeight(oval2Rect) / 673);
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(oval2Rect) + 0 * oval2ResizeRatio, CGRectGetMidY(oval2Rect) + 0 * oval2ResizeRatio), 0 * oval2ResizeRatio,
                                CGPointMake(CGRectGetMidX(oval2Rect) + 0 * oval2ResizeRatio, CGRectGetMidY(oval2Rect) + 0 * oval2ResizeRatio), 324.24 * oval2ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// ovalSecondary Drawing
    UIBezierPath* ovalSecondaryPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-188, -264, 1096, 1096)];
    CGContextSaveGState(context);
    [ovalSecondaryPath addClip];
    CGContextDrawRadialGradient(context, glowSecondary,
                                CGPointMake(360, 284), 0,
                                CGPointMake(360, 284), 528.04,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// ovalSecondary 3 Drawing
    CGRect ovalSecondary3Rect = CGRectMake(CGRectGetMinX(frame) - 491, CGRectGetMinY(frame) - 601, 909, 909);
    UIBezierPath* ovalSecondary3Path = [UIBezierPath bezierPathWithOvalInRect: ovalSecondary3Rect];
    CGContextSaveGState(context);
    [ovalSecondary3Path addClip];
    CGFloat ovalSecondary3ResizeRatio = MIN(CGRectGetWidth(ovalSecondary3Rect) / 909, CGRectGetHeight(ovalSecondary3Rect) / 909);
    CGContextDrawRadialGradient(context, glowSecondary,
                                CGPointMake(CGRectGetMidX(ovalSecondary3Rect) + 0 * ovalSecondary3ResizeRatio, CGRectGetMidY(ovalSecondary3Rect) + 0 * ovalSecondary3ResizeRatio), 0 * ovalSecondary3ResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalSecondary3Rect) + 0 * ovalSecondary3ResizeRatio, CGRectGetMidY(ovalSecondary3Rect) + 0 * ovalSecondary3ResizeRatio), 437.95 * ovalSecondary3ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Oval Drawing
    CGRect ovalRect = CGRectMake(CGRectGetMinX(frame) - 405, CGRectGetMinY(frame) - 264, 705, 705);
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: ovalRect];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGFloat ovalResizeRatio = MIN(CGRectGetWidth(ovalRect) / 705, CGRectGetHeight(ovalRect) / 705);
    CGContextDrawRadialGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(ovalRect) + 0 * ovalResizeRatio, CGRectGetMidY(ovalRect) + 0 * ovalResizeRatio), 0 * ovalResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalRect) + 0 * ovalResizeRatio, CGRectGetMidY(ovalRect) + 0 * ovalResizeRatio), 339.66 * ovalResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// ovalSecondary 2 Drawing
    CGRect ovalSecondary2Rect = CGRectMake(CGRectGetMinX(frame) - 447, CGRectGetMinY(frame) + 114, 909, 909);
    UIBezierPath* ovalSecondary2Path = [UIBezierPath bezierPathWithOvalInRect: ovalSecondary2Rect];
    CGContextSaveGState(context);
    [ovalSecondary2Path addClip];
    CGFloat ovalSecondary2ResizeRatio = MIN(CGRectGetWidth(ovalSecondary2Rect) / 909, CGRectGetHeight(ovalSecondary2Rect) / 909);
    CGContextDrawRadialGradient(context, glowSecondary,
                                CGPointMake(CGRectGetMidX(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio, CGRectGetMidY(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio), 0 * ovalSecondary2ResizeRatio,
                                CGPointMake(CGRectGetMidX(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio, CGRectGetMidY(ovalSecondary2Rect) + 0 * ovalSecondary2ResizeRatio), 437.95 * ovalSecondary2ResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Oval 3 Drawing
    CGRect oval3Rect = CGRectMake(CGRectGetMinX(frame) + 208, CGRectGetMinY(frame) + 355, 685, 685);
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
    CGRect rectangleRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, glowPrimary,
                                CGPointMake(CGRectGetMidX(rectangleRect), CGRectGetMaxY(rectangleRect)),
                                CGPointMake(CGRectGetMidX(rectangleRect), CGRectGetMinY(rectangleRect)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(glowPrimary);
    CGGradientRelease(glowSecondary);
    CGColorSpaceRelease(colorSpace);
}


@end
