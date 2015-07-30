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

#import "IndexActivity.h"
#import "ThemeConfig.h"

#pragma mark -

@implementation IndexActivity
{
	NSUInteger				_currentIndex;
	ShotListModel *			_currentModel;
}

@def_model( PopularShotListModel *,		model1 );
@def_model( DebutsShotListModel *,		model2 );
@def_model( EveryoneShotListModel *,	model3 );

@def_outlet( RefreshCollectionView *,	list );
@def_outlet( UIView *,					tab1 );
@def_outlet( UIView *,					tab2 );
@def_outlet( UIView *,					tab3 );

#pragma mark -

- (NSString *)templateName
{
	return @"dribbble-index.html";
}

#pragma mark -

- (void)onCreate
{
	self.navigationBarDoneButton = @"Change theme";

	self.model1 = [PopularShotListModel new];
	self.model2 = [DebutsShotListModel new];
	self.model3 = [EveryoneShotListModel new];

	[self.model1 addSignalResponder:self];
	[self.model2 addSignalResponder:self];
	[self.model3 addSignalResponder:self];

	[self.model1 modelLoad];
	[self.model2 modelLoad];
	[self.model3 modelLoad];
	
	@weakify( self );

	self.onSignal( RefreshCollectionView.eventPullToRefresh, ^{
		
		@strongify( self );

		[self refresh];
	});
	
	self.onSignal( RefreshCollectionView.eventLoadMore, ^{
		
		@strongify( self );

		[self loadMore];
	});

	self.onSignal( ShotListModel.eventLoading, ^{
		
		@strongify( self );

		if ( 0 == [_currentModel.shots count] )
		{
			[self showLoading];
		}
	});
	
	self.onSignal( ShotListModel.eventLoaded, ^{
		
		@strongify( self );

		[self hideLoading];
		
		[self.list stopLoading];
		
		[self reloadData];
	});
	
	self.onSignal( ShotListModel.eventError, ^{
		
		@strongify( self );

		[self hideLoading];
		
		[self.list stopLoading];
	});

	_currentIndex = 0;
	_currentModel = self.model1;
}

- (void)onDestroy
{
	[self.model1 removeSignalResponder:self];
	[self.model1 modelSave];
	
	[self.model2 removeSignalResponder:self];
	[self.model2 modelSave];

	[self.model3 removeSignalResponder:self];
	[self.model3 modelSave];

	self.model1 = nil;
	self.model2 = nil;
	self.model3 = nil;
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
	if ( [[ThemeConfig sharedInstance].theme isEqualToString:@"pink"] )
	{
		[[ThemeConfig sharedInstance] changeTheme:@"white"];
	}
	else
	{
		[[ThemeConfig sharedInstance] changeTheme:@"pink"];
	}
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{	
	[self switchTab:0];
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)switchTab:(NSUInteger)newIndex
{
	if ( _currentIndex != newIndex )
	{
		CATransition * animation = [CATransition animation];
		if ( animation )
		{
			[animation setDuration:0.5f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
			[animation setType:kCATransitionPush];
			[animation setRemovedOnCompletion:YES];
			
			if ( newIndex < _currentIndex )
			{
				[animation setSubtype:kCATransitionFromLeft];
			}
			else
			{
				[animation setSubtype:kCATransitionFromRight];
			}

			[self.list.layer addAnimation:animation forKey:@"push"];
		}
		
		_currentIndex = newIndex;
	}
	
	if ( 0 == _currentIndex )
	{
//		$(@"#tab1").ADD_CLASS( @"active" );
//		$(@"#tab2").REMOVE_CLASS( @"active" );
//		$(@"#tab3").REMOVE_CLASS( @"active" );
		
		_currentModel = self.model1;
		
		[self.tab1.htmlRenderer.customClasses addObject:@"active"];
	}
	else
	{
		[self.tab1.htmlRenderer.customClasses removeObject:@"active"];
	}
	
	if ( 1 == _currentIndex )
	{
		_currentModel = self.model2;
		
		[self.tab2.htmlRenderer.customClasses addObject:@"active"];
	}
	else
	{
		[self.tab2.htmlRenderer.customClasses removeObject:@"active"];
	}
	
	if ( 2 == _currentIndex )
	{
		_currentModel = self.model3;
		
		[self.tab3.htmlRenderer.customClasses addObject:@"active"];
	}
	else
	{
		[self.tab3.htmlRenderer.customClasses removeObject:@"active"];
	}

	[self.tab1 restyle];
	[self.tab2 restyle];
	[self.tab3 restyle];
	
	[self reloadData];
	
	[_currentModel refresh];
	
	[self.list setContentOffset:CGPointZero animated:NO];
//	[self.list reloadData];
}

#pragma mark -

- (void)refresh
{
	[_currentModel refresh];
}

- (void)loadMore
{
	if ( [_currentModel more] )
	{
		[_currentModel loadMore];
	}
	else
	{
		[self.list stopLoading];
	}
}

- (void)reloadData
{
	self.scope[ @"tabbar.popular" ]	= _currentModel == self.model1 ? @"/Popular/" : @"Popular";
	self.scope[ @"tabbar.debuts" ]		= _currentModel == self.model2 ? @"/Debuts/" : @"Debuts";
	self.scope[ @"tabbar.everyone" ]	= _currentModel == self.model3 ? @"/Everyone/" : @"Everyone";
	self.scope[ @"list" ] = @{
						
		@"section-shots" : ({
			
			NSMutableArray * shots = [NSMutableArray array];

			for ( SHOT * shot in _currentModel.shots )
			{
				[shots addObject : @{

					@"author" : @{
						@"avatar"	: shot.user.avatar_url ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/avatars/normal/logo.png?1402322917",
						@"title"	: shot.title ?: @"", // @"Product Homepage",
						@"name"		: shot.user.name ?: @"", // @"Unity"
					},

					@"shot-url"		: shot.images.normal ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/screenshots/1914272/home_dribbble.png"

					@"attr" : @{
						@"views"	: @(shot.views_count), // @"6770",
						@"comments"	: @(shot.comments_count), // @"19",
						@"likes"	: @(shot.likes_count), // @"591"
					}
				}];
			}
			
			shots;
		})
	};

	[self relayout];
}

#pragma mark -

- (void)switchTab1:(SamuraiSignal *)signal
{
	[self switchTab:0];
}

- (void)switchTab2:(SamuraiSignal *)signal
{
	[self switchTab:1];
}

- (void)switchTab3:(SamuraiSignal *)signal
{
	[self switchTab:2];
}

- (void)prevTab:(SamuraiSignal *)signal
{
	if ( _currentIndex > 0 )
	{
		[self switchTab:_currentIndex - 1];
	}
	else
	{
		[self switchTab:2];
	}
}

- (void)nextTab:(SamuraiSignal *)signal
{
	if ( _currentIndex < 2 )
	{
		[self switchTab:_currentIndex + 1];
	}
	else
	{
		[self switchTab:0];
	}
}

- (void)viewShot:(SamuraiSignal *)signal
{
	SHOT * shot = [_currentModel.shots objectAtIndex:signal.sourceIndexPath.row];
	
	[self startURL:@"/shot" params:@{ @"shot" : shot }];
}

- (void)viewProfile:(SamuraiSignal *)signal
{
	SHOT * shot = [_currentModel.shots objectAtIndex:signal.sourceIndexPath.row];
	
	[self startURL:@"/player" params:@{ @"player" : shot.user }];
}

@end
