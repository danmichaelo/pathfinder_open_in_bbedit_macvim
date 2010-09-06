//
//  OpenInTextMate.m
//  pathfinder_open_in_textmate
//
//  Created by orta therox on 06/09/2010.
//  Copyright 2010 wgrids. All rights reserved.
//

#import "OpenInTextMate.h"


@implementation OpenInTextMate

@synthesize host;

+ (id)plugin:(id<NTPathFinderPluginHostProtocol>)pathfinder_host;
{
  OpenInTextMate* result = [[self alloc] init];
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
	
  menuItem = [[[NSMenuItem alloc] initWithTitle:@"Open in Textmate" action:@selector(pluginAction:) keyEquivalent:@"t"] autorelease];
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
  return [[[self host] selection:nil browserID:nil] count] == 1;
}

- (id)processItems:(NSArray*)items parameter:(id)parameter;
{
	if (!items)
		items = [self.host  selection:nil browserID:nil];
	
    // Look for the files selected and turn it into one nice string
  NSEnumerator* enumerator = [items objectEnumerator];
  NSString *path;
  id<NTFSItem> item;
	NSMutableString* output = [NSMutableString string];
	
  while (item = [enumerator nextObject])
   {
		path = [item path];
		
		if (path)
     {
			[output appendString:path];
     }
   }
  
    //This is a round about way of doing it, and there's the limit of
    // only allowing one file to be worked on at once but it's good enough for
    // the minute, and for me.
  
  [[NSWorkspace sharedWorkspace] openFile: output withApplication:@"TextMate"];
    
  return nil;
}


@end
