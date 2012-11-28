//
//  FloatingPlatform.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/17/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface FloatingPlatform : GameObject {
    CGFloat width;
    CGFloat distance;
    CGFloat speed;
}

@property (nonatomic, readwrite, assign) CGFloat width;
@property (nonatomic, readwrite, assign) CGFloat speed;
@property (nonatomic, readwrite, assign) CGFloat distance;

@end
