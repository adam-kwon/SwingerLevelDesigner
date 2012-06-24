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
    }
    
    return self;
}

- (NSString*) gameObjectTypeString {
    if (self.gameObjectType == kGameObjectTypeTreeClump1) {
        return @"L1aTreeClump1.png";
    } else if (self.gameObjectType == kGameObjectTypeTreeClump2) {
        return @"L1aTreeClump2.png";
    } else if (self.gameObjectType == kGameObjectTypeTreeClump3) {
        return @"L1aTreeClump3.png";
    }
    NSAssert(NO, @"Invalid tree clump type!");
    return nil;
}


@end
