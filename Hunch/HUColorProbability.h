//
//  HUColorProbability.h
//  Hunch
//
//  Created by Jon Como on 11/15/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUColorProbability : NSObject

+(void)setUserColors:(NSArray *)colors;
+(NSArray *)userColors;

+(UIColor *)winningColor;
+(void)setRandomWinningColor;

@end
