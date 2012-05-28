//
//  AppDelegate.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StretchView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet StretchView *stretchView;
    IBOutlet __weak NSTextField *xPosition;
    IBOutlet __weak NSTextField *yPosition;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) NSTextField *xPosition;
@property (weak) NSTextField *yPosition;

- (IBAction)showOpenPanel:(id)sender;
- (IBAction)resizeCanvas:(id)sender;

@end
