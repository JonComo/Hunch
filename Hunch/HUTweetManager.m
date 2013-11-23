//
//  HUTweetManager.m
//  Hunch
//
//  Created by Jon Como on 11/23/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "HUTweetManager.h"

#import "HUAppDelegate.h"

@import Social;

@implementation HUTweetManager

+(void)composeTweetWithDecision:(NSDictionary *)decision
{
    NSString *winning = decision[@"FINAL"];
    NSString *losing;
    
    if ([winning isEqualToString:decision[@"A"]])
    {
        losing = decision[@"B"];
    }else{
        losing = decision[@"A"];
    }
    
    SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *message = [NSString stringWithFormat:@"I picked %@ over %@! itunes.com/apps/YouPick", winning, losing];
    
    [compose setInitialText:message];
    
    HUAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.window.rootViewController presentViewController:compose animated:YES completion:nil];
}

@end