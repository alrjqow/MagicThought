//
//  MTDelegateTableCollectionViewCell.m
//  8kqw
//
//  Created by 王奕聪 on 2017/8/31.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateTableCollectionViewCell.h"
#import "Masonry.h"

@interface MTDelegateTableCollectionViewCell()

{
    UICollectionView* _collectionView;
}


@end

@implementation MTDelegateTableCollectionViewCell


-(UICollectionView *)collectionView
{
    if(!_collectionView && _collectionViewLayout)
    {
        UICollectionView* view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
        view.contentInset = UIEdgeInsetsMake(12, 15, 12, 15);
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        view.dataSource = self;
        
        _collectionView = view;
    }

    return _collectionView;
}

-(void)setCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout
{
    _collectionViewLayout = collectionViewLayout;
    
    if(_collectionView) return;
    
    [self addSubview:self.collectionView];
    
    __weak typeof (self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}



@end
