//
//  ChessBoard.m
//  Chess
//
//  Created by liyu on 14/10/30.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import "ChessBoard.h"
#import "Chess.h"

#import "NSValue+Position.h"

@interface NSArray (Random)

- (id)randomItem;

@end

@implementation NSArray (Random)

- (id)randomItem
{
    return [self objectAtIndex:arc4random() % [self count]];
}

@end

@interface NSMutableArray (Random)

- (void)mixItem;

@end

@implementation NSMutableArray (Random)

- (void)mixItem
{
    NSInteger len = [self count];
    for (NSInteger i=0; i<len; i++) {
        [self exchangeObjectAtIndex:arc4random()%len withObjectAtIndex:arc4random()%len];
    }
}

@end

@interface ChessBoard()

@property (nonatomic) NSInteger maxColumn;
@property (nonatomic) NSInteger maxRow;

@end


@implementation ChessBoard

- (ChessBoard *)initWithMaxColumn:(NSInteger)column MaxRow:(NSInteger)row
{
    self.maxColumn = column;
    self.maxRow = row;
    return [self init];
}

#pragma mark - Private Function

- (NSMutableArray*) randomItemsWithCategary:(NSString*) categary capacity:(NSInteger) capacity
{
    NSString *path = [[NSBundle mainBundle] pathForResource:categary ofType:@"plist"];
    NSArray *baseItems = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSAssert(!(capacity%2), @"capacity must be divided by 2");
    
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:capacity];
    for (NSInteger i=0; i<capacity; i+=2) {
        NSString *content = [baseItems randomItem];
        [result insertObject:content atIndex:i];
        [result insertObject:content atIndex:i+1];
    }
    [result mixItem];
    return result;
}

// origin is top left
- (NSMutableArray*)items {
    if (_items == nil) {
        NSMutableArray *source = [self randomItemsWithCategary:@"emoji-people" capacity:self.maxRow*self.maxColumn];
        _items = [[NSMutableArray alloc] initWithCapacity: self.maxColumn];
        NSInteger i = 0;
        Chess *chess;
        for (NSInteger x = 0; x < self.maxColumn; x++) {
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity: self.maxRow];
            for (NSInteger y = 0; y < self.maxRow; y++) {
                chess = [[Chess alloc] initWithContent:[source objectAtIndex:i] position:PositionMake(x+1, y+1)];
                [row insertObject:chess atIndex:y];
                i++;
            }
            [_items insertObject:row atIndex:x];
        }
    }
    return _items;
}

// 这里需要将大坐标系转换为小坐标系
- (Chess *) itemAtPositionWithX:(NSInteger) x Y: (NSInteger)y
{
    NSAssert(x >= 0, @"x should away > 0");
    NSAssert(y >= 0, @"y should away > 0");
    NSAssert(x < self.maxColumn + 2, @"x should away < maxColumn + 2");
    NSAssert(y < self.maxRow + 2, @"y should away < maxRow + 2");
    if ( x <= 0 || y <= 0 || x == self.maxColumn + 1 || y == self.maxRow + 1) {
        return nil;
    }
    NSMutableArray *row = [self.items objectAtIndex:x-1];
    return [row objectAtIndex:y-1];
}

- (NSInteger)countOfChesses{
    return self.maxRow * self.maxColumn;
}

- (Chess *) chessAtIndex: (NSInteger)index {
    NSInteger x = index % self.maxColumn,
    y = index / self.maxColumn;
    return [[self.items objectAtIndex:x] objectAtIndex:y];
}

- (BOOL)canLinkedWithStartChess:(Chess *) start endChess:(Chess *) end
{
    NSLog(@"%@-%@:%d", start.content, end.content, [start.content isEqualToString:end.content]);
    NSMutableArray *path;
    
    if (![start.content isEqualToString:end.content]) {
        return NO;
    }
    
    // 水平直接相连
    if (start.position.y == end.position.y) {
        NSMutableArray *path = [self linkHorizonWithStartPosition:start.position endPosition:end.position];
        if ([path count] > 0) {
            return YES;
        }
    }
    // 垂直直接相连
    if (start.position.x == end.position.x) {
        NSMutableArray *path = [self linkVerticalWithStartPosition:start.position endPosition:end.position];
        if ([path count] > 0) {
            return YES;
        }
        
    }
    
    // 1个拐角相连
    path = [self linkOneCornerWithStartPosition:start.position endPosition:end.position];
    if ([path count] > 0) {
        return YES;
    }
    
    // 2个拐角相连
    path = [self linkTwoCornerWithStartPosition:start.position endPosition:end.position];
    if ([path count] > 0) {
        return YES;
    }
    
    return NO;
}



- (NSMutableArray*)linkHorizonWithStartPosition:(Position) start endPosition:(Position)end
{
    NSMutableArray *pathes = [[NSMutableArray alloc] init];
    Chess *temp;
    // 将x小坐标存储在第1位
    if (start.x > end.x) {
        Position p = start;
        start = end;
        end = p;
    }
    
    NSInteger dx = end.x - start.x;
    [pathes addObject:[NSValue valueWithPosition:start]];
    [pathes addObject:[NSValue valueWithPosition:end]];
    // 不相邻
    if (dx != 1) {
        for (NSInteger i=start.x+1; i<end.x; i++) {
            temp = [self itemAtPositionWithX:i Y:start.y];
            if (temp!=nil && [temp isShow]) {
                [pathes removeAllObjects];
                break;
            } else {
                [pathes addObject:[NSValue valueWithPosition:temp.position]];
            }
        }
        
    }
    return pathes;
}

- (NSMutableArray*)linkVerticalWithStartPosition:(Position) start endPosition:(Position)end
{
    NSMutableArray *pathes = [[NSMutableArray alloc] init];
    Chess *temp;
    // 将y小坐标存储在第1位
    if (start.y > end.y) {
        Position p = start;
        start = end;
        end = p;
    }
    
    NSInteger dy = end.y - start.y;
    [pathes addObject:[NSValue valueWithPosition:start]];
    [pathes addObject:[NSValue valueWithPosition:end]];
    // 不相邻
    if (dy != 1) {
        for (NSInteger i=start.y+1; i<end.y; i++) {
            temp = [self itemAtPositionWithX:start.x Y:i];
            if (temp!=nil && [temp isShow]) {
                [pathes removeAllObjects];
                break;
            } else {
                [pathes addObject:[NSValue valueWithPosition:temp.position]];
            }
        }
        
    }
    return pathes;
}

- (NSMutableArray*)linkOneCornerWithStartPosition:(Position) start endPosition:(Position)end
{
    NSMutableArray *pathes = [[NSMutableArray alloc] init];
    Position corner;
    Chess *chess;
    // 将起始坐标移至左边，则另一点在右上(有bug)或右下
    if (start.x > end.x) {
        Position p = start;
        start = end;
        end = p;
    }
    
    corner = PositionMake(start.x, end.y);
    chess = [self itemAtPositionWithX:corner.x Y:corner.y];
    if (chess == nil || ![chess isShow]) {
        [pathes addObject:[NSValue valueWithPosition:start]];
        [pathes addObject:[NSValue valueWithPosition:end]];
        NSMutableArray *tempX = [self linkHorizonWithStartPosition:corner endPosition:end];
        NSMutableArray *tempY = [self linkVerticalWithStartPosition:start endPosition:corner];
        // 都可以连通
        if ([tempX count] > 0 && [tempY count] > 0) {
            [pathes addObject:[NSValue valueWithPosition:corner]];
        } else {
            [pathes removeAllObjects];
        }
    }
    // 上面的没有连通
    if ([pathes count] == 0) {
        corner = PositionMake(end.x, start.y);
        chess = [self itemAtPositionWithX:corner.x Y:corner.y];
        if (chess == nil || ![chess isShow]) {
            [pathes addObject:[NSValue valueWithPosition:start]];
            [pathes addObject:[NSValue valueWithPosition:end]];
            NSMutableArray *tempX = [self linkHorizonWithStartPosition:start endPosition:corner];
            NSMutableArray *tempY = [self linkVerticalWithStartPosition:corner endPosition:end];
            // 都可以连通
            if ([tempX count] > 0 && [tempY count] > 0) {
                [pathes addObject:[NSValue valueWithPosition:corner]];
            } else {
                [pathes removeAllObjects];
            }
        }
    }
    return pathes;
}

- (NSMutableArray*)linkTwoCornerWithStartPosition:(Position) start endPosition:(Position)end
{
    NSMutableArray *pathes = [[NSMutableArray alloc] init];
    Position corner;
    Chess *chess;
    NSInteger maxX = self.maxColumn + 2, maxY = self.maxRow + 2;
    
    // 向左检测
    for (NSInteger i = start.x-1; i >= 0; i --) {
        corner = PositionMake(i, start.y);
        chess = [self itemAtPositionWithX:corner.x Y:corner.y];
        // 没有棋子
        if (chess == nil || ![chess isShow]) {
            // 判断能否构成矩形
            NSMutableArray *temp = [self linkOneCornerWithStartPosition:corner endPosition:end];
            if ([temp count] != 0) {
                [pathes addObject:[NSValue valueWithPosition:start]];
                [pathes addObjectsFromArray:temp];
                return pathes;
            }
        }
        // 有棋子，不能连通，结束循环
        else {
            [pathes removeAllObjects];
            break;
        }
    }
    
    // 向上检测
    if ([pathes count] == 0) {
        for (NSInteger i = start.y - 1; i >= 0; i --) {
            corner = PositionMake(start.x, i);
            chess = [self itemAtPositionWithX:corner.x Y:corner.y];
            if (chess == nil || ![chess isShow]) {
                NSMutableArray *temp = [self linkOneCornerWithStartPosition:corner endPosition:end];
                if ([temp count] != 0) {
                    [pathes addObject:[NSValue valueWithPosition:start]];
                    [pathes addObjectsFromArray:temp];
                    return pathes;
                }
            }
            else {
                [pathes removeAllObjects];
                break;
            }
        }
    }
    
    // 向右检测
    if ([pathes count] == 0) {
        for (NSInteger i = start.x + 1; i < maxX; i ++) {
            corner = PositionMake(i, start.y);
            chess = [self itemAtPositionWithX:corner.x Y:corner.y];
            if (chess == nil || ![chess isShow]) {
                NSMutableArray *temp = [self linkOneCornerWithStartPosition:corner endPosition:end];
                if ([temp count] != 0) {
                    [pathes addObject:[NSValue valueWithPosition:start]];
                    [pathes addObjectsFromArray:temp];
                    return pathes;
                }
            }
            else {
                [pathes removeAllObjects];
                break;
            }
        }
    }
    
    // 向下检测
    if ([pathes count] == 0) {
        for (NSInteger i = start.y + 1; i < maxY; i ++) {
            corner = PositionMake(start.x, i);
            chess = [self itemAtPositionWithX:corner.x Y:corner.y];
            if (chess == nil || ![chess isShow]) {
                NSMutableArray *temp = [self linkOneCornerWithStartPosition:corner endPosition:end];
                if ([temp count] != 0) {
                    [pathes addObject:[NSValue valueWithPosition:start]];
                    [pathes addObjectsFromArray:temp];
                    return pathes;
                }
            }
            else {
                [pathes removeAllObjects];
                break;
            }
        }
    }
    return pathes;
}


//- (BOOL) checkXWithStartPosition:(struct Position) start endPosition:(struct Position) end
//{
//    NSInteger i = 0;
//    Chess *chess;
//    for (i = start.x; i != end.x; (i < end.x ? i++ : i--)) {
//        chess = [self itemAtPositionWithX:i Y:start.y];
//        if (chess != nil && [chess isShow]) {
//            return NO;
//        }
//    }
//    return YES;
//}


//- (BOOL) checkYWithStartPosition:(struct Position) start endPosition:(struct Position) end
//{
//    NSInteger i = 0;
//    Chess *chess;
//    for (i = start.y; i != end.y; (i < end.y ? i++ : i--)) {
//        chess = [self itemAtPositionWithX:start.x Y:i];
//        if (chess != nil && [chess isShow]) {
//            return NO;
//        }
//    }
//    return YES;
//}
//

//
//- (BOOL) checkLinkWithStartPosition:(struct Position) start endPosition:(struct Position) end
//{
//    Chess *chess;
//    // 将Y较小的换到首位，则另一点出现在下方或平行的位置
//    if (start.y > end.y) {
//        struct Position temp = start;
//        start = end;
//        end = temp;
//    }
//    //调用方法检查直接相连或者两条线相连的可能路径（横、竖、横竖）
//    if ([self checkYWithStartPosition:PositionMake(start.x ,start.y+1) endPosition:end] && [self checkXWithStartPosition:PositionMake(start.x, end.y) endPosition:end]) {
//        return YES;
//    }
//
//    //从P1先往左侧走，再往垂直方向，再水平方向检查三条线路径（横竖横）
//    for (NSInteger i = start.x - 1; i >= 0; i--) {
//        chess = [self itemAtPositionWithX:i Y:start.y];
//        if (chess != nil && [chess isShow]) {
//            break;
//        }
//        if ([self checkYWithStartPosition:PositionMake(i ,start.y+1) endPosition: end] &&
//            [self checkXWithStartPosition:PositionMake(i, end.y) endPosition:end]) {
//            return YES;
//        }
//    }
//
//    //从P1先往右侧走，再往垂直方向，再水平方向检查三条线路径（横竖横）
//    for (NSInteger i = start.x+1; i < self.maxRow+2; i++) {
//        chess = [self itemAtPositionWithX:i Y:start.y];
//        if (chess != nil && [chess isShow]) {
//            break;
//        }
//        if ([self checkYWithStartPosition:PositionMake(i, start.y+1) endPosition:end] &&
//            [self checkXWithStartPosition:PositionMake(i, end.y) endPosition:end]) {
//            return YES;
//        }
//    }
//
//    if (start.x > end.x) {
//        Position temp = start;
//        start = end;
//        end = temp;
//    }
//
//    if ([self checkXWithStartPosition:PositionMake(start.x+1, start.y) endPosition:end] &&
//        [self checkYWithStartPosition:PositionMake(end.x, start.y) endPosition:end]) {
//        return YES;
//    }
//
//    // up
//    for (NSInteger i = start.y-1; i >=0; i--) {
//        chess = [self itemAtPositionWithX:start.x Y:i];
//        if (chess != nil && [chess isShow]) {
//            break;
//        }
//        if ([self checkXWithStartPosition:PositionMake(start.x+1, i) endPosition:end] &&
//            [self checkYWithStartPosition:PositionMake(end.x, i) endPosition:end]) {
//            return YES;
//        }
//    }
//    // down
//    for (NSInteger i = start.y+1; i < self.maxColumn+2; i++) {
//        chess = [self itemAtPositionWithX:start.x Y:i];
//        if (chess != nil && [chess isShow]) {
//            break;
//        }
//        if ([self checkXWithStartPosition:PositionMake(start.x+1, i) endPosition:end] &&
//            [self checkYWithStartPosition:PositionMake(end.x, i) endPosition:end]) {
//            return YES;
//        }
//    }
//    return NO;
//}

@end
