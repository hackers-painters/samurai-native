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

#import "PhotoActivity.h"
#import "ThemeConfig.h"

#pragma mark -

@implementation PhotoActivity

@def_model( SHOT *,				shot );

@def_outlet( UIImageView *,		photo );

#pragma mark -

- (NSString *)templateName
{
	return @"dribbble-photo.html";
}

#pragma mark -

- (void)onCreate
{
	self.navigationBarDoneButton = @"Save";
	
	self.shot = [self.intent.input objectForKey:@"shot"];
}

- (void)onDestroy
{
	self.shot = nil;
}

- (void)onStart
{
}
 
- (void)onResume
{
}

- (void)onPause
{
}

- (void)onStop
{
}

- (void)onLayout
{
}

#pragma mark -

- (void)onBackPressed
{
	
}

- (void)onDonePressed
{
	if ( self.photo && self.photo.image )
	{
		UIImageWriteToSavedPhotosAlbum( self.photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
	}
}

#pragma mark -

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if ( error )
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
														 message:@"Failed to save image"
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		[alert show];
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
														 message:@"Image saved"
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		[alert show];
	}
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
	[self reloadData];
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)reloadData
{
    self.scope[@"photo"] = self.shot.images.normal ?: @"";
}

@end
