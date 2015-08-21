![samurai-native-logo](https://cloud.githubusercontent.com/assets/876707/7134843/77ebf2d0-e2d3-11e4-8977-e609139b1a92.png)

Bring web standards to native platform
======================================

samurai-native enables you to build native apps using web technologies (HTML/CSS) based on its own Web-Core. Support iOS now, Android later.

[Road map](https://github.com/hackers-painters/samurai-native/wiki/TodoList) | [中文介绍](https://github.com/hackers-painters/samurai-native/blob/master/README_CN.md) | QQ群 79054681

## Demo apps

* [Testcase](https://github.com/hackers-painters/samurai-native/tree/master/samurai-examples/testcase): Web-Core compatibility test.
* [UICatalog](https://github.com/hackers-painters/samurai-native/tree/master/samurai-examples/catalog): UIKit components usage.
* [Movie app](https://github.com/hackers-painters/samurai-native/tree/master/samurai-examples/movie): A demo app using `api.rottentomatoes.com`
* [Dribbble app](https://github.com/hackers-painters/samurai-native/tree/master/samurai-examples/demo): A demo app using `api.dribbble.com`

## Quick preview

![gif](https://cloud.githubusercontent.com/assets/679824/7133416/ccdabe74-e2c5-11e4-8098-ef1bdf2d6248.gif)

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

## Easy to Integration

```objc

@implementation MyViewController

- (void)viewDidLoad
{
	[self loadTemplate:@"/www/html/dribbble-index.html"];
//	[self loadTemplate:@"http://localhost:8000/html/dribbble-index.html"];
}

- (void)dealloc
{
	[self unloadTemplate];
}

- (void)onTemplateLoading {}
- (void)onTemplateLoaded {}
- (void)onTemplateFailed {}
- (void)onTemplateCancelled {}

@end
```

## Signal Handling

samurai-native provide a high level event system called `Signal`, you can interact (gesture) with HTML page through signal system.

```html
<div onclick="signal('hello')">
	Click here
</div>
<div onswipe-left="signal('next')" onswipe-right="signal('prev')">
	Swipe left or right
</div>
```

```objc
@implementation MyViewController

handleSignal( hello )
{
	[self something];
}

handleSignal( prev )
{
	[self something];
}

handleSignal( next )
{
	[self something];
}

@end
```

## Data Binding

samurai-native provide a efficient way to binding native objects to HTML page in single way through DOM's `name` property.

```html
<html>
	<body>

		...

		<div name="author">
			<img name="avatar"/>
			<div>
				<div name="title"/>
				<div>by <span name="name"/></div>
			</div>
		</div>

		...

	</body>
</html>
```

```objc

@implementation MyViewController

...

- (void)reloadData
{
	self[@"author"] = @{
		@"avatar" : "xxx.jpg",
		@"title"  : @"Hello",
		@"name"   : @"World"
	};
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

## Live reload

Add lines below into your `main()` function, samurai-native will applies HTML/CSS changes to iPhoneSimulator without rebuild and run the app.

```objc
[[SamuraiWatcher sharedInstance] watch:@(__FILE__)];
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

## Special thanks

* [ZTDesign](https://dribbble.com/ZTDesign): Major designer

## Related Projects

* [gumbo](https://github.com/google/gumbo-parser): An HTML5 parsing library in pure C99
* [katana](https://github.com/hackers-painters/katana-parser): An CSS3 parsing library in pure C99
* [fishhook](https://github.com/facebook/fishhook): A library that enables dynamically rebinding symbols in Mach-O binaries running on iOS.
* [AFNetworking](https://github.com/AFNetworking/AFNetworking): A delightful iOS and OS X networking framework
