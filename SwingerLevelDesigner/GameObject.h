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
    CGPoint position;
    CGFloat swingSpeed;
}

- (CGRect) imageRect;
- (void) draw:(CGContextRef)ctx;

@property (nonatomic, readwrite, assign) CGPoint position;
@property (nonatomic, readwrite, assign) BOOL selected;
@property (nonatomic, readwrite, assign) GameObjectType gameObjectType;
@property (nonatomic, readwrite, assign) CGFloat swingSpeed;

@end
