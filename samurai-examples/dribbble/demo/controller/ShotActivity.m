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

#import "ShotActivity.h"
#import "ThemeConfig.h"

#pragma mark -

@implementation ShotActivity

@def_model( SHOT *,						shot );
@def_model( ShotCommentListModel *,		listModel );
@def_outlet( RefreshCollectionView *,	list );

#pragma mark -

- (NSString *)templateName
{
	return @"dribbble-shot.html";
}

#pragma mark -

- (void)onCreate
{
	self.shot = [self.intent.input objectForKey:@"shot"];
	
	self.listModel = [ShotCommentListModel new];
	self.listModel.shot_id = self.shot.id;
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

	self.onSignal( ShotModel.eventLoading, ^{
		
	});
	
	self.onSignal( ShotModel.eventLoaded, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
		
		[self reloadData];
	});

	self.onSignal( ShotModel.eventError, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
	});
	
	self.onSignal( ShotCommentListModel.eventLoading, ^{
		
	});
	
	self.onSignal( ShotCommentListModel.eventLoaded, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
		
		[self reloadData];
	});
	
	self.onSignal( ShotCommentListModel.eventError, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
	});
}

- (void)onDestroy
{
	[self.listModel modelSave];
	[self.listModel removeSignalResponder:self];
	self.listModel = nil;
	
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
	self.scope[@"shot"] = @{
					  
		@"author" : @{
			@"avatar" : self.shot.user.avatar_url ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/avatars/normal/logo.png?1402322917",
            @"title" : self.shot.title ?: @"", // @"Product Homepage",
			@"name" : self.shot.user.name ?: @"", // @"Unity"
		},

		@"shot" : @{
			@"img" : self.shot.images.normal ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/screenshots/1914272/home_dribbble.png"
		},

		@"attr" : @{
			@"views" : @(self.shot.views_count), // @"6770",
			@"comments" : @(self.shot.comments_count), // @"19",
			@"likes" : @(self.shot.likes_count), // @"591"
		},

		@"comments" : ({
		  
			NSMutableArray * comments = [NSMutableArray array];

			for ( COMMENT * comment in self.listModel.comments )
			{
				[comments addObject:@{
					@"avatar" : comment.user.avatar_url, // @"https://d13yacurqjgara.cloudfront.net/users/162360/avatars/normal/logo.png?1402322917",
					@"name" : comment.user.name, // @"Eddy Gann",
					@"text" : comment.body, // @"Just a suggestion for a feature that means a lot to me: In-app web browser (so we can add the shot to buckets and like it.) Just adding a button to show it as it would appear in a mobile browser so we have access to the like button."
				}];
			}

			comments;
		})
	};
}

#pragma mark -

- (void)viewProfile:(SamuraiSignal *)signal
{
	[self startURL:@"/player" params:@{ @"player" : self.shot.user }];
}

- (void)viewComments:(SamuraiSignal *)signal
{
	COMMENT * comment = [self.listModel.comments objectAtIndex:signal.sourceIndexPath.row];
	
	[self startURL:@"/player" params:@{ @"player" : comment.user }];
}

- (void)viewPhoto:(SamuraiSignal *)signal
{
	[self startURL:@"/photo" params:@{ @"shot" : self.shot }];
}

@end
