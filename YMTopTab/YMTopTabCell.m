//
//  YMTopTabCell.m
//  Various-OC
//
//  Created by YmWw on 2017/7/25.
//  Copyright © 2017年 WangWei. All rights reserved.
//

#import "YMTopTabCell.h"

@implementation YMTopTabCell

- (instancetype)initWithFrame:(CGRect)frame {
  
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    
    }
    
    return self;
}

- (void)prepareForReuse {
   
    if (!self.titleLabel) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    }
    
}

@end
