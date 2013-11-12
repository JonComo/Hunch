//
//  JCCollectionView.h
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UICollectionViewCell *(^CellConfigure)(UICollectionViewCell *cell, NSIndexPath *indexPath);

@interface JCCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *cellName;

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellConfigure:(CellConfigure)cellConfigure;

@end