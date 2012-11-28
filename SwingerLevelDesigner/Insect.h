//
//  Insect.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@interface Insect : GameObject {
    CGFloat speed;
    CGFloat width;
}

@property (nonatomic, readwrite, assign) CGFloat speed;
@property (nonatomic, readwrite, assign) CGFloat width;


@end
