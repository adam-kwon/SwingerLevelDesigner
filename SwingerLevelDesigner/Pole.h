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
    // Factor used to scale rope length so that it matches length seen in game.
    // This is just eye-balled. Saw what the ratio of rope length to pole length was in game.
    float ropeHeightConversionFactor;

}


@property (nonatomic, readwrite, assign) CGFloat period;
@property (nonatomic, readwrite, assign) CGFloat ropeLength;
@property (nonatomic, readwrite, assign) CGFloat swingAngle;

@end
