# Regarding iOS 13 Support
Initially this tweak was projected to support iOS 13 as well, in order to be a direct continuation of Bolders, the original. However, difficulties appeared regarding various methods needed to support iOS 13.

For any developer out there who wants to open a pull request or something like that in order to support iOS 13, feel free to do so!

Here are the patches that I've figured out needed to be on iOS 13 in order for the tweak to at least function semi-normally. Do note that the tweak is still extremely buggy even with these patches, so additional work will need to be done in order to get it to work nicely with iOS 13.

---
## FYI:
- The way I used to check if the tweak is running on a device on iOS 13 is `UIDevice.currentDevice.systemVersion.floatValue < 14.0`. It will be referred to as the `Comparison Check` in this in order to shorten the descriptions.

- The way I used to check if the tweak is running on a device on iOS 14 or higher is `if (@available(iOS 14, *))`. It will be referred to as the `Available Check` in this in order to shorten the descriptions.
---
### Tweak.xm
---

#### `SBFolderTitleTextField` • `-(void)didMoveToWindow`
- `iconCount` needs to be set to `localizedCountString((NSUInteger)((SBFloatyFolderView *)(self.superview)).folder.icons.count)` instead of the current implementation.

#### `SBFolderTitleTextField` • `-(void)layoutSubviews`
- The `canvasView` needs to be an ivar on iOS 13 instead of a property, so `canvasView = MSHookIvar<UIView *>(self, "_textContentView")` instead of `canvasView = self._textCanvasView`.

#### `SBIconListModel` • `-(NSUInteger)maxNumberOfIcons`
- On iOS 13, before the return, the ivar called `_maxIconCount` also needs to be changed. So, this needs to be added: `MSHookIvar<NSUInteger>(self, "_maxIconCount") = rows * columns`. This can be wrapped in a __comparison check__.

#### `SBIconListGridLayoutConfiguration` • `-(NSUInteger)numberOfPortraitRows`
- On iOS 13, before the return, the ivar called `_numberOfPortraitRows` also needs to be patched. So, this needs to be added: `MSHookIvar<NSUInteger>(self, "_numberOfPortraitRows") = rows`. This can be wrapped in a __comparison check__.

#### `SBIconListGridLayoutConfiguration` • `-(NSUInteger)numberOfPortraitColumns`
- On iOS 13, before the return, the ivar called `_numberOfPortraitColumns` also needs to be patched. So, this needs to be added: `MSHookIvar<NSUInteger>(self, "_numberOfPortraitRows") = rows`. This can be wrapped in a __comparison check__.
---
### BoldersRebornListControllers.xm
---
#### `BoldersRebornBaseController` • `-(void)initTopMenu`
- `gearshape.fill` as an SFSymbol does not exist on iOS 13, so either an alternative one would have to be used, or some other solution. This can be done using a __comparison check__.
---
### BoldersRebornSliderCell.**mm**
---
#### `BoldersRebornSliderCell` • `-(void)layoutSubviews`
- The fix provided for the weird cutoff on `PSSliderCell`s is not available on iOS 13; it crashes the Settings app when trying to go to the page.