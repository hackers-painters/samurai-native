//
//  INSPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 19.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSCirclePullToRefresh.h"

static NSString* const INSPullToRefreshSpinAnimationKey = @"SpinAnimation";

@interface INSCirclePullToRefresh ()

@property (nonatomic) CAShapeLayer* circle;
@property BOOL animating;
@end

@implementation INSCirclePullToRefresh


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.layer.contentsScale = [UIScreen mainScreen].scale;

        CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * 0.5;
        CGPoint center = CGPointMake(radius, radius);
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];

        self.circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
        self.circle.bounds = self.bounds;
        self.circle.path = bezierPath.CGPath;
        self.circle.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    }
    return self;
}

- (CAShapeLayer*)circle {
    if(!_circle) {
        _circle = [CAShapeLayer layer];
        _circle.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor; /*#2c3e50*/
        _circle.contentsScale = self.layer.contentsScale;
        [self.layer addSublayer:_circle];
    }
    return _circle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone || state == INSPullToRefreshBackgroundViewStateTriggered) {
        self.circle.transform = CATransform3DMakeScale(progress, progress, progress);
    }
}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone) {
        [self stopAnimating];
    } else if (state == INSPullToRefreshBackgroundViewStateLoading){
        [self startAnimating];
    }
}

- (void)startAnimating {
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * 0.5;
    CGPoint center = CGPointMake(radius, radius);
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];

    self.circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
    self.circle.bounds = self.bounds;
    self.circle.path = bezierPath.CGPath;
    self.circle.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    CAAnimationGroup* animationGroup = [CAAnimationGroup animation];

    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    opacityAnimation.fromValue = @1.0;
    opacityAnimation.toValue = @0.0;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.65 :1];

    animationGroup.duration = 1.0;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[ scaleAnimation, opacityAnimation ];

    [self.circle addAnimation:animationGroup forKey:INSPullToRefreshSpinAnimationKey];

    self.animating = YES;
}

- (void)stopAnimating {
    [self.circle removeAnimationForKey:INSPullToRefreshSpinAnimationKey];
    self.circle.transform = CATransform3DMakeScale(0, 0, 0);

    self.animating = NO;
}

@end
