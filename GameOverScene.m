//
//  GameOverScene.m
//  Void
//
//  Created by Donald Fung on 8/12/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

- (void)didMoveToView:(nonnull SKView *)view    {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    [self backGround];
    [self restartGame];
    
    [self backgroundMusic];
}

- (void)backGround {
    //BACKGROUND IMAGE
    SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"background2.png"];
    backgroundImage.size = self.frame.size;
    backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backgroundImage.name = @"background";
    backgroundImage.zPosition = .1;
    backgroundImage.physicsBody.dynamic = NO;
    [self addChild:backgroundImage];
    
    SKSpriteNode *background2Image = [SKSpriteNode spriteNodeWithImageNamed:@"foreground1.png"];
    background2Image.size = self.frame.size;
    background2Image.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background2Image.name = @"background2";
    background2Image.zPosition = .2;
    background2Image.physicsBody.dynamic = NO;
    [self addChild:background2Image];
}

- (void)backgroundMusic {
    //ADD BACKGROUND MUSIC
    
    NSString* resourcePathForSong = [[NSBundle mainBundle] resourcePath];
    resourcePathForSong = [resourcePathForSong stringByAppendingString:@"/Stealth Groover.mp3"];
    NSError* err;
    
    //Initialize our player pointing to the path to our resource
    self.audioGameOver = [[AVAudioPlayer alloc] initWithContentsOfURL:
                    [NSURL fileURLWithPath:resourcePathForSong] error:&err];
    
    if( err ){
        //bail!
        NSLog(@"Failed with reason: %@", [err localizedDescription]);
    }
    else{
        //set our delegate and begin playback
        self.audioGameOver.delegate = self;
        [self.audioGameOver play];
        self.audioGameOver.numberOfLoops = 50;
        self.audioGameOver.currentTime = 0;
        self.audioGameOver.volume = 1.0;
    }
}

- (void)gameOverMessage {

    
    SKLabelNode *label = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    label.text = @"Game Over!";
    label.fontColor = [SKColor whiteColor];
    label.fontSize = 35;
    label.zPosition = .3;
    label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    label.name = @"label";
    [self addChild:label];
}

- (void)tryAgainLabel {
    self.tryAgain = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    self.tryAgain.text = @"Retry";
    self.tryAgain.fontColor = [SKColor whiteColor];
    self.tryAgain.fontSize = 40;
    self.tryAgain.zPosition = .3;
    self.tryAgain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - ((self.frame.size.height))/4);
    self.tryAgain.name = @"tryAgain";

    [self addChild:self.tryAgain];
}


- (void)restartGame
{
    SKAction *restart = [SKAction sequence:@[
                                             
                                             [SKAction performSelector:@selector(gameOverMessage) onTarget:self],
                                             [SKAction waitForDuration: .1],
                                            [SKAction performSelector:@selector(tryAgainLabel) onTarget:self],
                                             ]];
    
    [self runAction:[SKAction repeatAction:restart count:1]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.scene];
        
        //  stores nodes at the point touched.
        
        NSArray *nodes = [self nodesAtPoint:touchLocation];
        
        for (int i = 0; i < nodes.count; i ++) {
            SKNode *node = [nodes objectAtIndex:i];
            if ([node.name  isEqual: @"tryAgain"]) {
                SKScene *newGame = [[GameScene alloc] initWithSize:self.size];
                SKTransition *doors = [SKTransition fadeWithDuration:.2];
                [self.view presentScene:newGame transition:doors];
                [self.audioGameOver stop];
            }
        }
    }
}
@end
