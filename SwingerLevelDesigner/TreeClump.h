//
//  TreeClump.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

typedef enum {
    kTreeClump1,
    kTreeClump2,
    kTreeClump3,
    kTreeClump1ForestRetreat,
    kTreeClump2ForestRetreat,
    kTreeClump3ForestRetreat,
    kTree1ForestRetreat,
    kTree2ForestRetreat,
    kTree3ForestRetreat,
    kTree4ForestRetreat
} TreeClumpType;

@interface TreeClump : GameObject

- (id) initWithAnchorPoint:(CGPoint)ap ofType:(TreeClumpType)ct;

@end
