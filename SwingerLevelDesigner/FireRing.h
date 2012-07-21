//
//  FireRing.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/20/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface FireRing : GameObject {
    CGFloat moveX;
    CGFloat moveY;
}

@property (nonatomic, readwrite, assign) CGFloat moveX;
@property (nonatomic, readwrite, assign) CGFloat moveY;

@end
