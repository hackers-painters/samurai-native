//
//  INSInfiniteIndicator.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 19.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSCircleInfiniteIndicator.h"

static NSString* const INSInfiniteIndicatorSpinAnimationKey = @"SpinAnimation";

@interface INSCircleInfiniteIndicator ()

@property (nonatomic) CAShapeLayer* circle;
@property BOOL animating;
@end

@implementation INSCircleInfiniteIndicator

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.layer.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
}


- (void)didMoveToWindow {
    // CoreAnimation animations are removed when view goes offscreen.
    // So we have to restart them when view reappears.
    if(self.window && self.animating) {
        [self startAnimating];
    }
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

- (void)startAnimating {
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * 0.5;
    CGPoint center = CGPointMake(radius, radius);
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];

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

    [self.circle addAnimation:animationGroup forKey:INSInfiniteIndicatorSpinAnimationKey];

    self.animating = YES;
}

- (void)stopAnimating {
    [self.circle removeAnimationForKey:INSInfiniteIndicatorSpinAnimationKey];

    self.animating = NO;
}

@end
