//
//  YMTopTab.m
//  Various-OC
//
//  Created by YmWw on 2017/7/25.
//  Copyright © 2017年 WangWei. All rights reserved.
//

#import "YMTopTab.h"
#import "YMTopTabCell.h"

#define BUTTON_PLUS 10

@interface YMTopTab()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL byendWidth;  // wether the total lenght of the titles byend the collectionview width
@property (nonatomic, assign) CGFloat notByendGap; // the lefted width divide the titles count
@property (nonatomic, assign) CGSize titleSize;


@property (nonatomic, assign) BOOL lastSelectedByTap;


@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, assign) CGFloat lastContentOffset;


@end

@implementation YMTopTab

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
      

        [self creatCollectionView];
        
        self.topGap = 5;
        self.bottomGap = 4;
        self.fillout = YES;
        
        self.normalFont = [UIFont systemFontOfSize:14.0f];
        self.selectedFont = [UIFont systemFontOfSize:14.0f];
        self.normalColor = [UIColor blackColor];
        self.selectedColor = [UIColor redColor];
        self.lastSelectedByTap = NO;
        self.style = BIGGER;
        self.sliderHeight = 3;
        self.scrollingChangFont = YES;
        
    }
    
    return self;
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    NSAssert(titles.count > 0, @"tittles must have at least one");
    
    NSString *title = titles.firstObject;
    CGSize titleSize =  [title sizeWithAttributes:@{NSFontAttributeName:self.selectedFont}];
    
    self.titleSize = titleSize;
    CGSize size = self.collectionView.frame.size;
    size.height = titleSize.height;
    
    [self calculateWidth];
 
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height + self.topGap + self.bottomGap + self.sliderHeight);
    
    [self setNeedsLayout];
    
    [self.collectionView reloadData];
}

- (void)setTopGap:(CGFloat)topGap {
    
    _topGap = topGap;
    
    if (self.titles.count > 0) {
        
        [self updateSelfFrame];
        [self.collectionView reloadData];
    }
}


- (void)setBottomGap:(CGFloat)bottomGap {
   
    _bottomGap = bottomGap;
    
    if (self.titles.count > 0) {
        
        [self updateSelfFrame];
        [self.collectionView reloadData];
    }
}

- (void)calculateWidth {
    
    CGFloat width = 0;
    
    for (NSString *title in self.titles) {
        
        CGSize titleSize =  [title sizeWithAttributes:@{NSFontAttributeName:self.selectedFont}];
        width += titleSize.width;
    }
    self.byendWidth =  width > self.collectionView.frame.size.width;
    
    
    UICollectionViewFlowLayout *flowLayout =  (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    if (!self.byendWidth && self.fillout == YES) {

        self.notByendGap = (self.collectionView.frame.size.width - width) / self.titles.count;
        
        flowLayout.minimumInteritemSpacing = 0;

        
    } else {
       
        flowLayout.minimumInteritemSpacing = 10;

        
    }
    

}

- (void)layoutSubviews {
   
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (void)creatCollectionView {
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing  = 0;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [collectionView registerClass:[YMTopTabCell class] forCellWithReuseIdentifier:@"YMTopTabCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    
    [self addSubview:collectionView];
}





#pragma  mark CollectionView Delegate and DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    YMTopTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMTopTabCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    
    [self setCellSelectedStatus:cell selected:self.selectedIndex == indexPath.row];
    if (indexPath.row == self.selectedIndex) {
        
        if (self.style != BIGGER) {
            
            CGRect rect  = cell.frame;
            CGFloat beginGap = 0;
            if (indexPath.row == 0 || indexPath.row == self.titles.count - 1) {
                beginGap = 2;
            }
            self.sliderView.frame = CGRectMake(cell.frame.origin.x + beginGap, self.frame.size.height - self.sliderHeight, rect.size.width - 2 *beginGap, self.sliderHeight);
            self.selectedIndex = self.selectedIndex;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.titles[indexPath.row];
    
    CGSize titleSize =  [title sizeWithAttributes:@{NSFontAttributeName:self.selectedFont}];
    

    if (self.byendWidth || self.fillout == NO) {
        

        return  CGSizeMake(titleSize.width + BUTTON_PLUS, titleSize.height);
        
    } else {
    
        return CGSizeMake(titleSize.width + self.notByendGap, collectionView.frame.size.height);
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setSelectedCellStatus:indexPath];
    self.lastSelectedByTap = YES;
    self.adpotScrollView.contentOffset = CGPointMake(indexPath.row * self.adpotScrollView.bounds.size.width, 0);

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    YMTopTabCell *cell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self setCellSelectedStatus:cell selected:NO];
}

- (void)setSelectedCellStatus:(NSIndexPath *)indexPath {
  
    if (!self.lastSelectedByTap) {
        
        YMTopTabCell *cell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        [self setCellSelectedStatus:cell selected:NO];
    }
    
    YMTopTabCell *cell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.selectedIndex = indexPath.row;
    [self setCellSelectedStatus:cell selected:YES];
    
    [self calculateMaskViewPositionWithIndexPath:indexPath];
    
}

- (CGRect)sliderFrameWithIndexPath:(NSIndexPath *)indexPath {
   
    
    YMTopTabCell *cell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.style != BIGGER) {
        
        CGRect rect  = cell.frame;
        CGFloat beginGap = 0;
        if (indexPath.row == 0 || indexPath.row == self.titles.count - 1) {
            beginGap = 2;
        }
        
        return CGRectMake(cell.frame.origin.x + beginGap, self.frame.size.height - self.sliderHeight, rect.size.width - 2 * beginGap, self.sliderHeight);
    }
    return CGRectZero;
}

- (void)calculateMaskViewPositionWithIndexPath:(NSIndexPath *)indexPath {
    
    YMTopTabCell *cell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.sliderView.frame = [self sliderFrameWithIndexPath:indexPath];
    }];
    
    
    CGPoint center =   [self convertPoint:cell.center fromView:self.collectionView];
    
    CGFloat maxScrollX = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
    
    CGFloat deltaX = center.x - self.bounds.size.width / 2;
    
    
    if (center.x > self.bounds.size.width  / 2) {
        
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + deltaX > maxScrollX ? maxScrollX : self.collectionView.contentOffset.x + deltaX, 0);
        }];
        
    } else if (center.x < self.bounds.size.width / 2) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + deltaX < 0 ? 0 : self.collectionView.contentOffset.x + deltaX, 0);
        }];
        
        
    }
}

- (void)setCellSelectedStatus:(YMTopTabCell *)cell selected:(BOOL)selected {
   
    if (selected) {
        
        cell.titleLabel.font = self.selectedFont;
        cell.titleLabel.textColor = self.selectedColor;
        
    } else {
    
        cell.titleLabel.font = self.normalFont;
        cell.titleLabel.textColor = self.normalColor;
    }
}

- (void)updateSelfFrame {
    
    if (self.style == BIGGER) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.titleSize.height + self.topGap + self.bottomGap);
        
        [self setNeedsLayout];
        
    } else {
    
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.titleSize.height + self.topGap + self.bottomGap + self.sliderHeight);
        
        [self setNeedsLayout];
    }
}

#pragma mark ---Setter and Getter
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
   
    _selectedIndex = selectedIndex;
    if ([self.delegate respondsToSelector:@selector(didSelecteItemAtIndex:title:)] && self.titles.count > 0) {
        
        
        [self.delegate didSelecteItemAtIndex:selectedIndex title:self.titles[_selectedIndex]];
    }
    
}

- (void)setStyle:(YMTopTabStyle)style {
   
    _style = style;
    
    if (style == SLIDER || style == BiGSLIDER) {
        
        if (!self.sliderView) {
            
            self.sliderView = [[UIView alloc] init];
            self.sliderView.backgroundColor = [UIColor redColor];
            [self.collectionView addSubview:self.sliderView];
            [self updateSelfFrame];
            [self setNeedsLayout];
        }
    } else {
       
        if (self.sliderView) {
            
            [self updateSelfFrame];
            [self.sliderView removeFromSuperview];
            self.sliderView = nil;
            [self setNeedsLayout];
        }
    }
}


- (void)adpatScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(self.lastSelectedByTap) {
        
        return;
    }
    
    CGFloat delX = scrollView.contentOffset.x - self.lastContentOffset;
    NSInteger nextSliderIndex = 0;
    if (delX > 0) {
        
        nextSliderIndex = self.selectedIndex  + 1;
        if (nextSliderIndex >= self.titles.count) {
            
            return;
        }
    } else if (delX < 0) {
        
        nextSliderIndex = self.selectedIndex  - 1;
        if (nextSliderIndex < 0) {
            
            return;
        }
    }
    
    CGRect sliderRect = [self sliderFrameWithIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    
    CGRect nextSliderRect = [self sliderFrameWithIndexPath:[NSIndexPath indexPathForRow:nextSliderIndex inSection:0]];
    
    CGFloat moveX = (nextSliderRect.origin.x - sliderRect.origin.x) *( fabs(scrollView.contentOffset.x - self.lastContentOffset) / scrollView.frame.size.width);
    self.sliderView.frame = CGRectMake(sliderRect.origin.x + moveX, sliderRect.origin.y, sliderRect.size.width, sliderRect.size.height);
    
    
    if (self.scrollingChangFont) {
        
        YMTopTabCell *nextCell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextSliderIndex inSection:0]];
        
        YMTopTabCell *cell = (YMTopTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        
        CGFloat moveFont = (self.selectedFont.pointSize - self.normalFont.pointSize) *( fabs(scrollView.contentOffset.x - self.lastContentOffset) / scrollView.frame.size.width);
        
        UIFont *font =  [UIFont fontWithName:self.selectedFont.fontName size:self.normalFont.pointSize + moveFont];
        nextCell.titleLabel.font = font;
        
        UIFont  *currentFont = [UIFont fontWithName:self.selectedFont.fontName size:self.selectedFont.pointSize - moveFont];
        cell.titleLabel.font = currentFont;
    }
}

- (void)adpatScrollViewDidEndScroll:(UIScrollView *)scrollView {
  
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.bounds.size.width;
    
    self.lastSelectedByTap = NO;

    [self setSelectedCellStatus:[NSIndexPath indexPathForRow:index inSection:0]];
    
    self.lastContentOffset = scrollView.contentOffset.x;
    
}

- (NSArray *)scrollColorWithScale:(CGFloat)scale {
   
    const CGFloat *normalComponents = CGColorGetComponents(self.normalColor.CGColor);
    const CGFloat *selectedComponents = CGColorGetComponents(self.selectedColor.CGColor);
    
    CGFloat deltaRed = selectedComponents[0] - normalComponents[0];
    CGFloat deltaGreen = selectedComponents[1] - normalComponents[1];
    CGFloat deltaBlue = selectedComponents[2] - normalComponents[2];
    
    UIColor *currentTitleColor = [UIColor colorWithRed:selectedComponents[0] - deltaRed * scale  green:selectedComponents[1] - deltaGreen * scale blue:selectedComponents[2] - deltaBlue * scale alpha:1];
    
    UIColor *nextTitleColor = [UIColor colorWithRed:normalComponents[0] + deltaRed * scale  green:normalComponents[1] + deltaGreen * scale blue:normalComponents[2] + deltaBlue * scale alpha:1];
    return  @[currentTitleColor, nextTitleColor];
    
    
}


@end
