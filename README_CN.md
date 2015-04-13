从 web 开发到原生平台
======================================

samurai-native 可以让你使用 web 技术 (HTML/CSS) 构建基于我们独立研发的 Web-Core 的原生应用. 现已支持 iOS， Android 敬请期待。

代码示例请参考 `samurai-examples/dribbble` 和 `samurai-examples/movie`目录。

![gif](https://raw.githubusercontent.com/hackers-painters/samurai-native/master/samurai-native.gif)

## 原生控件

你可以使用像 `UICollectionView` 和 `UICollectionViewCell` iOS上的原生控件. 让你的用户体验如系统原生般流畅和高质。 这些控件可以让你在代码中直接使用 `<UICollectionView/>` 和 `<UICollectionViewCell/>` 易如反掌。

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

## HTML控件

你当然也可以在 iOS 上使用像 `div` 和 `img` 等标准的 HTML 标签。 多重选择，让你更自由的来定制独有的用户界面。

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

## 动态CSS布局

我们的 samurai-native 为你带来了 css 样式布局， 让你容易的在 stacked 和 nested boxes 等常用控件中使用 margin 和 padding 等标准 css 样式属性。 samurai-native 同样支持常见的 web 样式， 例如： `font-weight` 和 `border-radius`等。 同时， 你可以轻易的在 `SamuraiHtmlRenderStyle` 类中扩展你特有的样式属性。

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

## 让集成如此简单

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

- (void)onTemplateLoading {}
- (void)onTemplateLoaded {}
- (void)onTemplateFailed {}
- (void)onTemplateCancelled {}

@end
```

## 信号控制

samurai-native 提供了一个叫做 `信号` 的高级事件系统， 你可以通过这个系统轻易的通过 HTML 页面进行交互(手势)。

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

## 数据捆绑

samurai-native 提供了一个使用信号机制的高效方法， 通过 HTML上 每个节点的名字属性来绑定原生对象。

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

## 可扩展性

samurai-native 可以方便的让用户进行功能拓展， 这意味着你可以使用任何现有的功能插件， 或者你想使用的 iOS 原生的第三方控件加入到你的项目之中。

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

## 实时加载

只需你在 `main()` 函数中增加一行代码， 无需频繁的重新运行， samurai-native 会自动在你的 iPhone模拟器 或者 iPhone 上实时加载和更新你的应用界面。

```objc
[[SamuraiWatcher sharedInstance] watch:@(__FILE__)];
```

## 运行与例子

打开终端输入：
- clone `https://github.com/hackers-painters/samurai.git`
- open `samurai-examples/dribbble/demo.xcodeproj`
- build and run

## 许可

samurai-native 使用 MIT 许可.

## 贡献者

* [Gavin.Kwoe](https://github.com/gavinkwoe): 主程
* [QFish](https://github.com/qfish): 主程

## 相关项目

* [gumbo](https://github.com/google/gumbo-parser): An HTML5 parsing library in pure C99
* [katana](https://github.com/hackers-painters/katana-parser): An CSS3 parsing library in pure C99
* [fishhook](https://github.com/facebook/fishhook): A library that enables dynamically rebinding symbols in Mach-O binaries running on iOS.
* [AFNetworking](https://github.com/AFNetworking/AFNetworking): A delightful iOS and OS X networking framework
