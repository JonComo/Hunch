//
//  JCCollectionView.m
//  Hunch
//
//  Created by Jon Como on 11/12/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "JCCollectionView.h"

@interface JCCollectionView () <UICollectionViewDataSource>
{
    CellConfigure configure;
}

@end

@implementation JCCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellConfigure:(CellConfigure)cellConfigure
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Initialization code
        self.dataSource = self;
        
        configure = cellConfigure;
    }
    return self;
}

-(void)setCellName:(NSString *)cellName
{
    _cellName = cellName;
    
    [self registerNib:[UINib nibWithNibName:cellName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellName];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellName forIndexPath:indexPath];
    
    cell = configure(cell, indexPath);
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
