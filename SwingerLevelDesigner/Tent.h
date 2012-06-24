//
//  Tent.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"


typedef enum {
    kTent1,
    kTent2
} TentType;

@interface Tent : GameObject

- (id) initWithAnchorPoint:(CGPoint)ap ofType:(TentType)tt;

@end


