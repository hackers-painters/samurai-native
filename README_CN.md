![samurai-native-logo](https://cloud.githubusercontent.com/assets/876707/7134843/77ebf2d0-e2d3-11e4-8977-e609139b1a92.png)

将Web开发标准带到原生平台
=======================

samurai-native 可以让您使用标准Web开发技术 (HTML+CSS) 构建基于私有浏览器内核的原生应用。现已支持 iOS，Android 敬请期待。

| 官方QQ群 [79054681]() |

代码示例请参考 `samurai-examples/dribbble` 和 `samurai-examples/movie`目录。

## 快速预览

![gif](https://cloud.githubusercontent.com/assets/679824/7133416/ccdabe74-e2c5-11e4-8098-ef1bdf2d6248.gif)

## 原生控件

您可以使用如 `UICollectionView` 及 `UICollectionViewCell` 这样的iOS原生控件， 让您的产品用户体验如系统原生般流畅和高质。集成这些控件易如反掌，可以直接使用 `<UICollectionView/>` 和 `<UICollectionViewCell/>` 在您的代码中。

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

您当然也可以在 iOS 上使用如 `<div>` 和 `<img>` 这样的标准 HTML 标签。多重选择， 让你更自由的来定制独有的用户界面。

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

## 流式CSS布局

samurai-native 为您带来了流式 CSS 样式及布局，通过层叠或嵌套盒模型及 margin 和  padding 等标准 CSS 样式属性来排版界面布局。samurai-native 同样支持常见的样式，例如： `font-weight` 和 `border-radius`等。 同时，你可以很容易的在 `SamuraiHtmlRenderStyle` 类中扩展你自己的样式属性。

(待完成: Flex-Box)

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

## 集成如此简单

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

## 事件处理

samurai-native 提供了一个叫做 `Signal` 的高阶事件系统，你可以通过这个系统更容易的在原生代码与HTML页面代码之间进行交互。

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

## 数据绑定

samurai-native 提供了一种单向的高效的数据绑定方法，通过每个 DOM 节点的 `name` 属性与数据对应关系来绑定原生对象数据。

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

## 高度可扩展

samurai-native 的设计初衷是为了将自定义控件方便的扩展进来，这意味着你可以使用任何现有的原生界面组件，通过简单的扩展或者直接使用它们。


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

## 实时刷新

只需在 `main()` 函数中增加一行代码，无需重新编译并运行你的App，每当 HTML/CSS 有变化时，samurai-native 会自动在你的 iPhone 模拟器上实时更新您的用户界面。

```objc
[[SamuraiWatcher sharedInstance] watch:@(__FILE__)];
```

## 运行例子

- 克隆 `https://github.com/hackers-painters/samurai.git`
- 打开 `samurai-examples/dribbble/demo.xcodeproj`
- 编译并运行

## 开源许可

samurai-native 使用 MIT 开源协议

## 贡献者

* [Gavin.Kwoe](https://github.com/gavinkwoe): 主开发者
* [QFish](https://github.com/qfish): 主开发者

## 特别感谢

* [ZTDesign](https://dribbble.com/ZTDesign): 主设计师

## 相关项目

* [gumbo](https://github.com/google/gumbo-parser): An HTML5 parsing library in pure C99
* [katana](https://github.com/hackers-painters/katana-parser): An CSS3 parsing library in pure C99
* [fishhook](https://github.com/facebook/fishhook): A library that enables dynamically rebinding symbols in Mach-O binaries running on iOS.
* [AFNetworking](https://github.com/AFNetworking/AFNetworking): A delightful iOS and OS X networking framework
