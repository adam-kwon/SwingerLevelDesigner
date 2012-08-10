//
//  Hunter.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 8/10/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface Hunter : GameObject {
    CGFloat walkDistance;
    CGFloat walkVelocity;
}

@property (nonatomic, readwrite, assign) CGFloat walkDistance;
@property (nonatomic, readwrite, assign) CGFloat walkVelocity;

@end
