// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the Ruby's license or the GPL2.

#import "ChannelDialog.h"
#import "NSWindowHelper.h"
#import "NSStringHelper.h"


@interface ChannelDialog (Private)
- (void)load;
- (void)save;
- (void)update;
@end


@implementation ChannelDialog

@synthesize delegate;
@synthesize window;
@synthesize parentWindow;
@synthesize uid;
@synthesize cid;
@synthesize config;

- (id)init
{
	if (self = [super init]) {
		[NSBundle loadNibNamed:@"ChannelDialog" owner:self];
	}
	return self;
}

- (void)dealloc
{
	[window release];
	[config release];
	[super dealloc];
}

- (void)start
{
	if (cid < 0) {
		[self.window setTitle:@"New Channel"];
	}
	else {
		[nameText setEditable:NO];
		[nameText setSelectable:NO];
		[nameText setBezeled:NO];
		[nameText setDrawsBackground:NO];
	}
	
	[self load];
	[self update];
	[self show];
}

- (void)show
{
	if (![self.window isVisible]) {
		[self.window centerOfWindow:parentWindow];
	}
	[self.window makeKeyAndOrderFront:nil];
}

- (void)close
{
	delegate = nil;
	[self.window close];
}

- (void)load
{
	nameText.stringValue = config.name;
	passwordText.stringValue = config.password;
	modeText.stringValue = config.mode;
	topicText.stringValue = config.topic;
	
	autoJoinCheck.state = config.autoJoin;
	consoleCheck.state = config.logToConsole;
	growlCheck.state = config.growl;
}

- (void)save
{
	config.name = nameText.stringValue;
	config.password = passwordText.stringValue;
	config.mode = modeText.stringValue;
	config.topic = topicText.stringValue;

	config.autoJoin = autoJoinCheck.state;
	config.logToConsole = consoleCheck.state;
	config.growl = growlCheck.state;
}

- (void)update
{
	NSString* s = nameText.stringValue;
	[okButton setEnabled:[s isChannelName]];
}

- (void)controlTextDidChange:(NSNotification*)note
{
	[self update];
}

#pragma mark -
#pragma mark Actions

- (void)ok:(id)sender
{
	[self save];
	
	if ([delegate respondsToSelector:@selector(channelDialogOnOK:)]) {
		[delegate channelDialogOnOK:self];
	}
	
	[self.window close];
}

- (void)cancel:(id)sender
{
	[self.window close];
}

#pragma mark -
#pragma mark NSWindow Delegate

- (void)windowWillClose:(NSNotification*)note
{
	if ([delegate respondsToSelector:@selector(channelDialogWillClose:)]) {
		[delegate channelDialogWillClose:self];
	}
}

@end