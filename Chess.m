//
//  Chess.m
//  Chess
//
//  Created by liyu on 14/10/30.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import "Chess.h"

@implementation Chess

- (struct Position)position
{
    return _position;
}

- (id)initWithContent:(NSString *) content position:(struct Position) position
{
    self.content = content;
    self.position = position;
    self.show = YES;
    return [super init];
}

- (BOOL) isShow
{
    return self.show;
}

@end
