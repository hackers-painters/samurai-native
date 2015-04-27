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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self loadViewTemplate:@"/www/html/movies-index.html"];
}

- (void)viewDidLayoutSubviews
{
    [self relayout];
}

- (void)dealloc
{
    [self unloadViewTemplate];
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    [self refresh];
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
    self.viewStorage[@"list"] = @{
								  
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

handleSignal( view_cover )
{
    MOVIE * movie = [_model.movies objectAtIndex:signal.sourceIndexPath.row];
    MovieViewController * vc = [MovieViewController new];
    vc.movie = movie;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

handleSignal( RefreshCollectionView, eventPullToRefresh )
{
    [self refresh];
}

handleSignal( RefreshCollectionView, eventLoadMore )
{
    [self loadMore];
}

#pragma mark -

handleSignal( MovieListModel, eventLoading )
{
}

handleSignal( MovieListModel, eventLoaded )
{
    [_list stopLoading];
    
    [self reloadData];
}

handleSignal( MovieListModel, eventError )
{
    [_list stopLoading];
}

@end
