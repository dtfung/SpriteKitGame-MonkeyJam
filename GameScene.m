//
//  GameScene.m
//  Void
//
//  Created by Donald Fung on 8/9/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

static const uint32_t missileCategory =  0x1 << 0;
static const uint32_t missileFromSkyCategory =  0x1 << 1;
static const uint32_t groundEnemyCategory =  0x1 << 2;
static const uint32_t enemyMissilesCategory = 0x1 << 3;
static const uint32_t playerCategory    =  0x1 << 4;
static const uint32_t birdEnemy1Category = 0x1 << 5;


static inline CGFloat skRandf() {
    
    return rand() / (CGFloat) RAND_MAX;
    
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    
    return skRandf() * (high - low) + low;
    
}

- (void)didMoveToView:(nonnull SKView *)view    {
    if (!self.contentCreated) {
        [self createSceneContents];
        
        self.contentCreated = YES;

    }
}

- (void)createSceneContents {
    
    self.dao = [DAO sharedManager];
    self.characters = self.dao.characterDatabase;
    

    
    [self backgroundMusic];
    [self newMainCharacter];
    
    [self enemyAnimations];
    self.groundLevelY = (self.frame.size.height) * .2;
    self.skyLevelY = (self.frame.size.height) * .8;
    
    [self createButtons];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    [self Background];
    [self scoreCounter];
    [self missileCountLabel];
    
}

- (void)Background {
    
    //BACKGROUND IMAGE
    self.backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"background2.png"];
    self.backgroundImage.size = self.frame.size;
    self.backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.backgroundImage.name = @"background";
    self.backgroundImage.zPosition = .1;
    self.backgroundImage.physicsBody.dynamic = NO;
    [self addChild:self.backgroundImage];
    
    self.backgroundImage2 = [SKSpriteNode spriteNodeWithImageNamed:@"foreground1.png"];
    self.backgroundImage2.size = self.frame.size;
    self.backgroundImage2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.backgroundImage2.name = @"background2";
    self.backgroundImage2.zPosition = .2;
    self.backgroundImage2.physicsBody.dynamic = NO;
    [self addChild:self.backgroundImage2];
    
}

- (void)backgroundMusic {
    //ADD BACKGROUND MUSIC
    self.sounds = [self.characters objectAtIndex:2];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [resourcePath stringByAppendingString:self.sounds.backgroundMusic];
    NSError* err;
    
    //Initialize our player pointing to the path to our resource
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
                        [NSURL fileURLWithPath:resourcePath] error:&err];
    
    if( err ){
        //bail!
        NSLog(@"Failed with reason: %@", [err localizedDescription]);
    }
    else{
        //set our delegate and begin playback
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
        self.audioPlayer.numberOfLoops = 50;
        self.audioPlayer.currentTime = 0;
        self.audioPlayer.volume = 1.0;
    }
}


- (SKSpriteNode *)newMainCharacter {
    
    self.player = [self.characters objectAtIndex:0];
    self.idleTexture1 = [SKTexture textureWithImageNamed:self.player.idle];
    self.idleTexture2 = [SKTexture textureWithImageNamed:self.player.idle2];
    self.runRightTexture1 = [SKTexture textureWithImageNamed:self.player.runRight1];
    self.runRightTexture2 = [SKTexture textureWithImageNamed:self.player.runRight2];
    self.runRightTexture3 = [SKTexture textureWithImageNamed:self.player.runRight3];
    self.runRightTexture4 = [SKTexture textureWithImageNamed:self.player.runRight4];
    self.runRightTexture5 = [SKTexture textureWithImageNamed:self.player.runRight5];
    self.runRightTexture6 = [SKTexture textureWithImageNamed:self.player.runRight6];
    self.runLeftTexture1 = [SKTexture textureWithImageNamed:self.player.runLeft1];
    self.runLeftTexture2 = [SKTexture textureWithImageNamed:self.player.runLeft2];
    self.runLeftTexture3 = [SKTexture textureWithImageNamed:self.player.runLeft3];
    self.runLeftTexture4 = [SKTexture textureWithImageNamed:self.player.runLeft4];
    self.runLeftTexture5 = [SKTexture textureWithImageNamed:self.player.runLeft5];
    self.runLeftTexture6 = [SKTexture textureWithImageNamed:self.player.runLeft6];
    self.throwLeftTexture1 = [SKTexture textureWithImageNamed:self.player.throwLeft1];
    self.throwLeftTexture2 = [SKTexture textureWithImageNamed:self.player.throwLeft2];
    self.throwRighttTexture1 = [SKTexture textureWithImageNamed:self.player.throwRight1];
    self.throwRightTexture2 = [SKTexture textureWithImageNamed:self.player.throwRight2];
    self.deadPlayer = [SKTexture textureWithImageNamed:self.player.dead];
    self.jumpRightTexture1 = [SKTexture textureWithImageNamed:self.player.jumpRight1];
    self.jumpRightTexture2 = [SKTexture textureWithImageNamed:self.player.jumpRight2];
    self.jumpRightTexture3 = [SKTexture textureWithImageNamed:self.player.jumpRight3];
    self.jumpLeftTexture1 = [SKTexture textureWithImageNamed:self.player.jumpLeft1];
    self.jumpLeftTexture2 = [SKTexture textureWithImageNamed:self.player.jumpLeft2];
    self.jumpLeftTexture3 = [SKTexture textureWithImageNamed:self.player.jumpLeft3];
    
    self.playerNode = [SKSpriteNode spriteNodeWithTexture:self.idleTexture1];
    //[self.playerNode CGSizeMake((self.frame.size.width)*.1, (self.frame.size.height)*.1)];
    self.playerNode.position = CGPointMake((self.frame.size.width)*.5, (self.frame.size.height)*.2);
    self.playerNode.zPosition = 1;
    [self.playerNode setScale:.4];
    
    
    
    self.playerNode.name = @"player";
    
    self.moveLeft = [SKAction moveByX:-25 y:0 duration:.1];
    self.moveRight = [SKAction moveByX:25 y:0 duration:.1];
    
    self.playerNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerNode.size];
    self.playerNode.physicsBody.categoryBitMask = playerCategory;
    self.playerNode.physicsBody.collisionBitMask = groundEnemyCategory | enemyMissilesCategory | missileFromSkyCategory;
    self.playerNode.physicsBody.contactTestBitMask = groundEnemyCategory | enemyMissilesCategory | missileFromSkyCategory;
    self.playerNode.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild: self.playerNode];
    
    return self.playerNode;
}


- (SKSpriteNode *)newGroundEnemy {
    
    self.groundEnemy = [self.characters objectAtIndex:1];
    self.groundEnemyTexture1 = [SKTexture textureWithImageNamed:self.groundEnemy.name1];
    self.groundEnemyTexture2 = [SKTexture textureWithImageNamed:self.groundEnemy.name2];
    
    self.groundEnemyNode = [SKSpriteNode spriteNodeWithTexture:self.groundEnemyTexture1];
    [self.groundEnemyNode setScale:.45];
    self.groundEnemyNode.zPosition = 1;
    self.groundEnemyNode.name = @"snake";
    
    self.groundEnemyNode.position = CGPointMake(self.frame.size.width,(self.frame.size.height) * .2);
    
    self.moveEnemyLeft = [SKAction moveByX:-25 y:0 duration:.15];
    
    [self addChild:self.groundEnemyNode];
    
    self.animateEnemy = [SKAction animateWithTextures:@[self.groundEnemyTexture1, self.groundEnemyTexture2] timePerFrame:.1];
    [self.groundEnemyNode runAction:[SKAction repeatActionForever:self.animateEnemy]];
    [self.groundEnemyNode runAction:[SKAction repeatActionForever:self.moveEnemyLeft]];
    
    self.groundEnemyNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.groundEnemyNode.size];
    self.groundEnemyNode.physicsBody.categoryBitMask = groundEnemyCategory;
    self.groundEnemyNode.physicsBody.collisionBitMask = playerCategory | missileCategory;
    self.groundEnemyNode.physicsBody.contactTestBitMask = playerCategory | missileCategory;
    self.groundEnemyNode.physicsBody.usesPreciseCollisionDetection = YES;
    
    return self.groundEnemyNode;
}

- (SKSpriteNode *)newGroundEnemyFromLeft {
    self.secondGroundEnemy= [self.characters objectAtIndex:7];
    SKTexture *snakeTextureOne = [SKTexture textureWithImageNamed:self.secondGroundEnemy.name1];
    SKTexture *snakeTextureTwo = [SKTexture textureWithImageNamed:self.secondGroundEnemy.name2];
    
    self.groundEnemyNodeSecond = [SKSpriteNode spriteNodeWithTexture:snakeTextureOne];
    [self.groundEnemyNodeSecond setScale:.45];
    self.groundEnemyNodeSecond.zPosition = 1;
    self.groundEnemyNodeSecond.name = @"snake2";
    
    self.groundEnemyNodeSecond.position = CGPointMake(0,(self.frame.size.height) * .2);
    
    SKAction *moveEnemyRight = [SKAction moveByX:25 y:0 duration:.15];
    
    [self addChild:self.groundEnemyNodeSecond];
    
    SKAction *animateIt = [SKAction animateWithTextures:@[snakeTextureOne, snakeTextureTwo] timePerFrame:.1];
    [self.groundEnemyNodeSecond runAction:[SKAction repeatActionForever:animateIt]];
    [self.groundEnemyNodeSecond runAction:[SKAction repeatActionForever:moveEnemyRight]];
    
    self.groundEnemyNodeSecond.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_groundEnemyNodeSecond.size];
    self.groundEnemyNodeSecond.physicsBody.categoryBitMask = groundEnemyCategory;
    self.groundEnemyNodeSecond.physicsBody.collisionBitMask = playerCategory | missileCategory;
    self.groundEnemyNodeSecond.physicsBody.contactTestBitMask = playerCategory | missileCategory;
    self.groundEnemyNodeSecond.physicsBody.usesPreciseCollisionDetection = YES;
    
    return self.groundEnemyNodeSecond;
    
}

- (SKSpriteNode *)BirdEnemy {
    self.bird = [self.characters objectAtIndex:4];
    self.birdEnemyTexture1 = [SKTexture textureWithImageNamed:self.bird.name1];
    self.birdEnemyTexture2 = [SKTexture textureWithImageNamed:self.bird.name2];
    
    self.birdEnemyNode = [SKSpriteNode spriteNodeWithTexture:self.birdEnemyTexture1];
    [self.birdEnemyNode setScale:.65];
    self.birdEnemyNode.zPosition = 1;
    self.birdEnemyNode.name = @"bird1";
    self.birdEnemyNode.position = CGPointMake(self.size.width, skRand((self.frame.size.height)*.5, self.skyLevelY));
    self.moveBirdEnemyLeft = [SKAction moveByX:-25 y:0 duration:.1];
    
    //    SKAction *animateBird1 = [SKAction animateWithTextures:@[self.birdEnemyTexture1, self.birdEnemyTexture2] timePerFrame:.1];
    //    [self.birdEnemyNode runAction:[SKAction repeatActionForever:animateBird1]];
    [self.birdEnemyNode runAction:[SKAction repeatActionForever:self.moveBirdEnemyLeft]];
    
    self.birdEnemyNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.birdEnemyNode.size];
    self.birdEnemyNode.physicsBody.categoryBitMask = birdEnemy1Category;
    self.birdEnemyNode.physicsBody.collisionBitMask =  missileCategory;
    self.birdEnemyNode.physicsBody.contactTestBitMask =  missileCategory;
    self.birdEnemyNode.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:self.birdEnemyNode];
    
    return self.birdEnemyNode;
    
}

- (void)missileAnimation {
    self.missile = [SKSpriteNode spriteNodeWithImageNamed:self.player.missile];
    [self.missile setScale:.2];
    self.missile.zPosition = 1;
    self.missile.name = @"banana";
    self.missile.position = CGPointMake(self.playerNode.position.x, self.playerNode.position.y);
    
    self.missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.missile.size];
    self.missile.physicsBody.categoryBitMask = missileCategory;
    self.missile.physicsBody.collisionBitMask = groundEnemyCategory | birdEnemy1Category | enemyMissilesCategory;
    self.missile.physicsBody.contactTestBitMask = groundEnemyCategory | birdEnemy1Category | enemyMissilesCategory;
    self.missile.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:self.missile];
}

- (void)missilesFallingFromSky {
    self.missilesFromSky = [SKSpriteNode spriteNodeWithImageNamed:self.player.moreMissiles];
    [self.missilesFromSky setScale:.1];
    self.missilesFromSky.zPosition = 1;
    self.missilesFromSky.position = CGPointMake(skRand(0, self.frame.size.width), self.frame.size.height);
    self.missilesFromSky.name = @"missilesFromSky";
    
    self.missilesFromSky.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.missilesFromSky.size];
    self.missilesFromSky.physicsBody.categoryBitMask = missileFromSkyCategory;
    self.missilesFromSky.physicsBody.collisionBitMask = playerCategory;
    self.missilesFromSky.physicsBody.contactTestBitMask = playerCategory;
    self.missilesFromSky.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:self.missilesFromSky];
    
    SKAction *fallMissiles = [SKAction moveByX:0 y:-50 duration:1];
    [self.missilesFromSky runAction:[SKAction repeatActionForever:fallMissiles]];
    
    
    

}

- (void)createAerialBombs {
    self.aerialBombs = [self.characters objectAtIndex:5];
    self.aerialBombNode = [SKSpriteNode spriteNodeWithImageNamed:self.aerialBombs.name1];
    [self.aerialBombNode setScale:.02];
    self.aerialBombNode.zPosition = 1;
    self.aerialBombNode.position = CGPointMake(self.birdEnemyNode.position.x, self.birdEnemyNode.position.y);
    self.aerialBombNode.name = @"birdBomb";
    self.aerialBombNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.aerialBombNode.size];
    self.aerialBombNode.physicsBody.categoryBitMask = enemyMissilesCategory;
    self.aerialBombNode.physicsBody.collisionBitMask = playerCategory | missileCategory;
    self.aerialBombNode.physicsBody.contactTestBitMask = playerCategory | missileCategory;
    self.aerialBombNode.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    SKAction *missileThrown = [SKAction moveByX:0 y:-50 duration:.5];
    [self.aerialBombNode runAction:[SKAction repeatActionForever:missileThrown]];
    [self addChild:self.aerialBombNode];
    
}

- (void)createButtons {
    self.leftButtonForScene = [self.characters objectAtIndex:3];
    self.leftButton = [SKSpriteNode spriteNodeWithImageNamed:self.leftButtonForScene.buttonFile];
    self.leftButton.name = @"LeftButton";
    [self.leftButton setScale:.17];
    self.leftButton.zPosition = 1;
    self.leftButton.position = CGPointMake((self.frame.size.width) * .1, (self.frame.size.height) * .5);
    [self addChild:self.leftButton];
    
    self.rightButtonForScene = [self.characters objectAtIndex:6];
    self.rightButton = [SKSpriteNode spriteNodeWithImageNamed:self.rightButtonForScene.buttonFile];
    self.rightButton.name = @"RighttButton";
    [self.rightButton setScale:.17];
    self.rightButton.zPosition = 1;
    self.rightButton.position = CGPointMake((self.frame.size.width) * .9, (self.frame.size.height) * .5);
    [self addChild:self.rightButton];
    
}

- (void)scoreCounter {
    _score = 0;
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    self.scoreLabel.position = CGPointMake( CGRectGetMidX( self.frame ),  self.frame.size.height * .7);
    self.scoreLabel.zPosition = 2;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)_score];
    
    [self addChild:self.scoreLabel];
    
    NSString *getScore = [self.dao.highScoreArray objectAtIndex:0];
    NSInteger myInt = [getScore intValue];
    
    self.highestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    self.highestScoreLabel.position = CGPointMake((self.frame.size.width) * .85, self.frame.size.height *.9);
    self.highestScoreLabel.zPosition = 2;
    self.highestScoreLabel.fontColor = [SKColor blackColor];
    [self.highestScoreLabel setScale:.7];
    self.highestScoreLabel.text = [NSString stringWithFormat:@"Top Score %ld", (long)myInt];
    // NSLog(@"high score is showing %@", _highestScoreLabel.text);
    [self addChild:self.highestScoreLabel];
}

- (void)missileCountLabel {
    _missileCount = 10;
    self.bananasAvailable = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    self.bananasAvailable.position = CGPointMake((self.frame.size.width)*.15, (self.frame.size.height)*.85);
    self.bananasAvailable.zPosition = 2;
    self.bananasAvailable.text = [NSString stringWithFormat:@"%ld",(long)_missileCount];
    self.bananasAvailable.fontColor = [SKColor blackColor];
    [self addChild:self.bananasAvailable];
    
    SKSpriteNode *missileImage = [SKSpriteNode spriteNodeWithImageNamed:self.player.moreMissiles];
    [missileImage setScale:.09];
    missileImage.zPosition = 1;
    missileImage.position = CGPointMake((self.frame.size.width)*.05, (self.frame.size.height)*.88);
    [self addChild:missileImage];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //  MAIN CHARACTER & BACKGROUND
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.scene];
        
        //  stores nodes at the point touched.
        
        NSArray *nodes = [self nodesAtPoint:touchLocation];
        SKSpriteNode *background1Check;
        SKSpriteNode *background2Check;
        SKSpriteNode *leftButtonCheck;
        SKSpriteNode *rightButtonCheck;
         SKSpriteNode *bananaCheck;
        for (int i = 0; i < nodes.count; i++) {
            SKSpriteNode *object = [nodes objectAtIndex:i];
            if (object.name == self.backgroundImage.name) {
                background1Check = object;
            }
            if (object.name == self.backgroundImage2.name) {
                background2Check = object;
            }
            if (object.name == self.leftButton.name) {
                leftButtonCheck = object;
            }
            if (object.name == self.rightButton.name) {
                rightButtonCheck = object;
            }
            if (object.name == self.missile.name) {
                bananaCheck = object;
            }
        }
        
            
            //  MOVE LEFT
            if ((background1Check != nil && background2Check != nil && leftButtonCheck != nil) || (background1Check != nil && background2Check != nil && leftButtonCheck != nil && bananaCheck != nil))
            {
                if (self.playerNode.position.x > (self.frame.size.width)*.05) {
                self.run = [SKAction animateWithTextures:@[self.idleTexture2, self.runLeftTexture1, self.runLeftTexture2, self.runLeftTexture3, self.runLeftTexture4, self.runLeftTexture5, self.runLeftTexture6, self.idleTexture2] timePerFrame:.05];
                    
               // self.run = [SKAction animateWithTextures:@[self.idleTexture2] timePerFrame:.05];
                    
                [self.playerNode runAction:[SKAction repeatAction:self.run count:1]];
                [self.playerNode runAction:self.moveLeft];
                    
                NSLog(@"monkey size : %f, %f", self.playerNode.frame.size.width, self.playerNode.frame.size.height);
                    
                }
            }
            
            //  MOVE RIGHT
            else if ((background1Check != nil && background2Check != nil && rightButtonCheck != nil) || (background1Check != nil && background2Check != nil && rightButtonCheck != nil && bananaCheck != nil))
            {
                if (self.playerNode.position.x > (self.frame.size.width)*.05 || self.playerNode.position.x < self.frame.size.width) {
                self.run = [SKAction animateWithTextures:@[self.runRightTexture1, self.runRightTexture2, self.runRightTexture3, self.runRightTexture4, self.runRightTexture5, self.runRightTexture6, self.idleTexture1] timePerFrame:.05];
               // self.run = [SKAction animateWithTextures:@[self.idleTexture1] timePerFrame:.05];
                    
                    [self.playerNode runAction:[SKAction repeatAction:self.run count:1]];
                [self.playerNode runAction:self.moveRight];
                    
                NSLog(@"monkey size : %f, %f", self.playerNode.frame.size.width, self.playerNode.frame.size.height);
   
                    
                }
            }
        
        
        else
        {
            if (_missileCount > 0) {
                
                
                //  THROW MISSILE TO THE RIGHT OF MAIN CHARACTER
                
                if (touchLocation.x > self.missile.position.x) {
                    
                    [self runAction:[SKAction playSoundFileNamed:self.sounds.missileThrowEffect waitForCompletion:NO]];
                    self.fireMissile = [SKAction animateWithTextures:@[self.throwRighttTexture1, self.throwRightTexture2, self.idleTexture1] timePerFrame:.05];
                    [self.playerNode runAction:[SKAction repeatAction:self.fireMissile count:1]];
                    
                    [self missileAnimation];
                    
                    
                    SKAction *rotateMissile = [SKAction rotateToAngle:360 duration:1 shortestUnitArc:NO];
                    [self.missile runAction:[SKAction repeatActionForever:rotateMissile]];
                    SKAction *missileTrajection = [SKAction moveTo:touchLocation duration:1.0f ];
                    [self.missile runAction:[SKAction repeatActionForever:missileTrajection]];
                    SKAction *removeNode = [SKAction removeFromParent];
                    
                    SKAction *sequence = [SKAction sequence:@[rotateMissile, missileTrajection, removeNode]];
                    [self.missile runAction: sequence];
                    
                    _missileCount--;
                    self.bananasAvailable.text = [NSString stringWithFormat:@"%ld", (long)_missileCount];
                    
                    
                }
                //  THROW MISSILE TO THE LEFT OF MAIN CHARACTER
                else
                {
                    [self runAction:[SKAction playSoundFileNamed:self.sounds.missileThrowEffect waitForCompletion:NO]];
                    self.fireMissile = [SKAction animateWithTextures:@[self.throwLeftTexture1, self.throwLeftTexture2, self.idleTexture2] timePerFrame:.05];
                    [self.playerNode runAction:[SKAction repeatAction:self.fireMissile count:1]];
                    
                    [self missileAnimation];
                    
                    
                    SKAction *rotateMissile = [SKAction rotateToAngle:360 duration:1 shortestUnitArc:NO];
                    [self.missile runAction:[SKAction repeatActionForever:rotateMissile]];
                    SKAction *missileTrajection = [SKAction moveTo:touchLocation duration:1.0f ];
                    [self.missile runAction:[SKAction repeatAction:missileTrajection count:1]];
                    SKAction *removeNode = [SKAction removeFromParent];
                    
                    
                    //
                    SKAction *sequence = [SKAction sequence:@[rotateMissile, missileTrajection, removeNode]];
                    [self.missile runAction: sequence];
                    
                    _missileCount--;
                    self.bananasAvailable.text = [NSString stringWithFormat:@"%ld", (long)_missileCount];
                }
                
                
            }
        }
    }
}


- (void)didBeginContact:(SKPhysicsContact *)contact

{
    
    //COLLISION DETECTION!!!
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & missileCategory) != 0)
    {
        SKNode *projectile = (contact.bodyA.categoryBitMask & missileCategory) ? contact.bodyA.node : contact.bodyB.node;
        SKNode *enemy = (contact.bodyA.categoryBitMask & missileCategory) ? contact.bodyB.node : contact.bodyA.node;
        
        [projectile runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction removeFromParent]];
        [self missileCollisionWithGroundEnemy];
        _score++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)_score];
        _missileCount++;
        self.bananasAvailable.text = [NSString stringWithFormat:@"%ld", (long)_missileCount];
        
    }
    else if ((firstBody.categoryBitMask & groundEnemyCategory) != 0)
    {
        //[self groundEnemyCollisionWithPlayer];
        [self.audioPlayer stop];
        
        _highScoreCounter += _score;
        NSString *getHighestScore = [self.dao.highScoreArray objectAtIndex:0];
        NSInteger convertTheScoreString = [getHighestScore intValue];
        if (_highScoreCounter > convertTheScoreString) {
            
            self.dao.getScoreFromGameScene = [[NSMutableArray alloc]init];
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)_highScoreCounter];
            [self.dao.getScoreFromGameScene addObject:inStr];
            NSLog(@"elements in dis array is %lu", (unsigned long)self.dao.getScoreFromGameScene.count);
            [self.dao updateTopScore];
        }
        
        SKScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition fadeWithDuration:.2];
        [self.view presentScene:gameOverScene transition:doors];
        
        
    }
    
    else if ((firstBody.categoryBitMask & enemyMissilesCategory) != 0)
    {
        //[self groundEnemyCollisionWithPlayer];
        [self.audioPlayer stop];
        
        _highScoreCounter += _score;
        NSString *getHighestScore = [self.dao.highScoreArray objectAtIndex:0];
        NSInteger convertTheScoreString = [getHighestScore intValue];
        if (_highScoreCounter > convertTheScoreString) {
            
            self.dao.getScoreFromGameScene = [[NSMutableArray alloc]init];
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)_highScoreCounter];
            [self.dao.getScoreFromGameScene addObject:inStr];
            NSLog(@"elements in dis array is %lu", (unsigned long)self.dao.getScoreFromGameScene.count);
            [self.dao updateTopScore];
        }
        
        
        SKScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition fadeWithDuration:.2];
        [self.view presentScene:gameOverScene transition:doors];
    }
    
    else if ((firstBody.categoryBitMask & missileFromSkyCategory) != 0)
    {
        //[self groundEnemyCollisionWithPlayer];
        SKNode *projectile = (contact.bodyA.categoryBitMask & missileFromSkyCategory) ? contact.bodyA.node : contact.bodyB.node;
        
        [projectile runAction:[SKAction removeFromParent]];
        
        _missileCount += 5;
        self.bananasAvailable.text = [NSString stringWithFormat:@"%ld", (long)_missileCount];
    }
}

- (void)missileCollisionWithGroundEnemy {
    [self runAction:[SKAction playSoundFileNamed:self.sounds.missileHitEffect waitForCompletion:NO]];
}

- (void)groundEnemyCollisionWithPlayer {
    SKAction *die = [SKAction animateWithTextures:@[self.deadPlayer] timePerFrame:.05];
    [self.playerNode runAction:[SKAction repeatAction:die count:1]];
}

- (void)enemyAnimations {
    SKAction *createGroundEnemy = [SKAction sequence:@[
                                                       [SKAction performSelector:@selector(newGroundEnemy) onTarget:self],
                                                       [SKAction waitForDuration: skRand(1,6) withRange:.35],
                                                       
                                                       ]];
   [self runAction:[SKAction repeatActionForever:createGroundEnemy]];
    
    SKAction *createGroundEnemy2 = [SKAction sequence:@[
                                                        [SKAction waitForDuration: skRand(4,5) withRange:.35],
                                                        [SKAction performSelector:@selector(newGroundEnemyFromLeft) onTarget:self],
                                                        [SKAction waitForDuration: skRand(1,6) withRange:.35],
                                                        
                                                        ]];
    [self runAction:[SKAction repeatActionForever:createGroundEnemy2]];
    
    SKAction *createAirEnemy1 = [SKAction sequence:@[
                                                     [SKAction performSelector:@selector(BirdEnemy) onTarget:self],
                                                     [SKAction waitForDuration: skRand(1,3) withRange:.35],
                                                     
                                                     ]];
    [self runAction:[SKAction repeatActionForever:createAirEnemy1]];
    
    SKAction *createAirEnemyMissiles = [SKAction sequence:@[
                                                            [SKAction performSelector:@selector(createAerialBombs) onTarget:self],
                                                            [SKAction waitForDuration: skRand(0,1.7) withRange:3],
                                                            
                                                            ]];
    [self runAction:[SKAction repeatActionForever:createAirEnemyMissiles]];
    
    SKAction *createMissilesFromSky = [SKAction sequence:@[
                                                           [SKAction waitForDuration: skRand(5,10) withRange:3],
                                                            [SKAction performSelector:@selector(missilesFallingFromSky) onTarget:self],

                                                            ]];
    [self runAction:[SKAction repeatActionForever:createMissilesFromSky]];

}


- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:self.player.missile usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
    
}



@end
