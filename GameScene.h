//
//  GameScene.h
//  Void
//
//  Created by Donald Fung on 8/9/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DAO.h"
#import "MainCharacter.h"
#import "EnemyObjects.h"
#import "Audio.h"
#import <AVFoundation/AVFoundation.h>
#import "Buttons.h"
#import "GameOverScene.h"
#import <UIKit/UIKit.h>



@interface GameScene : SKScene <AVAudioPlayerDelegate, SKPhysicsContactDelegate, UIAccelerometerDelegate, SKSceneDelegate, UIGestureRecognizerDelegate>

{
    NSInteger _score;
    NSInteger _highScoreCounter;
    NSInteger _missileCount;
}



@property BOOL contentCreated;
@property (nonatomic, retain) DAO *dao;
@property (nonatomic, retain) NSMutableArray *characters;


//MAIN CHARACTER

@property (nonatomic, retain) MainCharacter *player;

@property (nonatomic, retain) SKSpriteNode *playerNode;
@property (nonatomic, retain) SKSpriteNode *missile;
@property (nonatomic, retain) SKSpriteNode *missilesFromSky;

@property (nonatomic, retain) SKTexture *idleTexture1;
@property (nonatomic, retain) SKTexture *idleTexture2;
@property (nonatomic, retain) SKTexture *runRightTexture1;
@property (nonatomic, retain) SKTexture *runRightTexture2;
@property (nonatomic, retain) SKTexture *runRightTexture3;
@property (nonatomic, retain) SKTexture *runRightTexture4;
@property (nonatomic, retain) SKTexture *runRightTexture5;
@property (nonatomic, retain) SKTexture *runRightTexture6;
@property (nonatomic, retain) SKTexture *runLeftTexture1;
@property (nonatomic, retain) SKTexture *runLeftTexture2;
@property (nonatomic, retain) SKTexture *runLeftTexture3;
@property (nonatomic, retain) SKTexture *runLeftTexture4;
@property (nonatomic, retain) SKTexture *runLeftTexture5;
@property (nonatomic, retain) SKTexture *runLeftTexture6;
@property (nonatomic, retain) SKTexture *throwLeftTexture1;
@property (nonatomic, retain) SKTexture *throwLeftTexture2;
@property (nonatomic, retain) SKTexture *throwRighttTexture1;
@property (nonatomic, retain) SKTexture *throwRightTexture2;
@property (nonatomic, retain) SKTexture *deadPlayer;
@property (nonatomic, retain) SKTexture *jumpRightTexture1;
@property (nonatomic, retain) SKTexture *jumpRightTexture2;
@property (nonatomic, retain) SKTexture *jumpRightTexture3;
@property (nonatomic, retain) SKTexture *jumpLeftTexture1;
@property (nonatomic, retain) SKTexture *jumpLeftTexture2;
@property (nonatomic, retain) SKTexture *jumpLeftTexture3;

@property (nonatomic, retain) SKAction *run;
@property (nonatomic, retain) SKAction *fireMissile;
@property (nonatomic, retain) SKAction *moveRight;
@property (nonatomic, retain) SKAction *moveLeft;

//BACKGROUND
@property (nonatomic, strong) NSArray * backgrounds;
@property (nonatomic, strong) NSArray * clonedBackgrounds;
@property (nonatomic, retain) SKSpriteNode * backgroundImage;
@property (nonatomic, retain) SKSpriteNode * backgroundImage2;

//ENEMIES
@property (nonatomic, retain) EnemyObjects *groundEnemy;
@property (nonatomic, retain) SKSpriteNode *groundEnemyNode;
@property (nonatomic, retain) SKTexture *groundEnemyTexture1;
@property (nonatomic, retain) SKTexture *groundEnemyTexture2;

@property (nonatomic, retain) SKAction *animateEnemy;
@property (nonatomic, retain) SKAction *moveEnemyLeft;
@property double groundLevelY;
@property double skyLevelY;

@property (nonatomic, retain) EnemyObjects *secondGroundEnemy;
@property (nonatomic, retain) SKSpriteNode *groundEnemyNodeSecond;

@property (nonatomic, retain) EnemyObjects *bird;
@property (nonatomic, retain) SKSpriteNode *birdEnemyNode;
@property (nonatomic, retain) SKTexture *birdEnemyTexture1;
@property (nonatomic, retain) SKTexture *birdEnemyTexture2;
@property (nonatomic, retain) SKAction *moveBirdEnemyLeft;

@property (nonatomic, retain) EnemyObjects *aerialBombs;
@property (nonatomic, retain) SKSpriteNode *aerialBombNode;

//AUDIO
@property (nonatomic, retain)  Audio *sounds;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

//BUTTONS
@property (nonatomic, retain) Buttons *leftButtonForScene;
@property (nonatomic, retain) Buttons *rightButtonForScene;
@property (nonatomic, retain) SKSpriteNode *jumpButton;
@property (nonatomic, retain) SKSpriteNode *leftButton;
@property (nonatomic, retain) SKSpriteNode *rightButton;
//SCORE
@property (nonatomic, retain) SKLabelNode *scoreLabel;

//TOP SCORE
@property (nonatomic, retain) SKLabelNode *highestScoreLabel;

//MISSILES AVAILABLE
@property (nonatomic, retain) SKLabelNode *bananasAvailable;



@end
