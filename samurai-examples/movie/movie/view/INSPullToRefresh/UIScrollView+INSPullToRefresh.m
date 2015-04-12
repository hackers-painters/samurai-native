//
//  UIScrollView+INSPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIScrollView+INSPullToRefresh.h"
#import <objc/runtime.h>

static char INSPullToRefreshBackgroundViewKey;
static char INSInfiniteScrollBackgroundViewKey;

@implementation UIScrollView (INSPullToRefresh)
@dynamic ins_pullToRefreshBackgroundView;
@dynamic ins_infiniteScrollBackgroundView;

#pragma mark - Dynamic Accessors

- (INSPullToRefreshBackgroundView *)ins_pullToRefreshBackgroundView {
    return objc_getAssociatedObject(self, &INSPullToRefreshBackgroundViewKey);
}

- (void)setIns_pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView {
    objc_setAssociatedObject(self, &INSPullToRefreshBackgroundViewKey,
                             pullToRefreshBackgroundView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (INSInfiniteScrollBackgroundView *)ins_infiniteScrollBackgroundView {
    return objc_getAssociatedObject(self, &INSInfiniteScrollBackgroundViewKey);
}

- (void)setIns_infiniteScrollBackgroundView:(INSInfiniteScrollBackgroundView *)infiniteScrollBackgroundView {
    objc_setAssociatedObject(self, &INSInfiniteScrollBackgroundViewKey,
                             infiniteScrollBackgroundView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (void)ins_beginPullToRefresh {
    [self.ins_pullToRefreshBackgroundView beginRefreshing];
}
- (void)ins_endPullToRefresh {
    [self.ins_pullToRefreshBackgroundView endRefreshing];
}

- (void)ins_addPullToRefreshWithHeight:(CGFloat)height handler:(INSPullToRefreshActionHandler)actionHandler {

    [self ins_removePullToRefresh];

    INSPullToRefreshBackgroundView *view = [[INSPullToRefreshBackgroundView alloc] initWithHeight:height scrollView:self];
    [self addSubview:view];
    self.ins_pullToRefreshBackgroundView = view;
    [self ins_configurePullToRefreshObservers];

    self.ins_pullToRefreshBackgroundView.actionHandler = actionHandler;
}

- (void)ins_removePullToRefresh {
    if (self.ins_pullToRefreshBackgroundView) {

        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentOffset"];
        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentSize"];
        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"frame"];
        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentInset"];

        [self.ins_pullToRefreshBackgroundView removeFromSuperview];
        self.ins_pullToRefreshBackgroundView = nil;
    }
}

- (void)ins_addInfinityScrollWithHeight:(CGFloat)height handler:(INSInfinityScrollActionHandler)actionHandler {
    [self ins_removeInfinityScroll];

    INSInfiniteScrollBackgroundView *view = [[INSInfiniteScrollBackgroundView alloc] initWithHeight:height scrollView:self];
    [self addSubview:view];
    self.ins_infiniteScrollBackgroundView = view;
    [self ins_configureInfinityScrollObservers];

    self.ins_infiniteScrollBackgroundView.actionHandler = actionHandler;
}
- (void)ins_removeInfinityScroll {
    if (self.ins_infiniteScrollBackgroundView) {

        [self removeObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"contentOffset"];
        [self removeObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"contentSize"];
        [self removeObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"frame"];
        [self removeObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"contentInset"];

        [self.ins_infiniteScrollBackgroundView removeFromSuperview];
        self.ins_infiniteScrollBackgroundView = nil;
    }
}

- (void)ins_beginInfinityScroll {
    [self.ins_infiniteScrollBackgroundView beginInfiniteScrolling];
}
- (void)ins_endInfinityScroll {
    [self.ins_infiniteScrollBackgroundView endInfiniteScrolling];
}

#pragma mark - Private Methods

- (void)ins_configurePullToRefreshObservers {
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)ins_configureInfinityScrollObservers {
    [self addObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_infiniteScrollBackgroundView forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

@end
