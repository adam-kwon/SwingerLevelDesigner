//
//  SpeedBoost.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "SpeedBoost.h"

@implementation SpeedBoost

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"cherry-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeHunter;
    
    return self;
}


- (NSString*) gameObjectTypeString {
    return @"SpeedBoost";
}
@end
