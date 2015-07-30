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

#import "Samurai_Template.h"
#import "Samurai_App.h"
#import "Samurai_Watcher.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(TemplateResponder)

@def_prop_dynamic_strong( SamuraiTemplate *, template, setTemplate );

- (void)loadTemplate:(NSString *)urlOrFile
{
	[self loadTemplate:urlOrFile type:nil];
}

- (void)loadTemplate:(NSString *)urlOrFile type:(NSString *)type
{
	if ( nil == self.template )
	{
		self.template = [[SamuraiTemplate alloc] init];
		self.template.responder = self;
	}

	if ( [urlOrFile hasPrefix:@"http://"] || [urlOrFile hasPrefix:@"https://"] )
	{
		[self.template loadURL:urlOrFile type:type];
	}
	else if ( [urlOrFile hasPrefix:@"//"] )
	{
		urlOrFile = [NSString stringWithFormat:@"http:%@", urlOrFile];

		[self.template loadURL:urlOrFile type:type];
	}
	else if ( [urlOrFile hasPrefix:@"file://"] )
	{
		[self.template loadFile:[urlOrFile stringByReplacingOccurrencesOfString:@"file://" withString:@"/"]];
	}
	else if ( [urlOrFile hasPrefix:@"/"] )
	{
		[self.template loadFile:urlOrFile];
	}
	else
	{
		Class classType = NSClassFromString( urlOrFile );
		if ( classType )
		{
			[self.template loadClass:classType];
		}
		else
		{
			[self.template loadFile:urlOrFile];
		}
	}
}

- (void)handleTemplate:(SamuraiTemplate *)template
{
}

@end

#pragma mark -

@implementation SamuraiTemplate
{
	NSMutableArray *			_resourceQueue;
	SamuraiResourceFetcher *	_resourceFetcher;
}

@def_joint( stateChanged );

@def_prop_strong( SamuraiDocument *,		document );
@def_prop_assign( BOOL,						responderDisabled );
@def_prop_unsafe( id,						responder );

@def_prop_copy( BlockType,					stateChanged );
@def_prop_assign( TemplateState,		state );
@def_prop_dynamic( BOOL,					created );
@def_prop_dynamic( BOOL,					loading );
@def_prop_dynamic( BOOL,					loaded );
@def_prop_dynamic( BOOL,					failed );
@def_prop_dynamic( BOOL,					cancelled );

+ (SamuraiTemplate *)template
{
	return [[SamuraiTemplate alloc] init];
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
		self.state = TemplateState_Created;
		
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
	return _state == TemplateState_Created ? YES : NO;
}

- (BOOL)loading
{
	return _state == TemplateState_Loading ? YES : NO;
}

- (BOOL)loaded
{
	return _state == TemplateState_Loaded ? YES : NO;
}

- (BOOL)failed
{
	return _state == TemplateState_Failed ? YES : NO;
}

- (BOOL)cancelled
{
	return _state == TemplateState_Cancelled ? YES : NO;
}

#pragma mark -

- (BOOL)changeState:(TemplateState)newState
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

	PERF( @"Template '%p', state %d -> %d", self, _state, newState );

	self.state = newState;

	if ( TemplateState_Loading == _state )
	{
		PERF( @"Template '%p', loading", self );
	}
	else if ( TemplateState_Loaded == _state )
	{
		PERF( @"Template '%p', loaded", self );
	}
	else if ( TemplateState_Failed == _state )
	{
		ERROR( @"Template '%p', failed", self );
	}
	else if ( TemplateState_Cancelled == _state )
	{
		ERROR( @"Template '%p', cancelled", self );
	}

	if ( NO == self.responderDisabled )
	{
		if ( self.responder )
		{
			[self.responder handleTemplate:self];
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

	self.state = TemplateState_Created;
	self.document = [SamuraiDocument resourceForClass:clazz];
	
	[self loadMainResource:self.document];
}

- (void)loadFile:(NSString *)file
{
	ASSERT( nil != file );

	self.state = TemplateState_Created;
	self.document = [SamuraiDocument resourceAtPath:file];
	
	[self loadMainResource:self.document];
}

- (void)loadURL:(NSString *)url type:(NSString *)type
{
	ASSERT( nil != url );

	self.state = TemplateState_Created;
	self.document = [SamuraiDocument resourceWithURL:url type:type];
	
	[self loadMainResource:self.document];
}

- (void)stopLoading
{
	[_resourceFetcher cancel];

	if ( TemplateState_Loading == self.state )
	{
		[self changeState:TemplateState_Cancelled];
	}
}

#pragma mark -

- (void)loadMainResource:(SamuraiResource *)resource
{
	[_resourceFetcher cancel];

	if ( nil == resource )
	{
		[self changeState:TemplateState_Failed];
	}
	else
	{
		[self changeState:TemplateState_Loading];
		
		[_resourceQueue removeAllObjects];
		[_resourceQueue addObject:resource];
		
		[self loadResource:resource];
	}
}

- (void)loadResource:(SamuraiResource *)resource
{
	ASSERT( nil != resource );
	
	INFO( @"Template '%p', loading '%@'", self, resource.resPath );
	
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
			[self changeState:TemplateState_Loaded];
		}
		else
		{
			[_resourceFetcher cancel];
			
			[self changeState:TemplateState_Failed];
		}
	}
}

- (void)handleResourceFailed:(SamuraiResource *)resource
{
	[_resourceFetcher cancel];
	
	[self changeState:TemplateState_Failed];
}

- (void)handleResourceCancelled:(SamuraiResource *)resource
{
	[_resourceFetcher cancel];
	
	[self changeState:TemplateState_Cancelled];
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

TEST_CASE( UI, Template )

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
