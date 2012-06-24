//
//  Wheel.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface Wheel : GameObject {
    CGFloat speed;
}

@property (nonatomic, readwrite, assign) CGFloat speed;
@end
