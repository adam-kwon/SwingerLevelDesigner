//
//  StretchView.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameObject.h"

@interface StretchView : NSView<NSTextDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    NSBezierPath *path;
    NSMutableArray *gameObjects;
    float opacity;
    NSPoint downPoint;
    NSPoint currentPoint;
    CGFloat scale;
    CGFloat deviceScreenHeight;
    CGFloat deviceScreenWidth;
    
    CGRect selectionRect;
    BOOL startSelection;
}


- (void) addGameObject:(GameObject*)gameObject isSelected:(BOOL)selected;

- (void) updateSelectedPosition:(CGPoint)newPos;
- (void) updateSelectedPeriod:(CGFloat)newSwingSpeed;
- (void) updateSelectedRopeLength:(CGFloat)ropeLength;
- (void) updateSelectedSwingAngle:(CGFloat)swingAngle;
- (void) updateSelectedPoleScale:(CGFloat)poleScale;
- (void) updateSelectedGrip:(CGFloat)grip;
- (void) updateSelectedWindSpeed:(CGFloat)windSpeed;
- (void) updateSelectedWindDirection:(NSString*)windDirection;
- (void) updateSelectedCannonSpeed:(CGFloat)speed;
- (void) updateSelectedCannonForce:(CGFloat)force;
- (void) updateSelectedCannonRotationAngle:(CGFloat)angle;
- (void) updateSelectedZOrder:(int)zOrder;
- (void) updateSelectedBounce:(CGFloat)bounce;
- (void) unselectAllGameObjects;
- (void) loadLevel:(NSArray*)levelItems;
- (void) clearCanvas;
- (void) sortGameObjectsByZOrder;
- (GameObject*) getLastGameObject;
- (NSArray*) levelForSerialization;


- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)resetZoom:(id)sender;

@property (assign) float opacity;
@property (assign) CGFloat deviceScreenHeight;
@property (assign) CGFloat deviceScreenWidth;
//@property (strong) NSMutableArray *gameObjects;

@end
