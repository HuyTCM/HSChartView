//
//  HSChartView.m
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "HSLineChartView.h"

@interface HSLineChartView()
    @property (nonatomic) CGFloat padding;
@end

@implementation HSLineChartView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.axisColor = [UIColor blackColor];
        self.padding = 10.0f;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetStrokeColorWithColor(context, [self.axisColor CGColor]);
    CGContextSetLineWidth(context, 1.0);
    
    CGPoint rootO = CGPointMake(rect.origin.x + self.padding, rect.size.height - self.padding);
    
    // x axis
    CGContextMoveToPoint(context, rootO.x, rootO.y);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextDrawPath(context, kCGPathStroke);
    
    // y axis
    CGContextMoveToPoint(context, rootO.x, rootO.y);
    CGContextAddLineToPoint(context, rect.size.width - 10, rect.size.height - 10);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetStrokeColorWithColor(context, CGColorCreateCopyWithAlpha([self.axisColor CGColor], 0.3f));
    CGContextSetLineWidth(context, 0.1f);
    
    CGFloat currentX = rootO.x + 10; // from x line + 10
    while (currentX < (rect.size.width - 10)) {
        CGContextMoveToPoint(context, currentX, rect.size.height - 10);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, pt.x, 10);
        CGContextDrawPath(context, kCGPathStroke);
        currentX += 10.0f;
    }
    
    CGFloat currentY = rootO.y - 10; // from y line - 10
    while (currentY > 10) {
        CGContextMoveToPoint(context, rect.origin.x + 10, currentY);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, rect.size.width - 10, pt.y);
        CGContextDrawPath(context, kCGPathStroke);
        currentY -= 10.0f;
    }
    
    NSInteger numOfLine;
    if ([self.delegate respondsToSelector:@selector(numberOfLineInChartView:)]) {
        numOfLine = [self.delegate numberOfLineInChartView:self];
    } else {
        numOfLine = 1;
    }
    
    UIColor *lineColor;
    while (numOfLine > 0) {
        if ([self.delegate respondsToSelector:@selector(colorOfLine:)]) {
            lineColor = [self.delegate colorOfLine:numOfLine];
        }
        if (!lineColor) {
            lineColor = self.axisColor;
        }
        
        CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
        CGContextSetLineWidth(context, 1.0f);
        // move to root O
        CGContextMoveToPoint(context, rootO.x, rootO.y);
        CGPoint currPoint = CGContextGetPathCurrentPoint(context);
        
        for (int i = 0; i < [self.dataSource chartView:self numberOfValueInLine:numOfLine]; i++) {
            NSValue *pointValue = [self.dataSource chartView:self valueAtIndex:i inLine:numOfLine];
            CGPoint point = [pointValue CGPointValue];
            CGContextMoveToPoint(context, currPoint.x, currPoint.y);
            CGContextAddLineToPoint(context, rootO.x + point.x, rootO.y - point.y);
            currPoint = CGContextGetPathCurrentPoint(context);
            CGContextDrawPath(context, kCGPathStroke);
        }
        --numOfLine;
    }
}

@end
