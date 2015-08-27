//
//  GameOverScene.h
//  Void
//
//  Created by Donald Fung on 8/12/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import <AVFoundation/AVFoundation.h>

@interface GameOverScene : SKScene <AVAudioPlayerDelegate>

@property BOOL contentCreated;
@property (nonatomic, retain) AVAudioPlayer *audioGameOver;
@property (nonatomic, retain) SKLabelNode *tryAgain;
@end
