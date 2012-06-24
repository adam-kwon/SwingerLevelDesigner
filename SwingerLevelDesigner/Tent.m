//
//  Tent.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Tent.h"

@implementation Tent

- (id) initWithAnchorPoint:(CGPoint)ap ofType:(TentType)tt {
    if (tt == kTent1) {
        self = [super initWithContentsOfFile:@"L1a_Tent1" anchorPoint:ap];        
        self.gameObjectType = kGameObjectTypeTent1;
    } else if (tt == kTent2) {
        self = [super initWithContentsOfFile:@"L1a_Tent2" anchorPoint:ap];        
        self.gameObjectType = kGameObjectTypeTent2;
    }
    
    return self;
}

- (NSString*) gameObjectTypeString {
    if (self.gameObjectType == kGameObjectTypeTent1) {
        return @"L1a_Tent1.png";
    } else if (self.gameObjectType == kGameObjectTypeTent2) {
        return @"L1a_Tent2.png";
    } 
    
    NSAssert(NO, @"Invalid tent type!");
    return nil;
}
@end
