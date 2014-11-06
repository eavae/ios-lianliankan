//
//  MainViewController.m
//  Chess
//
//  Created by liyu on 14/10/30.
//  Copyright (c) 2014年 liyu. All rights reserved.
//

#import "MainViewController.h"
#import "Cell.h"
#import "ChessBoard.h"
#import "Chess.h"

static NSString * const reuseIdentifier = @"cellID";

@interface MainViewController ()
@property (nonatomic, strong) ChessBoard *chessboard;
@property (nonatomic, weak) Chess *preChess;
@property (nonatomic, weak) UICollectionViewCell *preCell;
@end

@implementation MainViewController

- (ChessBoard *) chessboard {
    if (_chessboard == nil) {
        _chessboard = [[ChessBoard alloc] init];
    }
    return _chessboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [self rowsOfCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 0;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld", (long)[self.chessboard countOfChesses]);
    return [self.chessboard countOfChesses];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // make the cell's title the actual NSIndexPath value
    Chess *chess = [self.chessboard chessAtIndex:indexPath.row];
    NSString *title = chess.content;
    cell.label.text = title;
    return cell;
}

#pragma mark - private functions

- (UICollectionViewCell *)getCellWithIndexPath:(NSIndexPath *)index
{
    for (UICollectionViewCell* cell in [self.collectionView visibleCells]) {
        NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
        if (index.row == indexPath.row) {
            return cell;
        }
    }
    return nil;
}

#pragma mark - Touch Event

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Chess *chess = [self.chessboard chessAtIndex:indexPath.row];
    if (self.preChess != nil && self.preChess != chess) {
        // match the chess
        if ([self.chessboard canLinkedWithStartChess:chess endChess:self.preChess]) {
            NSLog(@"bingo");
            // hide both
            [[self getCellWithIndexPath:indexPath] setHidden:YES];
            [self.preCell setHidden:YES];
            chess.show = NO;
            self.preChess.show = NO;
            self.preChess = nil;
            self.preCell = nil;
        }
    } else {
        self.preChess = chess;
        self.preCell = [self getCellWithIndexPath:indexPath];
    }
    
//    NSLog(@"x:%ld,y:%ld", (long)chess.position.x, (long)chess.position.y);
//    NSLog(@"click");
}

@end
