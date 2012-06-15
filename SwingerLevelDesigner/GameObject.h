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
    kGameObjectTypeFinalPlatform,
    kGameObjectTypeStar
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
    NSString *windDirection;
    
    NSView *parent;
    NSTextView *lbl;

    NSImage *moveHandle;
    NSImage *resizeHandle;
}

- (id) initWithContentsOfFile:(NSString *)fileName parent:(NSView*)parentView;
- (CGRect) imageRect;
- (CGRect) moveHandleRect;
- (CGRect) resizeHandleRect;
- (void) draw:(CGContextRef)ctx;
- (BOOL) isPointInImage:(CGPoint)point;
- (BOOL) isPointInMoveHandle:(CGPoint)point;
- (BOOL) isPointInResizeHandle:(CGPoint)point;

@property (nonatomic, readwrite, assign) CGPoint position;
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
@property (retain) NSString *windDirection;

@end
