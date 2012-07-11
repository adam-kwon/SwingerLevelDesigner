//
//  Torch.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/10/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Torch.h"

@implementation Torch

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"L2a_Torch" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeTorch;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"L2a_Torch.png";
}


@end
