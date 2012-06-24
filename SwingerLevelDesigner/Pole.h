//
//  Pole.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface Pole : GameObject {
    CGFloat ropeLength;
    CGFloat period;
    CGFloat swingAngle;
}


@property (nonatomic, readwrite, assign) CGFloat period;
@property (nonatomic, readwrite, assign) CGFloat ropeLength;
@property (nonatomic, readwrite, assign) CGFloat swingAngle;

@end
