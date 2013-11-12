//
//  HUHistoryCell.h
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUHistoryCell : UICollectionViewCell

@property (nonatomic, weak) NSDictionary *decision;
@property (weak, nonatomic) IBOutlet UIButton *buttonRemove;

@end
