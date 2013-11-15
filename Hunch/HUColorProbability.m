//
//  HUColorProbability.m
//  Hunch
//
//  Created by Jon Como on 11/15/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUColorProbability.h"

#define USER_COLOR @"userColor"

#define WINNING_COLOR @"winningColor"

@implementation HUColorProbability

+(void)setUserColors:(NSArray *)colors
{
    [colors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [HUColorProbability saveColor:obj forKey:[NSString stringWithFormat:@"%@%lu", USER_COLOR, (unsigned long)idx]];
    }];
    
    [HUColorProbability setRandomWinningColor];
}

+(void)saveColor:(UIColor *)color forKey:(NSString *)key
{
    //save
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:key];
}

+(UIColor *)colorFromKey:(NSString *)key
{
    //retrieve
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}

+(NSArray *)userColors
{
    NSMutableArray *colors = [NSMutableArray array];
    
    for (int i = 0; i<2; i++)
    {
        UIColor *color = [HUColorProbability colorFromKey:[NSString stringWithFormat:@"%@%i", USER_COLOR, i]];
        if (!color)
        {
            colors = nil;
            break;
        }else{
            [colors addObject:color];
        }
    }
    
    if (!colors){
        //make random colors
        colors = @[[UIColor colorWithRed:1.000 green:0.251 blue:0.000 alpha:1.000], [UIColor colorWithRed:0.980 green:0.757 blue:0.004 alpha:1.000]];
        [HUColorProbability setUserColors:colors];
    }
    
    return colors;
}

+(UIColor *)winningColor
{
    return [HUColorProbability colorFromKey:WINNING_COLOR];
}

+(void)setRandomWinningColor
{
    NSArray *colors = [HUColorProbability userColors];
    
    //Determne winning color
    UIColor *winningColor = colors[arc4random()%colors.count];
    [HUColorProbability saveColor:winningColor forKey:WINNING_COLOR];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(float)randomFloat
{
    return (float)(arc4random()%100)/100.0f;
}

+(UIColor *)randomColor
{
    float r = [HUColorProbability randomFloat]*0.8;
    float g = [HUColorProbability randomFloat]*0.8;
    float b = [HUColorProbability randomFloat]*0.8;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
