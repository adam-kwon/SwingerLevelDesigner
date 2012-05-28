//
//  AppDelegate.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StretchView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet StretchView *stretchView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *position;
@property (assign) IBOutlet NSTextField *swingSpeed;
@property (assign) IBOutlet NSTextField *gameWorldSize;

@property (assign) IBOutlet NSTextField *xPosition;
@property (assign) IBOutlet NSTextField *yPosition;

- (IBAction)showOpenPanel:(id)sender;
- (IBAction)resizeCanvas:(id)sender;
- (IBAction)addPole:(id)sender;

@end
