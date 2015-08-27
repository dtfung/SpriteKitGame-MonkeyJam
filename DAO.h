//
//  DAO.h
//  Void
//
//  Created by Donald Fung on 8/9/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighestScore.h"

@interface DAO : NSObject


@property (nonatomic, retain) NSMutableArray *characterDatabase;
@property (nonatomic, retain) NSMutableArray *highScoreArray;
@property (nonatomic, retain) NSMutableArray *getScoreFromGameScene;

+ (id)sharedManager;
- (void)updateTopScore;


@end
