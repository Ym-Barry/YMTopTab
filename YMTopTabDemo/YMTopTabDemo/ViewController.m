//
//  ViewController.m
//  YMTopTabDemo
//
//  Created by YmWw on 2017/8/7.
//  Copyright © 2017年 Barrybarry. All rights reserved.
//

#import "ViewController.h"
#import "YMTopTab.h"

@interface ViewController ()<YMTopTabDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YMTopTab *topTab;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    YMTopTab *tab = [[YMTopTab alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    tab.titles = @[@"推荐", @"视频", @"NBA", @"法律节目",@"头条", @"关注", @"CBA", @"足球"];
    tab.selectedFont = [UIFont systemFontOfSize:18.0];
    tab.delegate = self;
    tab.style = BIGGER;
    [self.view addSubview:tab];
    
    self.topTab = tab;
    
    self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor grayColor], [UIColor redColor], [UIColor greenColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20 + tab.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - tab.frame.size.height)];
    scrollView.contentSize = CGSizeMake(8 * self.view.frame.size.width, scrollView.frame.size.height);
    for (int i = 0; i < 8; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(i * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        view.backgroundColor = self.colors[i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
        [label setFont:[UIFont systemFontOfSize:40]];
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:tab.titles[i]];
        [view addSubview:label];
        [scrollView addSubview:view];
        
    }
    scrollView.pagingEnabled = YES;
    
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    self.topTab.adpotScrollView = scrollView;
}

- (void)didSelecteItemAtIndex:(NSUInteger)index title:(NSString *)title {
    
    NSLog(@"didSelectItemAtIndex = %ld,title = %@", index, title);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.topTab adpatScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.topTab adpatScrollViewDidEndScroll:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
