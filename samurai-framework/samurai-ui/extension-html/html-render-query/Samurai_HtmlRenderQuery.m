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

#import "Samurai_HtmlRenderQuery.h"
#import "Samurai_HtmlRenderObject.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiRenderQuery(Html)

@def_prop_dynamic( SamuraiRenderQueryBlockN,	ATTR );
@def_prop_dynamic( SamuraiRenderQueryBlockN,	SET_CLASS );
@def_prop_dynamic( SamuraiRenderQueryBlockN,	ADD_CLASS );
@def_prop_dynamic( SamuraiRenderQueryBlockN,	REMOVE_CLASS );
@def_prop_dynamic( SamuraiRenderQueryBlockN,	TOGGLE_CLASS );

#pragma mark -

- (SamuraiRenderQueryBlockN)ATTR
{
	@weakify( self )
	
	SamuraiRenderQueryBlockN block = (SamuraiRenderQueryBlockN)^ SamuraiRenderQuery * ( NSString * key, NSString * value )
	{
		@strongify( self )

		if ( key && value )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				BOOL changed = [renderObject setStyleValue:value forKey:key];
				if ( changed  )
				{
					[renderObject restyle];
				}
			}
		}
		
		return self;
	};

	return [block copy];
}

- (SamuraiRenderQueryBlockN)SET_CLASS
{
	@weakify( self )
	
	SamuraiRenderQueryBlockN block = (SamuraiRenderQueryBlockN)^ SamuraiRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				BOOL changed = [renderObject setStyleClasses:classes];
				if ( changed )
				{
					[renderObject restyle];
				}
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiRenderQueryBlockN)ADD_CLASS
{
	@weakify( self )
	
	SamuraiRenderQueryBlockN block = (SamuraiRenderQueryBlockN)^ SamuraiRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				BOOL changed = [renderObject addStyleClasses:classes];
				if ( changed )
				{
					[renderObject restyle];
				}
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiRenderQueryBlockN)REMOVE_CLASS
{
	@weakify( self )
	
	SamuraiRenderQueryBlockN block = (SamuraiRenderQueryBlockN)^ SamuraiRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				BOOL changed = [renderObject removeStyleClasses:classes];
				if ( changed )
				{
					[renderObject restyle];
				}
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiRenderQueryBlockN)TOGGLE_CLASS
{
	@weakify( self )
	
	SamuraiRenderQueryBlockN block = (SamuraiRenderQueryBlockN)^ SamuraiRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				BOOL changed = [renderObject toggleStyleClasses:classes];
				if ( changed )
				{
					[renderObject restyle];
				}
			}
		}

		return self;
	};
	
	return [block copy];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlRenderQuery )
{
//	TODO( @"test case" )
}
TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
