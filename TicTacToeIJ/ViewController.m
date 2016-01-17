//
//  ViewController.m
//  TicTacToeIJ
//
//  Created by Andrew Miller on 1/15/16.
//  Copyright © 2016 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "Tile.h"

@interface ViewController ()
@property NSMutableArray *buttonsArray;
@property (weak, nonatomic) IBOutlet UIView *view;
@property int movesMade;
@property int gridSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridSize = 3;
    self.movesMade = 0;
    [self makeGridOfColumns:self.gridSize andRows:self.gridSize];
}

-(void)makeGridOfColumns:(int)n andRows:(int)m{
    int margin = 20;
    int scrnWidth = [[UIScreen mainScreen] bounds].size.width - 2 * margin;
    int scrnHeight = [[UIScreen mainScreen] bounds].size.height - 2 *  margin;
    int extent = MIN(scrnWidth, scrnHeight);
    int xPos = margin; // start value
    int topScreenOffset = 100;
    int yPos = margin + topScreenOffset;
    int borderWidth = 1;
    int btnWidth = extent / n - borderWidth;
    int btnHeight = extent / m - borderWidth;
    
    self.buttonsArray = [NSMutableArray new];
    for (int i = 0; i < n; i++){
        NSMutableArray *tempArr = [NSMutableArray new];
        for (int j = 0; j < m; j++){
            Tile *btn = [self generateButton:btnWidth :btnHeight :[NSString stringWithFormat:@"%d%d",n,m]];
            btn.center = CGPointMake(xPos + i * (extent / n) + btnWidth / 2, yPos + j * (extent / m) + btnHeight / 2);
            btn.i = i;
            btn.j = j;
            btn.myState = 0; // 0 empty; 1 you; -1 opponent
            [tempArr addObject:btn];
        }
        [self.buttonsArray addObject:tempArr];
    }
}


-(Tile *)generateButton:(int)width :(int)height :(NSString*)name {
    Tile * btn = [Tile buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, width, height);
    [btn setBackgroundColor:[UIColor grayColor]];

    [self.view addSubview:btn];
    [btn addTarget:self
            action:@selector(onSelectTile:)
  forControlEvents:UIControlEventTouchUpInside];
 
    return btn;
}

-(bool)isWinnerWithArray:(NSMutableArray *)arr withGridSize:(int)gridSize{
    int max = [[arr valueForKeyPath:@"@max.intValue"] intValue];
    
    if (max == gridSize){
        return YES;
    } else {
        return NO;
    }
}

-(NSMutableArray *)sumRowsColumnsAndDiagonals:(NSMutableArray *)array{
    // given an nxn array return the sum of columns, rows and diagonals
    int arrLen = [array count];
    NSMutableArray *storeSumsArray = [NSMutableArray array]; // [V1 V2 V3... H1 H2 H3... D1 D2]
    
    // check columns
    for (int i = 0; i < arrLen; i++){
        int colSum = 0;
        for (int j = 0; j < arrLen; j++){
            colSum = colSum + ((Tile *)self.buttonsArray[i][j]).myState;
        }
        [storeSumsArray addObject:[NSNumber numberWithInt:colSum]];
    }
    
    // check rows
    for (int j = 0; j < arrLen; j++){
        int rowSum = 0;
        for (int i = 0; i < arrLen; i++){
            rowSum = rowSum + ((Tile *)self.buttonsArray[i][j]).myState;
        }
        [storeSumsArray addObject:[NSNumber numberWithInt:rowSum]];
        
    }
    
    // check diagonals
    int dia1Sum = 0;
    int dia2Sum = 0;
    for (int i = 0; i < arrLen; i++){
        dia1Sum = dia1Sum + ((Tile *)self.buttonsArray[i][i]).myState;
        dia2Sum = dia2Sum + ((Tile *)self.buttonsArray[i][arrLen -1 - i]).myState;
    }
    [storeSumsArray addObject:[NSNumber numberWithInt:dia1Sum]];
    [storeSumsArray addObject:[NSNumber numberWithInt:dia2Sum]];
    
    return storeSumsArray;
}

-(void)makeBestMoveWithTilesArray:(NSMutableArray *)tileArr
                    andWithSumArr:(NSMutableArray *)sumArr
                      andGridSize:(int)gridSize
                     andIsXPlayer:(bool)isXPlayer {
    
    // use closure to find highest value play in columnRowDiagnoal matrix
    __block NSUInteger maxIndex;
    __block NSNumber* maxValue = [NSNumber numberWithFloat:0];
    __block NSUInteger minIndex;
    __block NSNumber* minValue = [NSNumber numberWithFloat:0];
    [sumArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj > maxValue) {
            maxValue = obj;
            maxIndex = idx;
        }
        if (obj < minValue) {
            minValue = obj;
            minIndex = idx;
        }
    }];
    NSMutableArray *debuggingArray = sumArr; 
    NSLog(@"%tu", maxIndex);
    
    // can I win?
    
    // can I block
    
    // random
    
    // until a move is made, identify the highest value column, row, or diagonal and search it for first empty tile
    bool isMoveMade = NO; // while loop break condition
    for (int i = 0; i < gridSize - 1; i++){
        if (!isMoveMade){
            if (maxIndex < gridSize){
                // columns
                Tile *tile = ((Tile *)tileArr[maxIndex][i]);
                if (tile.myState == 0 ) {
                    // make move
                    [tile onClickWithXPlayer:isXPlayer];
                    isMoveMade = YES;
                }
            } else if (maxIndex < gridSize * 2){
                // rows
                Tile *tile = ((Tile *)tileArr[i][maxIndex-gridSize]);
                if (tile.myState == 0) {
                    // make move
                    [tile onClickWithXPlayer:isXPlayer];
                    isMoveMade = YES;
                }
            } else if (maxIndex == gridSize * 2){
                // d1
                Tile *tile = ((Tile *)tileArr[i][gridSize - i - 1]);
                if (tile.myState == 0) {
                    // make move
                    [tile onClickWithXPlayer:isXPlayer];
                    isMoveMade = YES;
                }
            } else if (maxIndex == gridSize * 2 + 1){
                // d1
                Tile *tile = ((Tile *)tileArr[gridSize - i - 1][i]);
                if (tile.myState == 0)  {
                    // make move
                    [tile onClickWithXPlayer:isXPlayer];
                    isMoveMade = YES;
                }
            } else {
                for (int j = 0; j < gridSize - 1; j++){
                    Tile *tile = ((Tile *)tileArr[gridSize - i - 1][i]);
                    if (tile.myState == 0)  {
                        // make move
                        [tile onClickWithXPlayer:isXPlayer];
                        isMoveMade = YES;
                    }
                }
            }
        }
    }
}

-(void)restartGame{
    [self makeGridOfColumns:self.gridSize andRows:self.gridSize];
    self.movesMade = 0;
    NSLog(@"%d", self.movesMade);
}


-(IBAction)onSelectTile:(Tile *)sender{

    // player
    [sender onClickWithXPlayer:YES]; // use X image
    NSMutableArray *scoresArr = [self sumRowsColumnsAndDiagonals:self.buttonsArray];
    bool isWinner = [self isWinnerWithArray:scoresArr withGridSize:self.gridSize];
    if (isWinner){
      
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You won!"
                                                                                 message:@"Play Again?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *restart = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:restart];
        [self presentViewController:alertController animated:YES completion:^{
            [self restartGame];
        }];

    } else if (self.movesMade == pow(self.gridSize, 2)){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tie"
                                                                                 message:@"Play Again?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *restart = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:restart];
        [self presentViewController:alertController animated:YES completion:^{
            [self restartGame];
        }];
    }
    
    self.movesMade++;
    
    // computer
    [self makeBestMoveWithTilesArray:self.buttonsArray
                       andWithSumArr:scoresArr
                         andGridSize:self.gridSize
                        andIsXPlayer:NO];
    scoresArr = [self sumRowsColumnsAndDiagonals:self.buttonsArray];
    isWinner = [self isWinnerWithArray:scoresArr withGridSize:self.gridSize];
    
    if (isWinner){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You lost, foo!"
                                                                                 message:@"Play Again?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *restart = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:restart];
        [self presentViewController:alertController animated:YES completion:^{
            [self restartGame];
        }];
        
    } else if (self.movesMade == pow(self.gridSize, 2)){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tie"
                                                                                 message:@"Play Again?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *restart = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:restart];
        [self presentViewController:alertController animated:YES completion:^{
            [self restartGame];
        }];
    }
    
    self.movesMade++;
    
}


@end
