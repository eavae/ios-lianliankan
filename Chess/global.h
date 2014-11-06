//
//  object.h
//  Chess
//
//  Created by liyu on 14/11/5.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import <Foundation/Foundation.h>

struct Position{
    NSInteger x;
    NSInteger y;
};
typedef struct Position Position;
Position PositionMake(NSInteger x, NSInteger y);
