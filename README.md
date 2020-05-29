# YXSccrollView
简单快速的实现多层嵌套ScrollView

已经是2020年了，多层UIScrollView嵌套，也已是iOS中老生常谈的问题。

Apple官方不建议将ScrollView嵌套使用，可是产品和设计师们就是戒不掉这个瘾，没办法，既然是打工，拿人钱财替人解忧。

网上有众多实现此功能的方案，但是鱼龙混杂，而且大部分也不完善，完善的代码又特别复杂，整合工作量较大，这两天正好有时间和机会，好好研究和思考了一下最简单的解决方案。

先上个效果图

![2020-05-28 20_48_17.gif](https://upload-images.jianshu.io/upload_images/11673677-73553487ee09f8f8.gif?imageMogr2/auto-orient/strip)


解决的代码基本只在ScrollViewDidScroll里做了逻辑处理，对于已经做好了XIB的小伙伴很友好

大概思路就是在内层的UIScrollView(UITableView也算是UIScrollView)的ScrollViewDidScroll代理方法里面做逻辑判断，看是否允许自己滚动。

首先我的层级结构如下图（蓝色的内ScrollView，会横向平铺多个）

![78DCD371-B734-4788-B46A-3030765CF544.png](https://upload-images.jianshu.io/upload_images/11673677-ae434d687c9942f7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

通常这种情况，在XIB中画好了外部框之后，内部的这个UITableVIew(UIScrollView)是由根据服务器返回的多少个分类，由代码编写后横向平铺的，这也就方便了我们使用自定义类。所以，首先我们还是逃不掉重写一个UITableView，像这样
```
QCTableView.h
@interface QCTableView : UITableView

///记录一下坐标，为了等下滑动的时候判断向上还是向下
@property (nonatomic, assign) CGFloat tableY;

@end

QCTableView.m
@implementation QCTableView

// 返回YES表示可以继续传递触摸事件，这样便可实现了两个嵌套的scrollView同时滚动。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
```
没错，就重写一个方法+一个属性。
重写这个是免不了的，我已经试过很多方法，最后都只有重写这个shouldRecognizeSimultaneouslyWithGestureRecognizer才能完美地将ScrollView接到的滑动手势传给下一层

然后就是当前持有主ScrollView和内ScrollView(或TableView)的Controller的ScrollViewDidScroll代理方法了
```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isKindOfClass:[UITableView class]]){
//内部ScrollView
        NSLog(@"滚动UITableView");
        QCTableView *qctv = (QCTableView*)scrollView;
//判断向上滑动还是向下滑动
        if (scrollView.contentOffset.y - qctv.tableY > 0) {
            //向上
//_main_scrollView就是我的外层主ScrollView，当它小于116或者大于0的时候，这时候还在向上滑动就说明在移动它，这时候禁止内部ScrollView滚动，一直设置内部ScrollView的Y轴为最后一次记录的Y轴，以禁止它的滚动。
            if (_main_scrollView.contentOffset.y<116&&scrollView.contentOffset.y>0) {
                [scrollView setContentOffset:CGPointMake(0, qctv.tableY)];
            }
/*mainScrollContentY是我在全局声明的变量
{
    CGFloat mainScrollContentY;
}
有条件的可以将它写在主ScrollView的重写对象里，我这里没有为主Scroll重写对象，就放在当前Controller里了为了简单
*/
//只在主ScrollView滚动了的条件下记录它的坐标。
            mainScrollContentY = _main_scrollView.contentOffset.y;
        }else if(scrollView.contentOffset.y - qctv.tableY < 0){
            //向下
//内部ScrollView的Y大于0说明内部ScrollView没到顶，这时候向下移动也应该将_main_scrollView固定在最上方，一直设置外部_main_scrollView的Y轴为最后一次记录的Y轴，以禁止它的滚动。
            if (scrollView.contentOffset.y>=0) {
                [_main_scrollView setContentOffset:CGPointMake(0, mainScrollContentY)];
            }else if (_main_scrollView.contentOffset.y>0) {
//如果内部Scroll的ContentOffset的Y小于0，说明内部ScrollView到顶了，外部_main_scrollView的ContentOffset的Y又大于0，这时候向下移动应该将外部_main_scrollView拉下来，一直设置内部ScrollView的Y轴为0，以禁止它的滚动。
                [scrollView setContentOffset:CGPointMake(0, 0)];
            }
//只在主ScrollView滚动了的条件下记录它的坐标。
            mainScrollContentY = _main_scrollView.contentOffset.y;
        }
        qctv.tableY = scrollView.contentOffset.y;
    }else if(scrollView==_main_scrollView){
//外部主ScrollView
//这里主要是设置边界，也就是头部的高度，不允许_main_scrollView的contentOffset的Y轴大于116或小于0。
        NSLog(@"滚动MainScroll");
        if (scrollView.contentOffset.y>116) {
            [scrollView setContentOffset:CGPointMake(0, 116)];
        }else if(scrollView.contentOffset.y<0){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
}
```
注释写的很详细了，以上就是所有的代码了，其实UITableView中的tableY和mainScrollContentY是在实现了基本功能的基础上加的，为的是修复一些坐标上的BUG，理论上不应该对任何一个ScrollView通过一直设置为固定的Y轴值（116或0）来禁止它的滚动，而是应该通过一直设置它为最后一次允许滚动时记录的Y轴，来避免跳动现象。但是为了代码简单明了，就先不做过多处理了。
[Demo在这里，已上传到GitHub](https://github.com/mmMrz/YXSccrollView)
https://github.com/mmMrz/YXSccrollView


做这篇文章时，主要是因为我已经用XIB写好了这个“主Scroll”套“横向Scroll”又套“多层UITableView”的XIB了，界面画好了，不想再用github上完善的的实现库去重新开发了，这样的方法简单明了，易用，移植性高。目前是我能想到的最简单又相对完善的实现方法了。有更好的方法或者更简单套用的三方库，欢迎评论探讨。

QQ群：653317062 （失踪的新华社）
