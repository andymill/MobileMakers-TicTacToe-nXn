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
@property bool isFirstPlayer;
@property bool isPlayAgainstComputer;
@property int gridSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstPlayer = YES; // start game with first player
    self.isPlayAgainstComputer = NO;
    
    self.gridSize = 3;
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
            btn.tileState = 0; // 0 empty; 1 you; -1 opponent
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


-(BOOL)sumRowsColumnsAndDiagonals:(NSMutableArray *)array{
    // given an nxn array return the sum of columns, rows and diagonals
    
    int arrLen = [array count];
    NSLog(@"%d", arrLen); 
    
    // check columns
    for (int i = 0; i < arrLen; i++){
        int colSum = 0;
        for (int j = 0; j < arrLen; j++){
            colSum = colSum + ((Tile *)self.buttonsArray[i][j]).tileState;
        }
        if (colSum == arrLen){
            return YES;
        }
    }
    
    // check rows
    for (int j = 0; j < arrLen; j++){
        int rowSum = 0;
        for (int i = 0; i < arrLen; i++){
            rowSum = rowSum + ((Tile *)self.buttonsArray[i][j]).tileState;
        }
        if (rowSum == arrLen){
            return YES;
        }
    }
    
    // check diagonals
    int dia1Sum = 0;
    int dia2Sum = 0;
    for (int i = 0; i < arrLen; i++){
        dia1Sum = dia1Sum + ((Tile *)self.buttonsArray[i][i]).tileState;
        dia2Sum = dia2Sum + ((Tile *)self.buttonsArray[i][arrLen -1 - i]).tileState;
    }
    if (dia1Sum == arrLen || dia2Sum == arrLen){
        return YES;
    }

    return NO;
}


-(IBAction)onSelectTile:(Tile *)sender{
    // first player
    if (self.isFirstPlayer){
        
        UIImage *image = [[UIImage imageNamed:@"X"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:image forState:UIControlStateNormal];
                sender.tileState = 1;
        bool isWinner = [self sumRowsColumnsAndDiagonals:self.buttonsArray];
        if (isWinner){
          
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You won!"
                                                                                     message:@"Play Again?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *restart = [UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:restart];
            [self presentViewController:alertController animated:YES completion:^{
                [self makeGridOfColumns:self.gridSize andRows:self.gridSize];
            }];

        }
        self.isFirstPlayer = NO;
        
    } else if (self.isPlayAgainstComputer){
        // implement computer logic here
        // can I block?
        // can I be strategic
        // pick random
    }
    else{
        UIImage *image = [[UIImage imageNamed:@"O"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:image forState:UIControlStateNormal];
        sender.tileState = -1;
        self.isFirstPlayer = YES; 
    }
}

@end
