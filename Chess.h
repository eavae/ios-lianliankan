//
//  Chess.h
//  Chess
//
//  Created by liyu on 14/10/30.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "global.h"

@interface Chess : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) Position position;
@property (nonatomic) BOOL show;

- (struct Position)position;
- (id)initWithContent:(NSString *) content position:(struct Position) position;
- (BOOL) isShow;
@end
