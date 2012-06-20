//
//  GameObject.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/26/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    kGameObjectTypeNone,
    kGameObjectTypeDummy,
    kGameObjectTypeSwinger,
    kGameObjectTypeCannon,
    kGameObjectTypeSpring,
    kGameObjectTypeFinalPlatform,
    kGameObjectTypeStar,
    kGameObjectTypeCoin,
    kGameObjectTypeTreeClump1,
    kGameObjectTypeTreeClump2,
    kGameObjectTypeTreeClump3,
    kGameObjectTypeTent1,
    kGameObjectTypeTent2,
    kGameObjectTypeBalloonCart,
    kGameObjectTypePopcornCart,
    kGameObjectTypeBoxes
} GameObjectType;

@interface GameObject : NSImage {
    GameObjectType gameObjectType;
    BOOL selected;
    BOOL moveHandleSelected;
    BOOL resizeHandleSelected;
    CGSize originalSize;
    CGPoint position;
    CGFloat ropeLength;
    CGFloat period;
    CGFloat poleScale;
    CGFloat swingAngle;
    CGFloat grip;
    CGFloat windSpeed;
    CGFloat cannonSpeed;
    CGFloat cannonRotationAngle;
    CGFloat cannonForce;
    CGPoint anchorPoint;
    CGFloat bounce;
    CGFloat anchorXOffset;
    CGFloat anchorYOffset;
    int zOrder;
    NSString *name;
    NSString *windDirection;
    
    NSView *parent;
    NSTextView *lbl;

    NSImage *moveHandle;
    NSImage *resizeHandle;
}

- (id) initWithContentsOfFile:(NSString *)fileName anchorPoint:(CGPoint)ap parent:(NSView*)parentView;
- (CGRect) imageRect;
- (CGRect) moveHandleRect;
- (CGRect) resizeHandleRect;
- (void) draw:(CGContextRef)ctx;
- (BOOL) isPointInImage:(CGPoint)point;
- (BOOL) isPointInMoveHandle:(CGPoint)point;
- (BOOL) isPointInResizeHandle:(CGPoint)point;
- (BOOL) isRectIntersectImage:(CGRect)rect;

@property (nonatomic, readwrite, assign) CGPoint position;
@property (nonatomic, readwrite, assign) int zOrder;
@property (nonatomic, readwrite, assign) BOOL selected;
@property (nonatomic, readwrite, assign) BOOL moveHandleSelected;
@property (nonatomic, readwrite, assign) BOOL resizeHandleSelected;
@property (nonatomic, readwrite, assign) GameObjectType gameObjectType;
@property (nonatomic, readwrite, assign) CGFloat period;
@property (nonatomic, readwrite, assign) CGFloat ropeLength;
@property (nonatomic, readwrite, assign) CGFloat poleScale;
@property (nonatomic, readwrite, assign) CGFloat swingAngle;
@property (nonatomic, readwrite, assign) CGFloat grip;
@property (nonatomic, readwrite, assign) CGFloat windSpeed;
@property (nonatomic, readwrite, assign) CGFloat cannonSpeed;
@property (nonatomic, readwrite, assign) CGFloat cannonRotationAngle;
@property (nonatomic, readwrite, assign) CGFloat cannonForce;
@property (nonatomic, readwrite, assign) CGFloat anchorXOffset;
@property (nonatomic, readwrite, assign) CGFloat anchorYOffset;
@property (nonatomic, readwrite, assign) CGFloat bounce;
@property (nonatomic, readwrite, assign) CGPoint anchorPoint;
@property (retain) NSString *windDirection;
@property (retain) NSString *name;

@end
