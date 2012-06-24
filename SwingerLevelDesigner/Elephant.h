//
//  Elephant.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface Elephant : GameObject {
    CGFloat leftEdge;
    CGFloat rightEdge;
    CGFloat walkVelocity;
}

@property (nonatomic, readwrite, assign) CGFloat leftEdge;
@property (nonatomic, readwrite, assign) CGFloat rightEdge;
@property (nonatomic, readwrite, assign) CGFloat walkVelocity;

@end
