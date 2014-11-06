//
//  Cell.m
//  Chess
//
//  Created by liyu on 14/10/30.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import "Cell.h"
#import "CustomCellBackground.h"

@implementation Cell
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CustomCellBackground *background = [[CustomCellBackground alloc]initWithFrame:CGRectZero];
        self.selectedBackgroundView = background;
    }
    return self;
}
@end
