//
//  ViewController.m
//  Void
//
//  Created by Donald Fung on 8/9/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *) self.view;
    
    spriteView.showsDrawCount = NO;
    
    spriteView.showsNodeCount = NO;
    
    spriteView.showsFPS = NO;
    
}

- (void)viewWillAppear:(BOOL)animated


{

    SKView *spriteView = (SKView *) self.view;
    GameScene *gameScene = [[GameScene alloc]initWithSize:spriteView.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFit;
    [spriteView presentScene:gameScene];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
