//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_ViewTemplate.h"
#import "Samurai_App.h"
#import "Samurai_Watcher.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(ViewTemplateResponder)

@def_prop_dynamic_strong( SamuraiViewTemplate *, viewTemplate, setViewTemplate );

- (void)loadViewTemplate:(NSString *)urlOrFile
{
	[self loadViewTemplate:urlOrFile type:nil];
}

- (void)loadViewTemplate:(NSString *)urlOrFile type:(NSString *)type
{
	if ( nil == self.viewTemplate )
	{
		self.viewTemplate = [[SamuraiViewTemplate alloc] init];
		self.viewTemplate.responder = self;
	}

	if ( [urlOrFile hasPrefix:@"http://"] || [urlOrFile hasPrefix:@"https://"] )
	{
		[self.viewTemplate loadURL:urlOrFile type:type];
	}
	else if ( [urlOrFile hasPrefix:@"//"] )
	{
		urlOrFile = [NSString stringWithFormat:@"http:%@", urlOrFile];

		[self.viewTemplate loadURL:urlOrFile type:type];
	}
	else if ( [urlOrFile hasPrefix:@"file://"] )
	{
		[self.viewTemplate loadFile:[urlOrFile stringByReplacingOccurrencesOfString:@"file://" withString:@"/"]];
	}
	else if ( [urlOrFile hasPrefix:@"/"] )
	{
		[self.viewTemplate loadFile:urlOrFile];
	}
	else
	{
		Class classType = NSClassFromString( urlOrFile );
		if ( classType )
		{
			[self.viewTemplate loadClass:classType];
		}
		else
		{
			[self.viewTemplate loadFile:urlOrFile];
		}
	}
}

- (void)handleViewTemplate:(SamuraiViewTemplate *)viewTemplate
{
}

@end

#pragma mark -

@implementation SamuraiViewTemplate
{
	NSMutableArray *			_resourceQueue;
	SamuraiResourceFetcher *	_resourceFetcher;
}

@def_joint( stateChanged );

@def_prop_strong( SamuraiDocument *,		document );
@def_prop_assign( BOOL,						responderDisabled );
@def_prop_unsafe( id,						responder );

@def_prop_copy( BlockType,					stateChanged );
@def_prop_assign( ViewTemplateState,		state );
@def_prop_dynamic( BOOL,					created );
@def_prop_dynamic( BOOL,					loading );
@def_prop_dynamic( BOOL,					loaded );
@def_prop_dynamic( BOOL,					failed );
@def_prop_dynamic( BOOL,					cancelled );

+ (SamuraiViewTemplate *)viewTemplate
{
	return [[SamuraiViewTemplate alloc] init];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.document = nil;
		
		self.responderDisabled = NO;
		self.responder = nil;
		
		self.stateChanged = nil;
		self.state = ViewTemplateState_Created;
		
		_resourceQueue = [[NSMutableArray alloc] init];
		_resourceFetcher = [SamuraiResourceFetcher resourceFetcher];
		_resourceFetcher.responder = self;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFileChanged:) name:SamuraiWatcher.SourceFileDidChanged object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFileRemoved:) name:SamuraiWatcher.SourceFileDidRemoved object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if ( self.document.renderTree && self.document.renderTree.view )
	{
		[self.document.renderTree.view removeFromSuperview];
	}
	
	self.document = nil;
	self.responder = nil;

	self.stateChanged = nil;

	_resourceFetcher.responder = nil;
	[_resourceFetcher cancel];
	_resourceFetcher = nil;
	
	[_resourceQueue removeAllObjects];
	_resourceQueue = nil;
}

#pragma mark -

- (BOOL)created
{
	return _state == ViewTemplateState_Created ? YES : NO;
}

- (BOOL)loading
{
	return _state == ViewTemplateState_Loading ? YES : NO;
}

- (BOOL)loaded
{
	return _state == ViewTemplateState_Loaded ? YES : NO;
}

- (BOOL)failed
{
	return _state == ViewTemplateState_Failed ? YES : NO;
}

- (BOOL)cancelled
{
	return _state == ViewTemplateState_Cancelled ? YES : NO;
}

#pragma mark -

- (BOOL)changeState:(ViewTemplateState)newState
{
//	static const char * __states[] = {
//		"!Created",
//		"!Loading",
//		"!Loaded",
//		"!Failed",
//		"!Cancelled"
//	};

	if ( newState == self.state )
		return NO;
	
	triggerBefore( self, stateChanged );

	INFO( @"ViewTemplate '%p', state %d -> %d", self, _state, newState );

	self.state = newState;

	if ( ViewTemplateState_Loading == _state )
	{
		INFO( @"ViewTemplate '%p', loading", self );
	}
	else if ( ViewTemplateState_Loaded == _state )
	{
		INFO( @"ViewTemplate '%p', loaded", self );
	}
	else if ( ViewTemplateState_Failed == _state )
	{
		ERROR( @"ViewTemplate '%p', failed", self );
	}
	else if ( ViewTemplateState_Cancelled == _state )
	{
		ERROR( @"ViewTemplate '%p', cancelled", self );
	}

	if ( NO == self.responderDisabled )
	{
		if ( self.responder )
		{
			[self.responder handleViewTemplate:self];
		}
		
		if ( self.stateChanged )
		{
			((BlockTypeVarg)self.stateChanged)( self );
		}
	}
	
	triggerAfter( self, stateChanged );
	
	return YES;
}

#pragma mark -

- (void)loadClass:(Class)clazz
{
	ASSERT( nil != clazz );

	self.state = ViewTemplateState_Created;
	self.document = [SamuraiDocument resourceForClass:clazz];
	
	[self loadMainResource:self.document];
}

- (void)loadFile:(NSString *)file
{
	ASSERT( nil != file );

	self.state = ViewTemplateState_Created;
	self.document = [SamuraiDocument resourceAtPath:file];
	
	[self loadMainResource:self.document];
}

- (void)loadURL:(NSString *)url type:(NSString *)type
{
	ASSERT( nil != url );

	self.state = ViewTemplateState_Created;
	self.document = [SamuraiDocument resourceWithURL:url type:type];
	
	[self loadMainResource:self.document];
}

- (void)stopLoading
{
	[_resourceFetcher cancel];

	if ( ViewTemplateState_Loading == self.state )
	{
		[self changeState:ViewTemplateState_Cancelled];
	}
}

#pragma mark -

- (void)loadMainResource:(SamuraiResource *)resource
{
	[_resourceFetcher cancel];

	if ( nil == resource )
	{
		[self changeState:ViewTemplateState_Failed];
	}
	else
	{
		[self changeState:ViewTemplateState_Loading];
		
		[_resourceQueue removeAllObjects];
		[_resourceQueue addObject:resource];
		
		[self loadResource:resource];
	}
}

- (void)loadResource:(SamuraiResource *)resource
{
	ASSERT( nil != resource );
	
	INFO( @"ViewTemplate '%p', loading '%@'", self, resource.resPath );
	
	if ( [resource isRemote] )
	{
		[self fetchRemoteResource:resource];
	}
	else
	{
		[self fetchLocalResource:resource];
	}
}

- (void)fetchRemoteResource:(SamuraiResource *)resource
{
	[_resourceFetcher queue:resource];
}

- (void)fetchLocalResource:(SamuraiResource *)resource
{
	BOOL succeed = [resource parse];
	if ( succeed )
	{
		[self handleResourceLoaded:resource];
	}
	else
	{
		[self handleResourceFailed:resource];
	}
}

#pragma mark -

- (void)handleResourceLoaded:(SamuraiResource *)resource
{
	if ( [resource isKindOfClass:[SamuraiDocument class]] )
	{
		SamuraiDocument * document = (SamuraiDocument *)resource;
		
	// Load sub-resources in document

		NSMutableArray * array = [NSMutableArray array];

		[array addObjectsFromArray:document.externalStylesheets];
		[array addObjectsFromArray:document.externalScripts];
		[array addObjectsFromArray:document.externalImports];

		[_resourceQueue addObjectsFromArray:array];

		for ( SamuraiResource * resource in array )
		{
			[self loadResource:resource];
		}
	}

	[_resourceQueue removeObject:resource];

	if ( 0 == [_resourceQueue count] )
	{
		BOOL succeed = [self.document reflow];
		if ( succeed )
		{
			[self changeState:ViewTemplateState_Loaded];
		}
		else
		{
			[_resourceFetcher cancel];
			
			[self changeState:ViewTemplateState_Failed];
		}
	}
}

- (void)handleResourceFailed:(SamuraiResource *)resource
{
	[_resourceFetcher cancel];
	
	[self changeState:ViewTemplateState_Failed];
}

- (void)handleResourceCancelled:(SamuraiResource *)resource
{
	[_resourceFetcher cancel];
	
	[self changeState:ViewTemplateState_Cancelled];
}

#pragma mark -

- (BOOL)document:(SamuraiDocument *)document includeResourceOfPath:(NSString *)path
{
	path = [path lastPathComponent];
	
	if ( [path isEqualToString:[document.resPath lastPathComponent]] )
	{
		return YES;
	}

	for ( SamuraiStyleSheet * styleSheet in [document.externalStylesheets copy] )
	{
		if ( [path isEqualToString:[styleSheet.resPath lastPathComponent]] )
		{
			return YES;
		}
	}

	for ( SamuraiScript * script in [document.externalScripts copy] )
	{
		if ( [path isEqualToString:[script.resPath lastPathComponent]] )
		{
			return YES;
		}
	}

	for ( SamuraiResource * resource in [document.externalImports copy] )
	{
		if ( [resource isKindOfClass:[SamuraiDocument class]] )
		{
			BOOL included = [self document:(SamuraiDocument *)resource includeResourceOfPath:path];
			if ( included )
			{
				return YES;
			}
		}
	}

	return NO;
}

- (void)didFileChanged:(NSNotification *)notification
{
	NSString * path = notification.object;

	if ( self.document )
	{
		BOOL needReload = [self document:self.document includeResourceOfPath:path];
		if ( needReload )
		{
			[self loadFile:self.document.resPath];
		}
	}
}

- (void)didFileRemoved:(NSNotification *)notification
{
	NSString * path = notification.object;

	if ( self.document )
	{
		BOOL needReload = [self document:self.document includeResourceOfPath:path];
		if ( needReload )
		{
			[self loadFile:self.document.resPath];
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ViewTemplate )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
