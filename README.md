# YMTopTab
### YMTopTab is a scrollable menu like the top menu in  今日头条 and 网易  ios app, and it's so easy to use.

<!--![Bigger](https://raw.githubusercontent.com/Ym-Barry/YMTopTab/master/Bigger.gif)

![Slider](https://github.com/Ym-Barry/YMTopTab/blob/master/YMTopTab2.gif?raw=true)-->

## How to install 

### 1. Installation with CocoaPods (Recommend)

Podfile

To integrate YMTopTab into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'YMTopTab', '~> 0.0.1'
end

```

### 2. Manual install

  Download the project and drag the YMTopTab fold to you project
  
## How to use

The YMTopTab is so easy to use, few lines code can  integrate your UIScrollview and subclasses to the YMTopTab.

```
YMTopTab *tab = [[YMTopTab alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 0)];
tab.titles = @[@"推荐", @"视频", @"NBA", @"法律节目",@"头条", @"关注", @"CBA", @"足球"];
tab.selectedFont = [UIFont systemFontOfSize:18.0];
tab.delegate = self;
tab.style = BiGSLIDER;
tab.adpotScrollView = scrollView;
[self.view addSubview:tab];

```
tab's height will finally decide by the selectedFont and the topGap, bottomGap, style property.

```
/**

 When the title's total length less than tab's width, if this property is No, the title's length decide by the title label length other than, it will be the tab's width divide titles count.
**/

@property (nonatomic, assign) BOOL fillout  

```
```
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;  // The space between every title

```
```
@property (nonatomic, assign) NSUInteger selectedIndex;  // The current selected index
```
```
@property (nonatomic, assign) CGFloat sliderHeight;  // when the style is     SLIDER or BiGSLIDER, it decide the height of  bottom slider view

```
```
@property (nonatomic, assign) BOOL scrollingChangFont;  //wether the title will change it's font when scrolling the scrollView
```