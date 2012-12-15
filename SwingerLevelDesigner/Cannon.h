//
//  Cannon.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface Cannon : GameObject {
    CGFloat cannonSpeed;
    CGFloat cannonRotationAngle;
    CGFloat cannonForce;
    NSMutableArray *trajectories;
}

@property (nonatomic, readwrite, assign) CGFloat cannonSpeed;
@property (nonatomic, readwrite, assign) CGFloat cannonRotationAngle;
@property (nonatomic, readwrite, assign) CGFloat cannonForce;
@property (nonatomic, readonly) NSArray *trajectories;

@end
