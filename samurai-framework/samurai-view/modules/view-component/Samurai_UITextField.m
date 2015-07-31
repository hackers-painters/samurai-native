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

#import "Samurai_UITextField.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUITextFieldAgent
{
	BOOL _enabled;
}

@def_prop_unsafe( UITextField *,			textField );

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[self disableEvents];
}

- (void)enableEvents
{
	if ( NO == _enabled )
	{
		[self.textField addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
		[self.textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
		[self.textField addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
		[self.textField addTarget:self action:@selector(editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		_enabled = YES;
	}
}

- (void)disableEvents
{
	if ( _enabled )
	{
		[self.textField removeTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
		[self.textField removeTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
		[self.textField removeTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
		[self.textField removeTarget:self action:@selector(editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		_enabled = NO;
	}
}

#pragma mark -

- (void)editingDidBegin:(id)sender
{
	if ( _enabled )
	{
		[self.textField sendSignal:UITextField.eventDidBeginEditing];
	}
}

- (void)editingChanged:(id)sender
{
	if ( _enabled )
	{
		[self.textField sendSignal:UITextField.eventChanged];
	}
}

- (void)editingDidEnd:(id)sender
{
	if ( _enabled )
	{
		[self.textField sendSignal:UITextField.eventDidEndEditing];
	}
}

- (void)editingDidEndOnExit:(id)sender
{
	if ( _enabled )
	{
		[self.textField sendSignal:UITextField.eventDidEndEditing];
	}
}

#pragma mark -

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	if ( _enabled )
	{
		[self.textField sendSignal:UITextField.eventClear];
	}

	return YES;
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ( _enabled )
	{
		[self.textField sendSignal:UITextField.eventReturn];
	}

	return YES;
}

@end

#pragma mark -

@implementation UITextField(Samurai)

@def_signal( eventDidBeginEditing );
@def_signal( eventDidEndEditing );
@def_signal( eventChanged );
@def_signal( eventClear );
@def_signal( eventReturn );

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UITextField * textField = [[self alloc] initWithFrame:CGRectZero];

	textField.renderer = renderer;

	textField.textColor = [UIColor darkGrayColor];
	textField.font = [UIFont systemFontOfSize:14.0f];
	textField.textAlignment = NSTextAlignmentLeft;
	textField.borderStyle = UITextBorderStyleNone;
	textField.clearsOnBeginEditing = NO;
	textField.adjustsFontSizeToFitWidth = NO;
	textField.minimumFontSize = 12.0f;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.clearsOnInsertion = NO;
	
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.spellCheckingType = UITextSpellCheckingTypeNo;
	
	textField.keyboardType = UIKeyboardTypeDefault;
	textField.keyboardAppearance = UIKeyboardAppearanceDefault;
	textField.returnKeyType = UIReturnKeyDefault;
	textField.enablesReturnKeyAutomatically = NO;
	textField.secureTextEntry = NO;
	
	[[textField textFieldAgent] enableEvents];

	return textField;
}

- (SamuraiUITextFieldAgent *)textFieldAgent
{
	SamuraiUITextFieldAgent * agent = [self getAssociatedObjectForKey:"UITextField.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUITextFieldAgent alloc] init];
		agent.textField = self;

		self.delegate = agent;

		[self retainAssociatedObject:agent forKey:"UITextField.agent"];
	}
	
	return agent;
}

#pragma mark -

- (CGRect)textRectForBounds:(CGRect)bounds
{
	return CGRectInset( bounds, 8, 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return CGRectInset( bounds, 8, 0 );
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

TEST_CASE( UI, UITextField )

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
