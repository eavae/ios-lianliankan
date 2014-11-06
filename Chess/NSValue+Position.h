//
//  NSValue+Position.h
//  Chess
//
//  Created by liyu on 14/11/5.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "global.h"

@interface NSValue (Position)

@property (readonly) Position positionValue;

+(instancetype)valueWithPosition:(Position)value;

@end
