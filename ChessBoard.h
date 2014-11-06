//
//  ChessBoard.h
//  Chess
//
//  Created by liyu on 14/10/30.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "global.h"

@class Chess;

@interface ChessBoard : NSObject

@property (nonatomic, strong) NSMutableArray *items;

- (ChessBoard*)initWithMaxColumn: (NSInteger)column MaxRow: (NSInteger)row;
- (NSInteger) countOfChesses;
- (Chess *) chessAtIndex: (NSInteger)index;
- (BOOL)canLinkedWithStartChess:(Chess *) start endChess:(Chess *) end;
@end
