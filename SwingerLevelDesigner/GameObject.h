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
    kGameObjectTypeSwinger
} GameObjectType;

@interface GameObject : NSImage {
    GameObjectType gameObjectType;
    BOOL selected;
    BOOL moveHandleSelected;
    BOOL resizeHandleSelected;
    CGPoint position;
    CGFloat swingSpeed;
    NSImage *moveHandle;
    NSImage *resizeHandle;
}

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
@property (nonatomic, readwrite, assign) CGFloat swingSpeed;

@end
