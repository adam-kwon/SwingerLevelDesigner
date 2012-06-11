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
    NSMutableDictionary *levels;
    NSURL *fileName;
}

- (void) writeLevelToFile;
- (void) loadLevelFromFile;
- (void) loadLevel:(int)levelNumber;
- (void) synchronizeCurrentLevel;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *position;
@property (assign) IBOutlet NSTextField *ropeLength;
@property (assign) IBOutlet NSTextField *period;
@property (assign) IBOutlet NSTextField *gameWorldSize;
@property (assign) IBOutlet NSTextField *xPosition;
@property (assign) IBOutlet NSTextField *yPosition;
@property (assign) IBOutlet NSTextField *levelField;
@property (assign) IBOutlet NSTextField *maxLevelField;
@property (assign) IBOutlet NSTextField *grip;
@property (assign) IBOutlet NSTextField *poleScale;
@property (assign) IBOutlet NSTextField *windSpeed;
@property (assign) IBOutlet NSComboBox *windDirection;
@property (assign) IBOutlet NSTextField *swingAngle;
@property (assign) IBOutlet NSStepper *levelStepper;
@property (assign) IBOutlet StretchView *stretchView;

@property (assign) IBOutlet NSTextField *cannonSpeed;
@property (assign) IBOutlet NSTextField *cannonForce;
@property (assign) IBOutlet NSTextField *cannonRotationAngle;

- (IBAction)showOpenPanel:(id)sender;
- (IBAction)openLevel:(id)sender;
- (IBAction)resizeCanvas:(id)sender;
- (IBAction)addPole:(id)sender;
- (IBAction)addLevel:(id)sender;
- (IBAction)addCannon:(id)sender;
- (IBAction)addFinalPlatform:(id)sender;
- (IBAction)saveAs:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)stepperAction:(id)sender;
- (IBAction)newDocument:(id)sender;
@end
