//
//  AppDelegate.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "StretchView.h"
#import "GameObject.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize xPosition;
@synthesize yPosition;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)showOpenPanel:(id)sender {
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSImage imageFileTypes]];
    [panel beginSheetModalForWindow:[stretchView window] 
                  completionHandler:^ (NSInteger result) {
                      
        if (result == NSOKButton) {
            GameObject *image = [[GameObject alloc] initWithContentsOfURL:[panel URL]];
            [stretchView addGameObject:image];
        }
        panel = nil;
     }];
}



- (void) controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = (NSTextField*)[obj object];
    [stretchView updateSelectedPosition:CGPointMake([xPosition floatValue], [yPosition floatValue])];

//    if (textField == xPosition) {
//    } else if (textField == yPosition) {
//    }
}

@end
