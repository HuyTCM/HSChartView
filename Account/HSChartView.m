//
//  HSChartView.m
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "HSChartView.h"

@interface HSChartView()

@property (nonatomic) CGFloat padding;

@end

@implementation HSChartView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.padding = 10.0f;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[HSChartView colorWithR:255.0f G:247.0f B:234.0f alpha:1.0f] CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetStrokeColorWithColor(context, [[HSChartView colorWithR:238.0f G:167.0f B:59.0f alpha:1.0f] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    
    CGPoint rootO = CGPointMake(rect.origin.x + self.padding, rect.size.height - self.padding);
    
    // x line
    CGContextMoveToPoint(context, rootO.x, rootO.y);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextDrawPath(context, kCGPathStroke);
    
    // y line
    CGContextMoveToPoint(context, rootO.x, rootO.y);
    CGContextAddLineToPoint(context, rect.size.width - 10, rect.size.height - 10);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetStrokeColorWithColor(context, [[HSChartView colorWithR:238.0f G:167.0f B:59.0f alpha:1.0f] CGColor]);
    CGContextSetLineWidth(context, 0.1f);
    
    CGFloat currentX = rootO.x + 10; // from x line + 10
    while (currentX < (rect.size.width - 10)) {
        CGContextMoveToPoint(context, currentX, rect.size.height - 10);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, pt.x, 10);
        CGContextDrawPath(context, kCGPathStroke);
        currentX += 10.0f;
    }
    
    CGFloat currentY = rootO.y - 10; // from x line - 10
    while (currentY > 10) {
        CGContextMoveToPoint(context, rect.origin.x + 10, currentY);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, rect.size.width - 10, pt.y);
        CGContextDrawPath(context, kCGPathStroke);
        currentY -= 10.0f;
    }
    
    NSInteger numOfLine;
    if ([self.dataSource respondsToSelector:@selector(numberOfLineInChartView:)]) {
        numOfLine = [self.dataSource numberOfLineInChartView:self];
    } else {
        numOfLine = 1;
    }
    
    while (numOfLine > 0) {
        CGContextSetStrokeColorWithColor(context, [[HSChartView colorWithR:238.0f G:167.0f B:59.0f alpha:1.0f] CGColor]);
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

//- (UIView *)viewGraphWithX:(NSInteger )x andY:(NSInteger)y inRect:(CGRect)rect {
//    UIView *view = [[UIView alloc] initWithFrame:rect];
//    [view setBackgroundColor:[UIColor colorWithRed:255 green:247 blue:234 alpha:1]];
//    
//    UILabel *maxXLable = [[UILabel alloc] init];
//    [maxXLable setText:[NSString stringWithFormat:@"%f", [self getMaxValue].x]];
//    
//    return view;
//}

//- (CGPoint)getMaxValue {
//    CGFloat maxX = 0;
//    CGFloat maxY = 0;
//    for (NSValue *value in self.pointArr) {
//        CGPoint pointValue = [value CGPointValue];
//        if (pointValue.x > maxX) {
//            maxX = pointValue.x;
//        }
//        if (pointValue.y > maxY) {
//            maxY = pointValue.y;
//        }
//    }
//    return CGPointMake(maxX, maxY);
//}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:alpha];
}

@end
