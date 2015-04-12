//
//  UIScrollView+INSPullToRefresh.h
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

#import <UIKit/UIKit.h>
#import "INSPullToRefreshBackgroundView.h"
#import "INSInfiniteScrollBackgroundView.h"

@interface UIScrollView (INSPullToRefresh)

#pragma mark - INSPullToRefresh

@property (nonatomic, strong, readonly) INSPullToRefreshBackgroundView *ins_pullToRefreshBackgroundView;
@property (nonatomic, strong, readonly) INSInfiniteScrollBackgroundView *ins_infiniteScrollBackgroundView;

- (void)ins_addPullToRefreshWithHeight:(CGFloat)height handler:(INSPullToRefreshActionHandler)actionHandler;
- (void)ins_removePullToRefresh;

- (void)ins_beginPullToRefresh;
- (void)ins_endPullToRefresh;

#pragma mark - INSInfinityScroll

- (void)ins_addInfinityScrollWithHeight:(CGFloat)height handler:(INSInfinityScrollActionHandler)actionHandler;
- (void)ins_removeInfinityScroll;

- (void)ins_beginInfinityScroll;
- (void)ins_endInfinityScroll;

@end
