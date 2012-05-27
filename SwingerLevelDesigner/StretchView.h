//
//  StretchView.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GameObject;

@interface StretchView : NSView<NSTextDelegate> {
    NSBezierPath *path;
    NSMutableArray *gameObjects;
    float opacity;
    NSPoint downPoint;
    NSPoint currentPoint;
}


- (void) addGameObject:(GameObject*)gameObject;
- (void) updateSelectedPosition:(CGPoint)newPos;

@property (assign) float opacity;
//@property (strong) NSMutableArray *gameObjects;

@end
