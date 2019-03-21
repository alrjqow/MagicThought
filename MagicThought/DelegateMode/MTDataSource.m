//
//  MTDataSource.m
//  MonDaProject
//
//  Created by monda on 2018/6/15.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTDataSource.h"
#import "MTDelegateTableView.h"
#import "MTDelegateCollectionView.h"
#import "MTDelegatePickerView.h"
#import "MTDelegateCollectionViewCell.h"
#import "MTDelegateTableViewCell.h"
#import "MTDelegateTableViewCell.h"
#import "MTDelegateCollectionReusableView.h"
#import "MTDelegateHeaderFooterView.h"
#import "MJRefresh.h"
#import "MTDragCollectionView.h"

#import "NSObject+ReuseIdentifier.h"
#import "UIView+Frame.h"

@interface MTDelegateCollectionViewCell (Private)

@property (nonatomic,strong) NSObject* mt_data;

@end

@interface MTDelegateTableViewCell (Private)

@property (nonatomic,strong) NSObject* mt_data;

@end

@interface MTDelegateHeaderFooterView (Private)

@property (nonatomic,strong) NSObject* mt_data;

@end

@interface MTDelegateCollectionReusableView (Private)

@property (nonatomic,strong) NSObject* mt_data;

@end




#define MTEasyReuseIdentifier(id) [NSString stringWithFormat:@"mteasy_%@ReuseIdentifier",(id)]

#define MTEasyDefaultTableViewReuseIdentifier MTEasyReuseIdentifier(NSStringFromClass([MTDelegateTableViewCell class]))

#define MTEasyDefaultTableViewHeaderFooterReuseIdentifier MTEasyReuseIdentifier(NSStringFromClass([MTDelegateHeaderFooterView class]))

#define MTEasyDefaultCollectionViewReuseIdentifier MTEasyReuseIdentifier(NSStringFromClass([MTDelegateCollectionViewCell class]))

#define MTEasyDefaultCollectionViewHeaderFooterReuseIdentifier MTEasyReuseIdentifier(NSStringFromClass([MTDelegateCollectionReusableView class]))

@interface MTDataSource()

@property (nonatomic,weak) MTDelegateTableView* tableView;

@property (nonatomic,weak) MTDelegateCollectionView* collectionView;

@property (nonatomic,weak) MTDelegatePickerView* pickView;

@property (nonatomic,assign) NSInteger sectionCount;

@property (nonatomic,assign) BOOL isEmpty;

@property (nonatomic,strong) NSMutableDictionary* registerCellList;

@property (nonatomic,strong) NSMutableDictionary* registerSectionList;

@property (nonatomic,assign) UIEdgeInsets contentInset;

@property (nonatomic,assign) CGFloat preOffsetY;

@end



@implementation MTDataSource

/*-----------------------------------华丽分割线-----------------------------------*/

-(void)setCollectionView:(MTDelegateCollectionView *)collectionView
{
    _collectionView = collectionView;
    
    [collectionView registerClass:[MTDelegateCollectionViewCell class] forCellWithReuseIdentifier:MTEasyDefaultCollectionViewReuseIdentifier];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MTEasyDefaultCollectionViewHeaderFooterReuseIdentifier];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MTEasyDefaultCollectionViewHeaderFooterReuseIdentifier];
}

-(void)setDelegate:(id<MTDelegateProtocol,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate>)delegate
{
    _delegate = delegate;
    [self addMethod];
}

-(void)setTableView:(MTDelegateTableView *)tableView
{
    _tableView = tableView;
    
    [tableView registerClass:[MTDelegateTableViewCell class] forCellReuseIdentifier:MTEasyDefaultTableViewReuseIdentifier];
    [tableView registerClass:[MTDelegateHeaderFooterView class] forHeaderFooterViewReuseIdentifier:MTEasyDefaultTableViewHeaderFooterReuseIdentifier];
}

-(void)setDataList:(NSArray *)dataList
{
    BOOL isAllArr = YES;
    for(NSObject* obj in dataList)
    {
        if([obj isKindOfClass:[NSArray class]])
        continue;
        
        isAllArr = false;
        break;
    }
    
    self.sectionCount = isAllArr ? dataList.count : 1;
    self.isEmpty = !self.sectionCount;
    
    self.tableView.scrollEnabled = !(self.isEmpty && self.emptyData);

    if(self.isEmpty && self.emptyData)
    {
        if ((self.tableView.mj_header.state <= 1) && (self.tableView.mj_footer.state <= 1) ) {
        
            if(!UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset, UIEdgeInsetsZero))
                self.contentInset = self.tableView.contentInset;
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
    }
    else
    {
        if(UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset, UIEdgeInsetsZero) && !UIEdgeInsetsEqualToEdgeInsets(self.contentInset, UIEdgeInsetsZero))
            self.tableView.contentInset = self.contentInset;
    }
    
    
    _dataList = isAllArr ? dataList : @[dataList];
    
    if(!isAllArr && [dataList isKindOfClass:[NSMutableArray class]] && [self.collectionView isKindOfClass:[MTDragCollectionView class]])
        ((MTDragCollectionView*)self.collectionView).dragItems = (NSMutableArray*)dataList;
}

-(void)setSectionList:(NSArray *)sectionList
{
    BOOL isSingle = false;
    for(id obj in sectionList)
    {
        if([obj isKindOfClass:[NSArray class]])
        continue;
        
        isSingle = YES;
        break;
    }
    
    _sectionList = isSingle ? @[sectionList] : sectionList;
}

-(void)addMethod
{
    if(!self.pickView)
        return;
    SEL selector = @selector(pickerView:titleForRow:forComponent:);
    
    if(![self.delegate respondsToSelector:selector])
        class_addMethod([self.delegate class],selector,(IMP)mt_titleForRowAtIndexPath,"v@:@@@");
}

/*-----------------------------------华丽分割线-----------------------------------*/



-(NSObject*)getHeaderDataForSection:(NSInteger)section
{
    return [self getHeaderFooterDataForSection:section Index:0];
}

-(NSObject*)getFooterDataForSection:(NSInteger)section
{
    return [self getHeaderFooterDataForSection:section Index:1];
}


-(NSObject*)getHeaderFooterDataForSection:(NSInteger)section Index:(NSInteger)index
{
    if(index >= self.sectionList.count)
    return nil;
    
    NSArray* sectionData = self.sectionList[index];
    
    if(section >= sectionData.count)
    return nil;
    
    if(![sectionData[section] isKindOfClass:[NSObject class]])
    return nil;
    
    NSObject* data = sectionData[section];
    if([data.mt_reuseIdentifier isEqualToString:@"none"] && [data isKindOfClass:[NSString class]])
    data.mt_reuseIdentifier = (NSString*)data;
    
    return data;
}

/*-----------------------------------华丽分割线-----------------------------------*/

-(NSArray*)getSectionDataListForSection:(NSInteger)section
{
    NSArray* list;
    if(section >= self.sectionCount) return list;
    
    list = self.dataList[section];
    
    return [list isKindOfClass:[NSArray class]] ? list : nil;
}

-(NSObject*)getDataForIndexPath:(NSIndexPath*)indexPath
{
    if(self.isEmpty && self.emptyData)
    {
        if([self.emptyData.mt_reuseIdentifier isEqualToString:@"none"] && [self.emptyData isKindOfClass:[NSString class]])
        self.emptyData.mt_reuseIdentifier = (NSString*)self.emptyData;
        
        return self.emptyData;
    }
    
    NSArray* list = [self getSectionDataListForSection:indexPath.section];
    
    if(indexPath.row >= list.count)
    return nil;
    
    if(![list[indexPath.row] isKindOfClass:[NSObject class]])
    return nil;
    
    NSObject* data = list[indexPath.row];
    if([data.mt_reuseIdentifier isEqualToString:@"none"] && [data isKindOfClass:[NSString class]])
    data.mt_reuseIdentifier = (NSString*)data;
    
    return data;
}

-(void)setup3dTouch:(UIView*)view
{
    if(![self.delegate isKindOfClass:[UIViewController class]])
    return;
    
    UIViewController* vc = (UIViewController*)self.delegate;
    if ([vc respondsToSelector:@selector(traitCollection)]) {
        
        if ([vc.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            
            if (@available(iOS 9.0, *)) {
                if (vc.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    
                    [vc registerForPreviewingWithDelegate:(id)vc sourceView:view];
                }
            }
        }
    }
}
    
/*-----------------------------------华丽分割线-----------------------------------*/

#pragma mark - tableView数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.isEmpty && self.emptyData) ? 1 : self.sectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isEmpty && self.emptyData) ? 1 :  [self getSectionDataListForSection:section].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject* data = [self getDataForIndexPath:indexPath];
    
    NSString* identifier = MTEasyReuseIdentifier(data.mt_reuseIdentifier);
    MTDelegateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        Class c = NSClassFromString(data.mt_reuseIdentifier);
        if(![c.new isKindOfClass:[MTDelegateTableViewCell class]])
            cell = [tableView dequeueReusableCellWithIdentifier:MTEasyDefaultTableViewReuseIdentifier forIndexPath:indexPath];
        else
            cell = [[c alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self.delegate;
    cell.mt_data = [data isKindOfClass:[NSReuseObject class]] ? ((NSReuseObject*)data).data : data;
    
    if(data.mt_open3dTouch)
        [self setup3dTouch:cell];
    
    return cell;
}

#pragma mark - tableView代理

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.isEmpty && !self.emptyData.mt_headerEmptyShow)
    return nil;
    
    NSObject* item = [self getHeaderDataForSection:section];
    if(!item)
    return nil;
    
    NSString* identifier = MTEasyReuseIdentifier(item.mt_reuseIdentifier);
    MTDelegateHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if(!view)
    {
        Class c = NSClassFromString(item.mt_reuseIdentifier);
        if(![c.new isKindOfClass:[MTDelegateHeaderFooterView class]])
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MTEasyDefaultTableViewHeaderFooterReuseIdentifier];
        else
        view = [[c alloc] initWithReuseIdentifier:identifier];
    }
    
    view.mt_delegate = self.delegate;
    view.section = section;
    view.mt_data = item;
    
    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.isEmpty && self.emptyData)
    return nil;
    
    NSObject* item = [self getFooterDataForSection:section];
    if(!item)
    return nil;
    
    NSString* identifier = MTEasyReuseIdentifier(item.mt_reuseIdentifier);
    MTDelegateHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if(!view)
    {
        Class c = NSClassFromString(item.mt_reuseIdentifier);
        if(![c.new isKindOfClass:[MTDelegateHeaderFooterView class]])
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MTEasyDefaultTableViewHeaderFooterReuseIdentifier];
        else
        view = [[c alloc] initWithReuseIdentifier:identifier];
    }
    
    view.mt_delegate = self.delegate;
    view.section = section;
    view.mt_data = item;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.isEmpty && !self.emptyData.mt_headerEmptyShow)
    return 0.000001;
    
    NSObject* item = [self getHeaderDataForSection:section];
    
    return item.mt_itemHeight == 0 ? 0.000001 : item.mt_itemHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.isEmpty && self.emptyData)
    return 0.000001;
    
    NSObject* item = [self getFooterDataForSection:section];
    
    return item.mt_itemHeight == 0 ? 0.000001 : item.mt_itemHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEmpty && self.emptyData)
    {
        CGFloat offset = 0;
        if(self.emptyData.mt_headerEmptyShow)
        {
            NSObject* item = [self getHeaderDataForSection:indexPath.section];
            offset = 2 * item.mt_itemHeight;
        }        
        return self.emptyData.mt_itemHeight == 0 ? (tableView.height - offset) : self.emptyData.mt_itemHeight;
    }
    
    
    NSObject* data = [self getDataForIndexPath:indexPath];
    
    
    return data.mt_itemHeight == 0 ? ([data.mt_reuseIdentifier isEqualToString:@"MTTenScrollViewCell"] ? tableView.height : 0.000001) : data.mt_itemHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEmpty && self.emptyData)
    return;
    
    if([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark - collectionView数据源

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (self.isEmpty && self.emptyData) ? 1 : self.sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.isEmpty && self.emptyData) ? 1 :  [self getSectionDataListForSection:section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject* data = [self getDataForIndexPath:indexPath];
    NSObject* list = [self getSectionDataListForSection:indexPath.section];
    
    NSString* mt_reuseIdentifier = [list.mt_reuseIdentifier isEqualToString:@"none"] ? data.mt_reuseIdentifier : list.mt_reuseIdentifier;
    
    NSString* identifier = MTEasyReuseIdentifier(mt_reuseIdentifier);
    
    MTDelegateCollectionViewCell* cell;
    if(self.registerCellList[identifier])
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    else
    {
        Class class = NSClassFromString(mt_reuseIdentifier);
        if(![class.new isKindOfClass:[MTDelegateCollectionViewCell class]])
            return [collectionView dequeueReusableCellWithReuseIdentifier:MTEasyDefaultCollectionViewReuseIdentifier forIndexPath:indexPath];
        
        [collectionView registerClass:class forCellWithReuseIdentifier:identifier];
        MTDelegateCollectionViewCell* cell0 = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if(!cell0)
            return [collectionView dequeueReusableCellWithReuseIdentifier:MTEasyDefaultCollectionViewReuseIdentifier forIndexPath:indexPath];
        
        self.registerCellList[identifier] = identifier;
        cell = cell0;
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self.delegate;
    cell.mt_data = [data isKindOfClass:[NSReuseObject class]] ? ((NSReuseObject*)data).data : data;
    
    if(data.mt_open3dTouch)
        [self setup3dTouch:cell];
    
    return cell;
}

    
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MTDelegateCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MTEasyDefaultCollectionViewHeaderFooterReuseIdentifier forIndexPath:indexPath];
    
    if(self.isEmpty && self.emptyData)
    return view;
    
    NSObject* data = [kind isEqualToString:UICollectionElementKindSectionFooter] ? [self getFooterDataForSection:indexPath.section] :  [self getHeaderDataForSection:indexPath.section];
    if(!data)
    return view;
    
    
    NSString* mt_reuseIdentifier = data.mt_reuseIdentifier;
    NSString* identifier = MTEasyReuseIdentifier(mt_reuseIdentifier);
    
    
    if(self.registerSectionList[identifier])
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    else
    {
        Class class = NSClassFromString(mt_reuseIdentifier);
        if(![class.new isKindOfClass:[MTDelegateCollectionReusableView class]])
            return view;
        
        [collectionView registerClass:class forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
        
        MTDelegateCollectionReusableView* view0 = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if(!view0)
            return view;
        
        self.registerSectionList[identifier] = identifier;
        view = view0;
    }
    
    view.mt_delegate = self.delegate;
    view.section = indexPath.section;
    view.mt_data = data;
    
    return view;
}


#pragma mark - collectionView代理

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)])
       [self.delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    return [self.delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    
    
    if(self.isEmpty && self.emptyData)
    return UIEdgeInsetsZero;
    
    NSObject* item = [self getHeaderDataForSection:section];
    return item.mt_spacing.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
    return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    
    if(self.isEmpty && self.emptyData)
    return 0;
    
    NSObject* item = [self getHeaderDataForSection:section];
    return item.mt_spacing.minLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    
    if(self.isEmpty && self.emptyData)
    return 0;
    
    NSObject* item = [self getHeaderDataForSection:section];
    return item.mt_spacing.minItemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize zeroSize = CGSizeMake(0.000001, 0.000001);
    
    if(self.isEmpty && self.emptyData)
    return zeroSize;
    
    NSObject* item = [self getHeaderDataForSection:section];
    BOOL isZero = CGSizeEqualToSize(CGSizeZero, item.mt_itemSize);
    
    return isZero ? zeroSize : item.mt_itemSize;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize zeroSize = CGSizeMake(0.000001, 0.000001);
    
    if(self.isEmpty && self.emptyData)
    return zeroSize;
    
    NSObject* item = [self getFooterDataForSection:section];
    BOOL isZero = CGSizeEqualToSize(CGSizeZero, item.mt_itemSize);
    
    return isZero ? zeroSize : item.mt_itemSize;
}

#pragma mark - item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
        return [self.delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    
    CGSize zeroSize = CGSizeMake(0.000001, 0.000001);
    NSObject* data = [self getDataForIndexPath:indexPath];
    NSObject* list = [self getSectionDataListForSection:indexPath.section];
    
    CGSize itemSize = list.mt_itemSize;
    BOOL isZero = CGSizeEqualToSize(CGSizeZero, itemSize);
    if(isZero)
    {
        itemSize = data.mt_itemSize;
        isZero = CGSizeEqualToSize(CGSizeZero, itemSize);
    }
    
    if(self.isEmpty && self.emptyData)
    return isZero ? CGSizeMake(collectionView.width, collectionView.height - collectionView.contentInset.bottom) : itemSize;
    
    return isZero ? zeroSize : itemSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEmpty && self.emptyData)
    return;
    
    if([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
    [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}


#pragma mark - scrollView代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isKindOfClass:[MTDelegateTableView class]])
    {
        if(!self.preOffsetY)
            self.preOffsetY = scrollView.contentOffset.y;
        
        //向上滑
        [scrollView setValue:@(scrollView.contentOffset.y >= self.preOffsetY) forKey:@"isScrollTop"];
        
        self.preOffsetY = scrollView.contentOffset.y;
    }
    
    if([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
    [self.delegate scrollViewDidScroll:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    [self.delegate scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    [self.delegate scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - pickerView 数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.sectionCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self getSectionDataListForSection:component].count;
}

#pragma mark - pickerView 代理

static NSString* mt_titleForRowAtIndexPath(id self, SEL cmd, UIPickerView * pickerView, NSInteger row, NSInteger component) {
    if([pickerView isKindOfClass:[MTDelegatePickerView class]])
    {
        MTDelegatePickerView* pView = (MTDelegatePickerView*)pickerView;
        MTDataSource* dataSource = [pView valueForKey:@"mt_dataSource"];
        
        NSObject* data = [dataSource getDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:component]];
        return [data isKindOfClass:[NSString class]] ? (NSString*)data : @"";
    }
    
    return @"";
};

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
        [self.delegate pickerView:pickerView didSelectRow:row inComponent:component];
}

#pragma mark - 懒加载

-(NSMutableDictionary *)registerCellList
{
    if(!_registerCellList)
    {
        _registerCellList = [NSMutableDictionary dictionary];
    }
    
    return _registerCellList;
}

-(NSMutableDictionary *)registerSectionList
{
    if(!_registerSectionList)
    {
        _registerSectionList = [NSMutableDictionary dictionary];
    }
    
    return _registerSectionList;
}


@end





#pragma mark - 扩展类

@implementation MTDelegateCollectionViewCell (Private)

-(void)setMt_data:(NSObject *)mt_data
{
    if(![mt_data isKindOfClass:[NSObject class]])
    return;
    
    [self whenGetResponseObject:mt_data];
}

-(NSObject *)mt_data
{
    return nil;
}

@end

@implementation MTDelegateTableViewCell (Private)

-(void)setMt_data:(NSObject *)mt_data
{
    if(![mt_data isKindOfClass:[NSObject class]])
    return;
    
    [self whenGetResponseObject:mt_data];
}

-(NSObject *)mt_data
{
    return nil;
}

@end

@implementation MTDelegateHeaderFooterView (Private)

-(void)setMt_data:(NSObject *)mt_data
{
    if(![mt_data isKindOfClass:[NSObject class]])
    return;
    
    [self whenGetResponseObject:mt_data];
}

-(NSObject *)mt_data
{
    return nil;
}

@end

@implementation MTDelegateCollectionReusableView (Private)

-(void)setMt_data:(NSObject *)mt_data
{
    if(![mt_data isKindOfClass:[NSObject class]])
    return;
    
    [self whenGetResponseObject:mt_data];
}

-(NSObject *)mt_data
{
    return nil;
}

@end



