//
//  MovieListViewController.m
//  movie
//
//  Created by QFish on 4/9/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "MovieListViewController.h"
#import "RefreshCollectionView.h"
#import "MovieViewController.h"
#import "Samurai.h"
#import "Model.h"

@interface MovieListViewController ()
@property (nonatomic, strong) RefreshCollectionView * list;
@property (nonatomic, strong) MovieListModel * model;
@end

@implementation MovieListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [MovieListModel new];
    [self.model addSignalResponder:self];
    [self.model modelLoad];
	
	@weakify( self )
	
	self.onSignal( RefreshCollectionView.eventPullToRefresh, ^{
		
		@strongify( self );
		
		[self refresh];
	});

	self.onSignal( RefreshCollectionView.eventLoadMore, ^{

		@strongify( self );

		[self loadMore];
	});

	self.onSignal( MovieListModel.eventLoading, ^{
		
	//	@strongify( self );
	});

	self.onSignal( MovieListModel.eventLoaded, ^{

		@strongify( self );
		
		[self.list stopLoading];
		[self reloadData];
	});

	self.onSignal( MovieListModel.eventError, ^{
		
		@strongify( self );
		
		[self.list stopLoading];
	});
	
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self loadTemplate:@"/www/html/movies-index.html"];
}

- (void)viewDidLayoutSubviews
{
    [self relayout];
}

- (void)dealloc
{
    [self unloadTemplate];
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
    [_model refresh];
}

- (void)loadMore
{
    if ( [_model more] )
    {
        [_model loadMore];
    }
    else
    {
        [_list stopLoading];
    }
}

- (void)reloadData
{
	self.scope[@"list" ] = @{
								  
		  @"movies" : ({
			  
			  NSMutableArray * movies = [NSMutableArray array];
			  
			  for ( MOVIE * movie in _model.movies )
			  {
				  [movies addObject:@{
									  @"cover" : movie.posters.thumbnail ?: @"",
									  @"title" : movie.title ?: @"",
									  @"year" : @(movie.year) ?: @"",
									  @"critics" : @(movie.ratings.critics_score) ?: @"",
									 }];
			  }
			  
			  movies;
		  })
		  
    };

    [_list reloadData];
}

#pragma mark -

- (void)viewCover:(SamuraiSignal *)signal
{
    MOVIE * movie = [_model.movies objectAtIndex:signal.sourceIndexPath.row];
    MovieViewController * vc = [MovieViewController new];
    vc.movie = movie;

    [self.navigationController pushViewController:vc animated:YES];
}

@end
