//
//  OpenInMacVim.m
//  pathfinder_open_in_macvim
//
//  Created by orta therox on 06/09/2010.
//  Copyright 2010 wgrids. All rights reserved.
//

#import "OpenInMacVim.h"


@implementation OpenInMacVim

@synthesize host;

+ (id)plugin:(id<NTPathFinderPluginHostProtocol>)pathfinder_host;
{
  OpenInMacVim* result = [[self alloc] init];
  result.host = pathfinder_host;
  
  return [result autorelease];
}

- (NSMenuItem*)contextualMenuItem;
{
	return [self menuItem];
}

- (NSMenuItem*)menuItem;
{
  NSMenuItem* menuItem;
	
  menuItem = [[[NSMenuItem alloc] initWithTitle:@"Open in MacVim" action:@selector(pluginAction:) keyEquivalent:@""] autorelease];
  [menuItem setTarget:self];
	[menuItem setKeyEquivalentModifierMask: NSControlKeyMask | NSCommandKeyMask];
  return menuItem;
}

- (void)pluginAction:(id)sender;
{
  [self processItems:nil parameter:nil];
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem;
{
  return [[[self host] selection:nil browserID:nil] count] > 0;
}

- (id)processItems:(NSArray*)items parameter:(id)parameter;
{

	if (!items)
		items = [self.host  selection:nil browserID:nil];
    
    // Create arguments array
    NSMutableArray *args = [NSMutableArray arrayWithCapacity: (2+[items count])];
    [args addObject:@"-g"];
	
    // Iterate over Path Finder selection
    NSEnumerator* enumerator = [items objectEnumerator];
    NSString *path;
    id<NTFSItem> item;	
    while ((item = [enumerator nextObject])) {
		path = [item path];
		if (path) {
            [args addObject:path];     // add file to arguments
        }
    }
    
    // Locate the Vim executable. By launching Vim -g instead of MacVim, any existing
    // MacVim instance will be re-used instead of creating a new one.
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];     
    NSString *appPath = [ws absolutePathForAppBundleWithIdentifier:@"org.vim.MacVim"];
    NSString *vimPath = [NSString stringWithFormat:@"%@/Contents/MacOS/Vim", appPath];
    
    // And start it
    NSTask *task = [[NSTask alloc] init];    
    [task setLaunchPath:vimPath];
    [task setArguments:args];
    [task launch];    
    [task release];
    task = nil;

    // Alternative 1: it should be possible to pass arguments to an app 
    // using launchApplicationAtURL, but the code below didn't work
    /*    NSURL * appURL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"org.vim.MacVim"];
     
     NSString * f = @"foo.txt"; 
     NSArray * args2 = [NSArray arrayWithObjects: f, nil]; 
     NSMutableDictionary* dict = [[NSMutableDictionary alloc] init]; 
     [dict setObject:args2 forKey:NSWorkspaceLaunchConfigurationArguments]; 
     [ws launchApplicationAtURL:appURL options:NSWorkspaceLaunchDefault configuration:dict error:nil]; 
     */

    // Alternative 2: using openFile only supports one file at the time    
    // [[NSWorkspace sharedWorkspace] openFile: output withApplication:@"MacVim"];
    //  [[NSWorkspace sharedWorkspace] launchApplication:@"MacVim"];
    
    return nil;
}


@end
