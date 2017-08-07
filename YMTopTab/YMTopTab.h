//
//  YMTopTab.h
//  Various-OC
//
//  Created by YmWw on 2017/7/25.
//  Copyright © 2017年 WangWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMTopTabDelegate <NSObject>

- (void)didSelecteItemAtIndex:(NSUInteger)index title:(NSString *)title;

@end



typedef NS_ENUM(NSInteger, YMTopTabStyle) {
   
    BIGGER = 0,
    
    SLIDER = 1,
    
    BiGSLIDER = 2,
    
    
};



@interface YMTopTab : UIView
@property (nonatomic, strong) NSArray *titles;      //The showd titles

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign) CGFloat topGap;     // the gap between the title top and self top
@property (nonatomic, assign) CGFloat bottomGap;  // the gap between the title bottom and self bottom

@property (nonatomic, assign) YMTopTabStyle style;

/*
  wether the titles fill out all the width when the titles total length less then the width.  default YES
 */
@property (nonatomic, assign) BOOL fillout;

/*
 
 the space between the title.it does not work when fillout is YES.
 @default 10
 
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;


@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) CGFloat sliderHeight;

@property (nonatomic, assign) id<YMTopTabDelegate> delegate;

@property (nonatomic, assign) UIScrollView *adpotScrollView;
@property (nonatomic, assign) BOOL scrollingChangFont;

- (void)adpatScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)adpatScrollViewDidEndScroll:(UIScrollView *)scrollView;

@end
