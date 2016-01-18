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
    
    self.gridSize = 5;
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
    
    int minSum = 0;
    int maxSum = 0;
    for (NSMutableArray *obj in arr){
        int objSum = 0;
        for (NSNumber *element in obj){
            objSum = objSum + [element integerValue];
        }
        if (objSum > maxSum){
            maxSum = objSum;
        }
        if (objSum < minSum) {
            minSum = objSum;
        }
    }
    NSLog(@"winning maxSum is %d minSum %d", maxSum, minSum);
    NSMutableArray *debugginArr = arr;
    if (maxSum == gridSize || abs(minSum) == gridSize){
        return YES;
    } else {
        return NO;
    }
}

-(NSMutableArray *)colRowDiagStates:(NSMutableArray *)array{
    // given an nxn array return the sum of columns, rows and diagonals
    int arrLen = [array count];
    NSMutableArray *colRowDiagArray = [NSMutableArray array]; // [C1 C2 Cn... R1 R2 Rn... D1 D2] of len 2n + 2
    
    // check columns
    for (int i = 0; i < arrLen; i++){
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int j = 0; j < arrLen; j++){
            [tempArr addObject:[NSNumber numberWithInt:((Tile *)self.buttonsArray[i][j]).myState]];
        }
        [colRowDiagArray addObject:tempArr];
    }
    
    // check rows
    for (int j = 0; j < arrLen; j++){
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < arrLen; i++){
            [tempArr addObject:[NSNumber numberWithInt:((Tile *)self.buttonsArray[i][j]).myState]];
        }
        [colRowDiagArray addObject:tempArr];
        
    }
    
    // check diagonals
    NSMutableArray *dia1Arr = [NSMutableArray array];
    NSMutableArray *dia2Arr = [NSMutableArray array];
    for (int i = 0; i < arrLen; i++){
        [dia1Arr addObject:[NSNumber numberWithInt: ((Tile *)self.buttonsArray[i][i]).myState]];
        [dia2Arr addObject:[NSNumber numberWithInt: ((Tile *)self.buttonsArray[i][arrLen -1 - i]).myState]];
    }
    [colRowDiagArray addObject:dia1Arr];
    [colRowDiagArray addObject:dia2Arr];
    
    return colRowDiagArray;
}

-(void)computerMove:(NSMutableArray *)tileArr
                    withColRowDiagArr:(NSMutableArray *)colRowDiagArr
                      andGridSize:(int)gridSize
                     andIsXPlayer:(bool)isXPlayer {
    
    NSLog(@"its the computer's move...");
    
    // count the sets
    // if -2 do something if 2 do something
    // else random
    
    __block NSNumber * maxSum;
    __block NSNumber * minSum;
    __block NSNumber * arrIndexAtMax;
    __block NSNumber * posIndexAtMax;
    __block NSNumber * arrIndexAtMin;
    __block NSNumber * posIndexAtMin;
    [colRowDiagArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *sum = 0;
        for (NSNumber *val in obj){
            sum = [NSNumber numberWithInt:([sum integerValue] + [val integerValue])];
        }
        if ([sum integerValue] > [maxSum integerValue]){
            maxSum = sum;
            arrIndexAtMax = [NSNumber numberWithInt:idx];
            posIndexAtMax = [NSNumber numberWithInt:[obj indexOfObject:[NSNumber numberWithInt:0]]];
        }
        if ([sum integerValue] < [minSum integerValue]){
            minSum = sum;
            arrIndexAtMin = [NSNumber numberWithInt:idx];
            posIndexAtMin = [NSNumber numberWithInt:[obj indexOfObject:[NSNumber numberWithInt:0]]];
        }
    }];
    
    NSLog(@"minSum is %d, maxSum is %d", [minSum integerValue], [maxSum integerValue]);
    NSMutableArray * debuggingArr = colRowDiagArr;
    
    if (([maxSum integerValue] == gridSize - 1) || ([minSum integerValue] == -1 * gridSize + 1)){

        int arrIndex;
        int posIndex;
        if ([maxSum integerValue] == gridSize - 1){
            // block
            NSLog(@"blocking");
            arrIndex = [arrIndexAtMax integerValue];
            posIndex = [posIndexAtMax integerValue];
        } else if ([minSum integerValue] == -1 * gridSize + 1) {
            // win
            NSLog(@"trying to win");
            arrIndex = [arrIndexAtMin integerValue];
            posIndex = [posIndexAtMin integerValue];
        }
        NSLog(@"arrIndex is %d, posIndex %d", arrIndex, posIndex);
        
        if (arrIndex < gridSize){
            NSLog(@"1");
            [((Tile *)tileArr[arrIndex][posIndex]) onClickWithXPlayer:isXPlayer];
            
        } else if (arrIndex < gridSize * 2){
            NSLog(@"2");
            [((Tile *)tileArr[posIndex][abs(gridSize - arrIndex)]) onClickWithXPlayer:isXPlayer];
            
        } else if (arrIndex == gridSize * 2){
            NSLog(@"3");
            [((Tile *)tileArr[posIndex][posIndex]) onClickWithXPlayer:isXPlayer];
            NSLog(@"tile state is %d", ((Tile *)tileArr[posIndex][posIndex]).myState);
        } else if (arrIndex == gridSize * 2 + 1){
            NSLog(@"4");
            [((Tile *)tileArr[gridSize - posIndex - 1][gridSize - posIndex -1]) onClickWithXPlayer:isXPlayer];
        
        }
    } else {
        // make a random move
        NSLog(@"random");
        bool moveMade = NO;
        while (!moveMade){
            int rand1 = arc4random() % gridSize;
            int rand2 = arc4random() % gridSize;
            Tile *tempTile = ((Tile *)tileArr[rand1][rand2]);
            if (tempTile.myState == 0){
                [tempTile onClickWithXPlayer:isXPlayer];
                moveMade = YES;
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
    NSMutableArray *colRowDiagStates = [self colRowDiagStates:self.buttonsArray];
    bool isWinner = [self isWinnerWithArray:colRowDiagStates withGridSize:self.gridSize];
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
    [self computerMove:self.buttonsArray
                       withColRowDiagArr:colRowDiagStates
                         andGridSize:self.gridSize
                        andIsXPlayer:NO];
    
    colRowDiagStates = [self colRowDiagStates:self.buttonsArray];
    isWinner = [self isWinnerWithArray:colRowDiagStates withGridSize:self.gridSize];
    
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
