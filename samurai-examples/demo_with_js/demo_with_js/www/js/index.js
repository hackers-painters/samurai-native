
defineClass( 'ViewController : UIViewController', {

	viewDidLoad : function() {

		self.loadViewTemplate( "/www/html/index.html" );
	},

	dealloc : function() {

		self.unloadViewTemplate();
	},

	onTemplateLoading : function() {

	},

	onTemplateLoaded : function() {

		self.reloadData();
	},

	reloadData : function() {

		var shots = new Array();

		for ( var i = 0; i < 10; ++i ) {

			shots[i] = {

				"attr" : {
					"comments" : 28,
					"likes" : 339,
					"views" : 2433
				},

				"author" : {
					"avatar" : "https://d13yacurqjgara.cloudfront.net/users/285475/avatars/normal/7ab1fc9d69e079e2dc11095fd74908cf.png?1432660315",
					"name" : "Markus Magnusson",
					"title" : "Road Trippin(archive & delete)"
				},

				"shot-url" : "https://d13yacurqjgara.cloudfront.net/users/285475/screenshots/2091336/road_trip_dribbble_1x.gif"
			};
		}

		self.setViewData( { "list" : { "shots" : shots } } );
	},
			
	viewShot: function() {
		NSLog( "hello" );
	}
})
