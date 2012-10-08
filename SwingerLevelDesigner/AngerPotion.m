//
//  AngerPotion.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "AngerPotion.h"

@implementation AngerPotion

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"potion-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeHunter;
    
    return self;
}


- (NSString*) gameObjectTypeString {
    return @"AngerPotion";
}

@end
