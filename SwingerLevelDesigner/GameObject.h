//
//  GameObject.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/26/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

typedef enum {
    kGameObjectTypeNone,
    kGameObjectTypeDummy,
    kGameObjectTypeSwinger,
    kGameObjectTypeCannon,
    kGameObjectTypeSpring,
    kGameObjectTypeFinalPlatform,
    kGameObjectTypeElephant,
    kGameObjectTypeStar,
    kGameObjectTypeCoin,
    kGameObjectTypeTreeClump1,
    kGameObjectTypeTreeClump2,
    kGameObjectTypeTreeClump3,
    kGameObjectTypeTent1,
    kGameObjectTypeTent2,
    kGameObjectTypeBalloonCart,
    kGameObjectTypePopcornCart,
    kGameObjectTypeBoxes,
    kGameObjectTypeWheel,
    kGameObjectTypeStrongMan,
    kGameObjectTypeTorch,
    kGameObjectTypeTreeClump1ForestRetreat,
    kGameObjectTypeTreeClump2ForestRetreat,
    kGameObjectTypeTreeClump3ForestRetreat,
    kGameObjectTypeTree1ForestRetreat,
    kGameObjectTypeTree2ForestRetreat,
    kGameObjectTypeTree3ForestRetreat,
    kGameObjectTypeTree4ForestRetreat
} GameObjectType;

@interface GameObject : NSImage {
    GameObjectType gameObjectType;
    BOOL selected;
    BOOL moveHandleSelected;
    BOOL resizeHandleSelected;
    CGSize originalSize;
    CGPoint position;
    CGFloat grip;
    CGFloat windSpeed;
    CGPoint anchorPoint;
    CGFloat anchorXOffset;
    CGFloat anchorYOffset;
    CGFloat scale;
    int zOrder;
    NSString *name;
    NSString *windDirection;
    
//    NSTextView *lbl;

    NSImage *moveHandle;
    NSImage *resizeHandle;
}

+ (id) instanceOf:(NSString*)type;
- (id) initWithAnchorPoint:(CGPoint)ap;
- (id) initWithContentsOfFile:(NSString *)fileName anchorPoint:(CGPoint)ap;
- (CGRect) imageRect;
- (CGRect) moveHandleRect;
- (CGRect) resizeHandleRect;
- (void) draw:(CGContextRef)ctx;
- (BOOL) isPointInImage:(CGPoint)point;
- (BOOL) isPointInMoveHandle:(CGPoint)point;
- (BOOL) isPointInResizeHandle:(CGPoint)point;
- (BOOL) isRectIntersectImage:(CGRect)rect;
- (void) updateInfo;
- (void) updateProperties;
- (void) levelForSerialization:(NSMutableDictionary*)levelDict;
- (void) loadFromDict:(NSDictionary*)level;
- (NSString*) gameObjectTypeString;
- (CGPoint) getWindForce:(float)mass;

@property (nonatomic, readwrite, assign) CGPoint position;
@property (nonatomic, readwrite, assign) int zOrder;
@property (nonatomic, readwrite, assign) BOOL selected;
@property (nonatomic, readwrite, assign) BOOL moveHandleSelected;
@property (nonatomic, readwrite, assign) BOOL resizeHandleSelected;
@property (nonatomic, readwrite, assign) GameObjectType gameObjectType;
@property (nonatomic, readwrite, assign) CGFloat grip;
@property (nonatomic, readwrite, assign) CGFloat windSpeed;
@property (nonatomic, readwrite, assign) CGFloat anchorXOffset;
@property (nonatomic, readwrite, assign) CGFloat anchorYOffset;
@property (nonatomic, readwrite, assign) CGPoint anchorPoint;
@property (nonatomic, readwrite, assign) CGFloat scale;
@property (retain) NSString *windDirection;
@property (retain) NSString *name;

@end
