//
//  GPUtil.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/11/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GPUtil.h"
#import "Constants.h"

@implementation GPUtil

+ (NSString*) convertedWorldName:(NSString*)worldName {
    if ([WORLD_GRASSY_KNOLLS isEqualToString:worldName]) {
        return @"World0";
    }
    else if ([WORLD_FOREST_RETREAT isEqualToString:worldName]) {
        return @"World1";
    }
    return @"";
}

@end
