//
//  MovieViewController.m
//  movie
//
//  Created by QFish on 4/11/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "MovieViewController.h"
#import "RefreshCollectionView.h"
#import "Model.h"

@interface MovieViewController ()
@property (nonatomic, strong) RefreshCollectionView * list;
@property (nonatomic, strong) MovieModel * model;
@end

@implementation MovieViewController

- (void)dealloc
{
    [self unloadTemplate];
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
	
    self.model = [MovieModel new];
    self.model.id = self.movie.id;
	[self.model addSignalResponder:self];
    [self.model modelLoad];

	@weakify( self )
	
	self.onSignal( MovieModel.eventLoading, ^{
		
	});

	self.onSignal( MovieModel.eventLoaded, ^{

		@strongify( self )

		[self reloadData];
	});

	self.onSignal( MovieModel.eventLoading, ^{
		
	});

    [self loadTemplate:@"/www/html/movies-detail.html"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self relayout];
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

- (void)reloadData
{
    self.scope[@"list" ] = @{
								  
		  @"movie": @{
				  @"cover" : _model.movie.posters.thumbnail ?: @"",
				  @"title" : _model.movie.title ?: @"",
				  @"year" : @(_model.movie.year) ?: @"",
				  @"critics" : @(_model.movie.ratings.critics_score) ?: @"",
				  @"audience" : @(_model.movie.ratings.audience_score) ?: @"",
				  @"synopsis":_model.movie.synopsis ?: @"No synopsis.",
				  @"det":_model.movie.mpaa_rating ?: @"No synopsis."
				  },
		  
		  @"actors" : ({
			  
			  NSMutableArray * actors = [NSMutableArray array];
			  
			  for ( PERSON * actor in _model.movie.abridged_cast )
			  {
				  [actors addObject:@{
					@"actor-name" : actor.name ?: @"actor-name",
				  }];
			  }
			  actors;
		  })
	  
    };

	[self relayout];
}

@end
