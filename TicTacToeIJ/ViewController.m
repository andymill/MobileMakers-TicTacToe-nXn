//
//  ViewController.m
//  TicTacToeIJ
//
//  Created by Andrew Miller on 1/15/16.
//  Copyright © 2016 MobileMakers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSMutableArray *buttonsArray;
@property (weak, nonatomic) IBOutlet UIView *view;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int n = 7;
    int m = 7;
    [self makeGridOfColumns:n andRows:m];
}

-(void)makeGridOfColumns:(int)n andRows:(int)m{
    int margin = 20;
    int scrnWidth = [[UIScreen mainScreen] bounds].size.width - 2 * margin;
    int scrnHeight = [[UIScreen mainScreen] bounds].size.height - 2 *  margin;
    int extent = MIN(scrnWidth, scrnHeight);
    int xPos = margin; // start value
    int topScreenOffset = 100;
    int yPos = margin + topScreenOffset;
    int btnWidth = extent / n - 1;
    int btnHeight = extent / m - 1;
    
    self.buttonsArray = [NSMutableArray new];
    for (int i = 0; i < n; i++){
        NSMutableArray *tempArr = [NSMutableArray new];
        for (int j = 0; j < m; j++){
            UIButton *btn = [self generateButton:btnWidth :btnHeight :[NSString stringWithFormat:@"%d%d",n,m]];
            btn.center = CGPointMake(xPos + i * (extent / n) + btnWidth / 2, yPos + j * (extent / m) + btnHeight / 2);
            
            [tempArr addObject:btn];
        }
        [self.buttonsArray addObject:tempArr];
    }
}

-(UIButton *)generateButton:(int)width :(int)height :(NSString*)name {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, width, height);
    [btn setBackgroundColor:[UIColor grayColor]];

    [self.view addSubview:btn];
    [btn addTarget:self
            action:@selector(onSelectTile:)
  forControlEvents:UIControlEventAllEvents];
 
    return btn;
}


// rowColumnDiagonalCheck

// updateMatrix

-(IBAction)onSelectTile:(UIButton *)sender{
    UIImage *image = [UIImage imageNamed:@"X"];
    [sender setImage:image forState:UIControlStateNormal];
}

@end
