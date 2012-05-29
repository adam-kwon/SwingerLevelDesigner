//
//  StretchView.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameObject.h"


@interface StretchView : NSView<NSTextDelegate> {
    NSBezierPath *path;
    NSMutableArray *gameObjects;
    float opacity;
    NSPoint downPoint;
    NSPoint currentPoint;
        
    CGFloat scale;
    CGFloat deviceScreenHeight;
    CGFloat deviceScreenWidth;
}


- (void) addGameObject:(GameObject*)gameObject isSelected:(BOOL)selected;

- (void) updateSelectedPosition:(CGPoint)newPos;
- (void) updateSelectedSwingSpeed:(CGFloat)newSwingSpeed;
- (void) unselectAllGameObjects;
- (void) loadLevel:(NSArray*)levelItems;
- (void) clearCanvas;
- (NSArray*) levelForSerialization;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@property (assign) float opacity;
@property (assign) CGFloat deviceScreenHeight;
@property (assign) CGFloat deviceScreenWidth;
//@property (strong) NSMutableArray *gameObjects;

@end
