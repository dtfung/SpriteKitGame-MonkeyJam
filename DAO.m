//
//  DAO.m
//  Void
//
//  Created by Donald Fung on 8/9/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import "DAO.h"
#import "MainCharacter.h"
#import "EnemyObjects.h"
#import "Audio.h"
#import "Buttons.h"

@implementation DAO

+ (id)sharedManager {
    
    //    Call singleton
    static DAO *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

-(instancetype) init {
    if (self = [super init]) {
        [self sprites];
        [self loadUserDefaults];
        return self;
    }
    else return nil;
}

- (void)sprites {
    
    //ADD MAIN CHARACTER SPRITES HERE
    MainCharacter * mainCharacter = [[MainCharacter alloc] init];
    mainCharacter.nodeName = @"monkey";
    mainCharacter.idle = @"monkey_idle.png";
    mainCharacter.idle2 = @"monkey_idle2.png";
    mainCharacter.runLeft1 = @"monkey_runLeft_1.png";
    mainCharacter.runLeft2 = @"monkey_runLeft_2.png";
    mainCharacter.runLeft3 = @"monkey_runLeft_3.png";
    mainCharacter.runLeft4 = @"monkey_runLeft_4.png";
    mainCharacter.runLeft5 = @"monkey_runLeft_5.png";
    mainCharacter.runLeft6 = @"monkey_runLeft_6.png";
    mainCharacter.runRight1 = @"monkey_run_1.png";
    mainCharacter.runRight2 = @"monkey_run_2.png";
    mainCharacter.runRight3 = @"monkey_run_3.png";
    mainCharacter.runRight4 = @"monkey_run_4.png";
    mainCharacter.runRight5 = @"monkey_run_5.png";
    mainCharacter.runRight6 = @"monkey_run_6.png";
    mainCharacter.throwLeft1 = @"monkey_throwLeft_1.png";
    mainCharacter.throwLeft2 = @"monkey_throwLeft_2.png";
    mainCharacter.throwRight1 = @"monkey_throw_1.png";
    mainCharacter.throwRight2 = @"monkey_throw_2.png";
    mainCharacter.jumpRight1 = @"monkey_jump_swing_.png";
    mainCharacter.jumpRight2 = @"monkey_jump_swing_2.png";
    mainCharacter.jumpRight3 = @"monkey_jump_swing_3.png";
    mainCharacter.jumpLeft1 = @"monkey_jump_swingLeft_.png";
    mainCharacter.jumpLeft2 = @"monkey_jump_swingLeft_2.png";
    mainCharacter.jumpLeft3 = @"monkey_jump_swingLeft_3.png";
    
    mainCharacter.dead = @"monkey_dead.png";  
    mainCharacter.missile = @"banana.png";
    mainCharacter.moreMissiles = @"bananas.png";
    

    
    //ADD ENEMY
    EnemyObjects *snake = [[EnemyObjects alloc] init];
    snake.nodeName = @"snake";
    snake.name1 = @"snake1.png";
    snake.name2 = @"snake2.png";
    
    EnemyObjects *snake2 = [[EnemyObjects alloc] init];
    snake2.name1 = @"snake1Left.png";
    snake2.name2 = @"snake2Left.png";

    
    EnemyObjects *bird1 = [[EnemyObjects alloc] init];
    bird1.name1 = @"bird3.png";
    bird1.name2 = @"bird4.png";
    
    EnemyObjects *aerialBomb = [[EnemyObjects alloc] init];
    aerialBomb.name1 = @"aerialBomb.png";
    
    //ADD AUDIO
    Audio *audio = [[Audio alloc] init];
    audio.backgroundMusic = @"/Slow Ska Game Loop.mp3";
    audio.missileThrowEffect = @"Woosh.wav";
    audio.missileHitEffect = @"Banana_Slap.wav";
    
    
    //ADD BUTTONS
    Buttons *left = [[Buttons alloc] init];
    left.buttonFile = @"left-arrow.png";
    
    Buttons *right = [[Buttons alloc] init];
    right.buttonFile = @"right-arrow.png";
    
    
    self.characterDatabase = [[NSMutableArray alloc]init];
    [self.characterDatabase addObject:mainCharacter];
    [self.characterDatabase addObject:snake];
    [self.characterDatabase addObject:audio];
    [self.characterDatabase addObject:left];
    [self.characterDatabase addObject:bird1];
    [self.characterDatabase addObject:aerialBomb];
    [self.characterDatabase addObject:right];
    [self.characterDatabase addObject:snake2];
}

//Data persistence
- (void)loadUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"LoadStoredData"];
    
    if(encodedObject){
        self.highScoreArray = [NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
        return;
    }
}

- (void)updateTopScore {
    
    if (self.highScoreArray.count < 1) {
        NSLog(@"array initialized");
        self.highScoreArray = [[NSMutableArray alloc] init];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject;
    
    HighestScore *top = [[HighestScore alloc] init];
    top.topScore =  [self.getScoreFromGameScene objectAtIndex:0];
    
    if (self.highScoreArray.count < 1) {
        [self.highScoreArray addObject:top.topScore];
    }
    else {
        [self.highScoreArray removeObjectAtIndex:0];
        [self.highScoreArray addObject:top.topScore];
    }
    
    
    encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.highScoreArray];
    [defaults setObject:encodedObject forKey:@"LoadStoredData"];
    [defaults synchronize];
}

@end
