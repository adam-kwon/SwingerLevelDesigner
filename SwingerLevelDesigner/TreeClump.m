//
//  TreeClump.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "TreeClump.h"

@implementation TreeClump

- (id) initWithAnchorPoint:(CGPoint)ap ofType:(TreeClumpType)ct {
    if (ct == kTreeClump1) {
        self = [super initWithContentsOfFile:@"L1aTreeClump1" anchorPoint:ap];        
        self.gameObjectType = kGameObjectTypeTreeClump1;
    } else if (ct == kTreeClump2) {
        self = [super initWithContentsOfFile:@"L1aTreeClump2" anchorPoint:ap];        
        self.gameObjectType = kGameObjectTypeTreeClump2;
    } else if (ct == kTreeClump3) {
        self = [super initWithContentsOfFile:@"L1aTreeClump3" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTreeClump3;
    } else if (ct == kTreeClump1ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_TreeClump1" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTreeClump1ForestRetreat;        
    } else if (ct == kTreeClump2ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_TreeClump2" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTreeClump2ForestRetreat;                
    } else if (ct == kTreeClump3ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_TreeClump3" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTreeClump3ForestRetreat;                
    } else if (ct == kTree1ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_Tree1" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTree1ForestRetreat;                
    } else if (ct == kTree2ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_Tree2" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTree2ForestRetreat;                        
    } else if (ct == kTree3ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_Tree3" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTree3ForestRetreat;                        
    } else if (ct == kTree4ForestRetreat) {
        self = [super initWithContentsOfFile:@"L2a_Tree4" anchorPoint:ap];                
        self.gameObjectType = kGameObjectTypeTree4ForestRetreat;                        
    }
    
    return self;
}

- (NSString*) gameObjectTypeString {
    if (self.gameObjectType == kGameObjectTypeTreeClump1) {
        return @"L1aTreeClump1.png";
    } 
    else if (self.gameObjectType == kGameObjectTypeTreeClump2) {
        return @"L1aTreeClump2.png";
    } 
    else if (self.gameObjectType == kGameObjectTypeTreeClump3) {
        return @"L1aTreeClump3.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTreeClump1ForestRetreat) {
        return @"L2a_TreeClump1.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTreeClump2ForestRetreat) {
        return @"L2a_TreeClump2.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTreeClump3ForestRetreat) {
        return @"L2a_TreeClump3.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTree1ForestRetreat) {
        return @"L2a_Tree1.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTree2ForestRetreat) {
        return @"L2a_Tree2.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTree3ForestRetreat) {
        return @"L2a_Tree3.png";
    }
    else if (self.gameObjectType == kGameObjectTypeTree4ForestRetreat) {
        return @"L2a_Tree4.png";
    }
    NSAssert(NO, @"Invalid tree clump type!");
    return nil;
}


@end
