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

#import "Samurai_UITextView.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUITextViewAgent
{
	BOOL _enabled;
}

@def_prop_unsafe( UITextView *,	textView );

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[self disableEvents];
}

- (void)enableEvents
{
	_enabled = YES;
}

- (void)disableEvents
{
	_enabled = NO;
}

#pragma mark -

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if ( _enabled )
	{
		[self.textView sendSignal:UITextView.eventDidBeginEditing];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ( _enabled )
	{
		[self.textView sendSignal:UITextView.eventDidEndEditing];
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	if ( _enabled )
	{
		[self.textView sendSignal:UITextView.eventChanged];
	}
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
	return YES;
}

@end

#pragma mark -

@implementation UITextView(Samurai)

@def_signal( eventDidBeginEditing );
@def_signal( eventDidEndEditing );
@def_signal( eventChanged );

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UITextView * textView = [[self alloc] initWithFrame:CGRectZero];
	
	textView.renderer = renderer;
	
	textView.textColor = [UIColor darkGrayColor];
	textView.font = [UIFont systemFontOfSize:14.0f];
	textView.textAlignment = NSTextAlignmentLeft;
	textView.clearsOnInsertion = NO;
	textView.editable = YES;
	textView.selectable = YES;

	textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textView.autocorrectionType = UITextAutocorrectionTypeNo;
	textView.spellCheckingType = UITextSpellCheckingTypeNo;
	
	textView.keyboardType = UIKeyboardTypeDefault;
	textView.keyboardAppearance = UIKeyboardAppearanceDefault;
	textView.returnKeyType = UIReturnKeyDefault;
	textView.enablesReturnKeyAutomatically = NO;
	textView.secureTextEntry = NO;
	
	[[textView textViewAgent] enableEvents];
	
	return textView;
}

- (SamuraiUITextViewAgent *)textViewAgent
{
	SamuraiUITextViewAgent * agent = [self getAssociatedObjectForKey:"UITextView.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUITextViewAgent alloc] init];
		agent.textView = self;
		
		self.delegate = agent;
		
		[self retainAssociatedObject:agent forKey:"UITextView.agent"];
	}
	
	return agent;
}

#pragma mark -

+ (BOOL)supportTapGesture
{
	return NO;
}

+ (BOOL)supportSwipeGesture
{
	return NO;
}

+ (BOOL)supportPinchGesture
{
	return NO;
}

+ (BOOL)supportPanGesture
{
	return NO;
}

#pragma mark -

- (id)serialize
{
	return self.text;
}

- (void)unserialize:(id)obj
{
	self.text = [obj toString];
}

- (void)zerolize
{
	self.text = nil;
}

#pragma mark -

- (void)applyDom:(SamuraiDomNode *)dom
{
	[super applyDom:dom];
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
	[super applyStyle:style];
}

- (void)applyFrame:(CGRect)frame
{
	[super applyFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size
{
	if ( nil == self.text || 0 == self.text.length )
	{
		return CGSizeZero;
	}
	
	NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
	NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
	
	if ( INVALID_VALUE == size.width && INVALID_VALUE == size.height )
	{
		CGSize bound = CGSizeMake(HUGE_VALF, HUGE_VALF/*fmaxf(self.font.lineHeight, self.font.pointSize)*/);
		CGSize result = [self.text boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
//		result.width = ceilf( result.width );
//		result.height = ceilf( result.height );
		return result;
	}
	else if ( INVALID_VALUE != size.width && INVALID_VALUE != size.height )
	{
		CGSize result = [self.text boundingRectWithSize:size options:options attributes:attribute context:nil].size;
//		result.width = ceilf( result.width );
//		result.height = ceilf( result.height );
		return result;
	}
	else
	{
		if ( INVALID_VALUE != size.width )
		{
			CGSize bound = CGSizeMake(size.width, HUGE_VALF);
			CGSize result = [self.text boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else if ( INVALID_VALUE != size.height )
		{
			CGSize bound = CGSizeMake(HUGE_VALF, size.height);
			CGSize result = [self.text boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			CGSize result = [self.text boundingRectWithSize:size options:options attributes:attribute context:nil].size;
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
	}
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	if ( INVALID_VALUE == width )
	{
		return [self computeSizeBySize:CGSizeMake( width, INVALID_VALUE )];
	}
	else
	{
		if ( nil == self.text || 0 == self.text.length )
		{
			return CGSizeMake( 0.0f, 0.0f );
		}
		
		NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
		NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
		
		CGSize result = [self.text boundingRectWithSize:CGSizeMake(width, HUGE_VALF) options:options attributes:attribute context:nil].size;
//		result.width = ceilf( result.width );
//		result.height = ceilf( result.height );
		return result;
	}
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	if ( INVALID_VALUE == height )
	{
		return [self computeSizeBySize:CGSizeMake( INVALID_VALUE, height )];
	}
	else
	{
		if ( nil == self.text || 0 == self.text.length )
		{
			return CGSizeMake( 0.0f, 0.0f );
		}
		
		NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
		NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
		
		CGSize result = [self.text boundingRectWithSize:CGSizeMake(HUGE_VALF, height) options:options attributes:attribute context:nil].size;
//		result.width = ceilf( result.width );
//		result.height = ceilf( result.height );
		return result;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UITextView )

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
