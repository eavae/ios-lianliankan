//
//  NSValue+Position.m
//  Chess
//
//  Created by liyu on 14/11/5.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import "NSValue+Position.h"

@implementation NSValue (Position)

+ (instancetype)valueWithPosition:(Position)value
{
    return [self valueWithBytes:&value objCType:@encode(Position)];
}

- (Position) positionValue
{
    Position value;
    [self getValue:&value];
    return value;
}

@end
