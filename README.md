Bring web standards to native platform
======================================

samurai-native enables you to build native apps using web technologies (HTML/CSS) based on its own Web-Core.<br/>
Support iOS now, Android later.

Check out demo at `samurai-examples/dribbble` and `samurai-examples/movie`.

## Native Components

You can use the native components such as `UICollectionView` and `UICollectionViewCell` on iOS. This gives your app a consistent look and feel with the rest of the platform ecosystem, and keeps the quality bar high. These components are easily incorporated into your app using `<UICollectionView/>` and `<UICollectionViewCell/>` directly.

```html
<html>

	<body>
		
		<UICollectionView class="list" is-vertical>
			<UICollectionViewCell is-static is-row>
				...
			</UICollectionViewCell>
		</UICollectionView>

	</body>
	
</html>
```

## HTML Components

You can use the standard HTML tags such as `div` and `img` on iOS. This gives you ability to define your user interface using a hybrid way.

```html
<html>

	<body>

		<UICollectionViewCell is-static is-row>
			<div class="profile-wrapper">
				<div class="profile-attribution">
					<div class="profile-segment no-wrap">
						<div class="segment-wrapper">
							<span class="segment-count">10,875</span>
							<span class="segment-suffix">Followers</span>
						</div>
					</div>
					<div class="profile-segment no-wrap">
						<div class="segment-wrapper">
							<span class="segment-count">199</span>
							<span class="segment-suffix">Followers</span>
						</div>
					</div>
				</div>
			</div>
		</UICollectionViewCell>

	</body>
	
</html>
```

## CSS Fluid layout	

We brought the css layout model from the web to samurai-native, css layout makes it simple to build the most common UI layouts, such as stacked and nested boxes with margin and padding. samurai-native also supports common web styles, such as `font-weight` and `border-radius`, and you can extend your style in `SamuraiHtmlRenderStyle` class.

(TODO: Flex-Box)

```html
<html>

	<head>
		
		<link rel="stylesheet" type="text/css" href="../css/normalize.css"/>
		<link rel="stylesheet" type="text/css" href="../css/main.css"/>
		
	</head>
	
</html>
```

```html
<html>

	<body>
	
		<p style="color: red;">
			Hello, world!
		</p>
		
	</body>

</html>
```

```html
<html>

	<body>
	
		<div class="tab-bar">
			<div class="tab">Popular</div>
			<div class="tab">Debuts</div>
			<div class="tab">Everyone</div>
		</div>

		<style>
		
			.tab-bar {
				display: block;
				width: 100%;
				height: 34px;
				background-color: #e5508c;
				/* box-shadow: 0px 0.5px 0.5px black; */
				z-index: 2;
			}
		
			.tab {
				float: left;
				display: block;
				width: 33.33%;
				height: 34px;
				font-size: 14px;
				line-height: 34px;
				color: #fff 0.75;
				text-align: center;
				font-weight: normal;
			}
			
			...
			
		</style>
		
	</body>

</html>
```

## Easy to use API

```objc

@implementation MyViewController

- (void)viewDidLoad
{
	[self loadViewTemplate:@"/www/html/dribbble-index.html"];
//	[self loadViewTemplate:@"http://localhost:8000/html/dribbble-index.html"];

}

- (void)dealloc
{
	[self unloadViewTemplate];
}

@end
```

## Signal Handling

samurai-native provide a high level event system called `Signal`, you can interact with HTML page through signal system.

```html
<div onclick="signal('switch-tab1')">
	Popular
</div>
```

```objc
@implementation MyViewController

handleSignal( switch_tab1 )
{
	[self something];
}

@end
```

## Extensibility

samurai-native is designed to be easily extended with custom native components, that means you can reuse anything you've already built, and can import and use your favorite native components.

```objc

@implementation UILabel(Html)

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];

	self.text = [dom computeInnerText];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];

	self.font = [style computeFont:self.font];
	self.textColor = [style computeColor:self.textColor];
	self.textAlignment = [style computeTextAlignment:self.textAlignment];
	self.baselineAdjustment = [style computeBaselineAdjustment:self.baselineAdjustment];
	self.lineBreakMode = [style computeLineBreakMode:self.lineBreakMode];
	self.numberOfLines = 0;
	
	...
}

@end
```

## Running the Examples

- clone `https://github.com/hackers-painters/samurai.git`
- open `samurai-examples/dribbble/demo.xcodeproj`
- build and run

## Licensing

samurai-native is licensed under the MIT License.

## Contributors

* [Gavin.Kwoe](https://github.com/gavinkwoe): Major developer
* [QFish](https://github.com/qfish): Major developer

## Related Projects

* [gumbo](https://github.com/google/gumbo-parser): An HTML5 parsing library in pure C99
* [katana](https://github.com/): An CSS3 parsing library in pure C99
* [fishhook](https://github.com/facebook/fishhook): A library that enables dynamically rebinding symbols in Mach-O binaries running on iOS.
* [AFNetworking](https://github.com/AFNetworking/AFNetworking): A delightful iOS and OS X networking framework
