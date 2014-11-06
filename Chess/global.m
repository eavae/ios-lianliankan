//
//  object.m
//  Chess
//
//  Created by liyu on 14/11/5.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import "global.h"

Position PositionMake(NSInteger x, NSInteger y)
{
    Position pos;
    pos.x = x;
    pos.y = y;
    return pos;
}