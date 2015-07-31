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

#import "PlayerActivity.h"
#import "ThemeConfig.h"

#pragma mark -

@implementation PlayerActivity

@def_model( USER *,						player );
@def_model( PlayerShotListModel *,		listModel );

@def_outlet( RefreshCollectionView *,	list );

#pragma mark -

- (NSString *)templateName
{
	return @"dribbble-player.html";
}

#pragma mark -

- (void)onCreate
{
	self.player = self.intent.input[@"player"];
	
	self.listModel = [PlayerShotListModel new];
	self.listModel.player_id = self.player.id;
	[self.listModel addSignalResponder:self];
	[self.listModel modelLoad];

	@weakify( self );
	
	self.onSignal( RefreshCollectionView.eventPullToRefresh, ^{
		
		@strongify( self );
		
		[self refresh];
	});
	
	self.onSignal( RefreshCollectionView.eventLoadMore, ^{
		
		@strongify( self );
		
		[self loadMore];
	});
	
	self.onSignal( PlayerModel.eventLoading, ^{
		
	});

	self.onSignal( PlayerModel.eventLoaded, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
		
		[self reloadData];
	});
	
	self.onSignal( PlayerModel.eventError, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
	});

	self.onSignal( PlayerShotListModel.eventLoading, ^{
		
	});
	
	self.onSignal( PlayerShotListModel.eventLoaded, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
		
		[self reloadData];
	});
	
	self.onSignal( PlayerShotListModel.eventError, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
	});
}

- (void)onDestroy
{
	[self.listModel modelSave];
	[self.listModel removeSignalResponder:self];
	self.listModel = nil;
	
	self.player = nil;
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
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
	[self refresh];
	[self reloadData];
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)refresh
{
	[self.listModel refresh];
}

- (void)loadMore
{
	if ( [self.listModel more] )
	{
		[self.listModel loadMore];
	}
	else
	{
		[self.list stopLoading];
	}
}

- (void)reloadData
{
	self.scope[@"player"] = @{

		@"author" : @{
			@"avatar" : self.player.avatar_url ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/avatars/normal/logo.png?1402322917",
			@"name" : self.player.name ?: @"", // @"Vadim Sherbakov",
			@"location" : self.player.location ?: @"", // @"San Francisco, CA"
		},
		
		@"profile" : @{
			@"followers" : @(self.player.followers_count) ?: @"",
			@"followings" : @(self.player.followings_count) ?: @"",
		},
		
		@"contact" : @{
			@"twitter" : self.player.links.twitter ?: @"",
			@"website" : self.player.links.web ?: @"",
			@"dribbble" : self.player.username ?: @"",
		},

		@"shots" : ({
			
			NSMutableArray * shots = [NSMutableArray array];
			
			for ( SHOT * shot in self.listModel.shots )
			{
				[shots addObject:@{ @"shot-url" : shot.images.teaser ?: @"" }];
			}
			
			shots;
		})
	};
}

#pragma mark -

- (void)viewShot:(SamuraiSignal *)signal
{
	SHOT * shot = [self.listModel.shots objectAtIndex:signal.sourceIndexPath.row];

    shot.user = self.player;
    
	[self startURL:@"/shot" params:@{ @"shot" : shot }];
}

@end
