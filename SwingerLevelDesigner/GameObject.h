//
//  GameObject.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/26/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GameObject : NSImage {
    BOOL selected;
    CGPoint position;
}

- (CGRect) imageRect;
- (void) draw:(CGContextRef)ctx;

@property (nonatomic, readwrite, assign) CGPoint position;
@property (nonatomic, readwrite, assign) BOOL selected;

@end
