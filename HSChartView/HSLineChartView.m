//
//  HSChartView.m
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "HSLineChartView.h"

#define kDefaultPadding         10.0f
#define kDefaultLineWidth       1.0f
#define kDefaultFontSize        8.0f
#define kDefaultUnitWidth       10

@interface HSLineChartView()

    @property (nonatomic) CGFloat paddingLeft;
    @property (nonatomic) CGFloat paddingRight;
    @property (nonatomic) CGFloat paddingTop;
    @property (nonatomic) CGFloat paddingBottom;
    @property (nonatomic) CGPoint rootPoint;
    @property (nonatomic) CGFloat axisMargin;
    @property (nonatomic) CGPoint verticalLabelPoint;
    @property (nonatomic) CGPoint horizontalLabelPoint;

@end

@implementation HSLineChartView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.axisColor = [UIColor blackColor];
        
        self.verticalLabelPoint = CGPointMake(kDefaultPadding, kDefaultPadding/2);
        self.horizontalLabelPoint = CGPointMake(frame.size.width - kDefaultPadding/2, frame.size.height - kDefaultPadding);
        
        self.fontSize = kDefaultFontSize;
        self.paddingLeft = self.paddingRight = self.paddingTop = self.paddingBottom = kDefaultPadding;
        self.lineWidth = kDefaultLineWidth;
        self.horizontalUnitWidth = self.verticalUnitWidth = kDefaultUnitWidth;
        self.axisMargin = self.lineWidth/2;
    }
    [self setContentSize:frame.size];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    [self drawLabel];
    
    CGContextSetStrokeColorWithColor(context, [self.axisColor CGColor]);
    CGContextSetLineWidth(context, self.lineWidth);
    
    self.rootPoint = CGPointMake(rect.origin.x + self.paddingLeft, rect.size.height - self.paddingBottom);
    
    [self drawAxisAtRoot:self.rootPoint inContenxt:context];
    [self drawSeparateLineWithHorizonralUnitWidth:self.horizontalUnitWidth
                                verticalUnitWidth:self.verticalUnitWidth
                                        inContext:context];
    
    NSInteger numOfLine;
    if ([self.delegate respondsToSelector:@selector(numberOfLineInChartView:)]) {
        numOfLine = [self.delegate numberOfLineInChartView:self];
    } else {
        numOfLine = 1;
    }
    
    while (numOfLine > 0) {
        CGLayerRef lineLayer = [self drawLine:numOfLine inContextRef:context];
        CGContextDrawLayerAtPoint(context, CGPointMake(self.paddingLeft, self.paddingTop), lineLayer);
        CGLayerRelease(lineLayer);
        --numOfLine;
    }
}

- (void)drawLabel {
    // Draw label
    NSDictionary *labelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]};
    
    CGSize verticalLabelSize = [self.verticalLabel sizeWithAttributes:labelAttributes];
    CGSize horizontalLabelSize = [self.horizontalLabel sizeWithAttributes:labelAttributes];
    CGRect verticalRect = CGRectMake(self.verticalLabelPoint.x, self.verticalLabelPoint.y, verticalLabelSize.width, verticalLabelSize.height);
    CGRect horizontalRect = CGRectMake(self.horizontalLabelPoint.x - horizontalLabelSize.width,
                                       self.horizontalLabelPoint.y - horizontalLabelSize.height,
                                       horizontalLabelSize.width, horizontalLabelSize.height);
    
    [self.verticalLabel drawInRect:verticalRect withAttributes:labelAttributes];
    [self.horizontalLabel drawInRect:horizontalRect withAttributes:labelAttributes];
    
    self.paddingLeft = verticalLabelSize.width + kDefaultPadding + self.lineWidth;
    self.paddingBottom = horizontalLabelSize.height + kDefaultPadding + self.lineWidth;
}

- (void)drawAxisAtRoot:(CGPoint)rootPoint inContenxt:(CGContextRef)context {
    CGFloat axisMargin = self.lineWidth / 2;
    // x axis
    // point x of X axis was substract to lineWidth to fill the space between two axises.
    CGContextMoveToPoint(context, rootPoint.x - self.lineWidth, rootPoint.y + axisMargin);
    CGContextAddLineToPoint(context, self.bounds.size.width - self.paddingRight + 100, self.bounds.size.height - self.paddingBottom + axisMargin);
    CGContextDrawPath(context, kCGPathStroke);
    
    // y axis
    CGContextMoveToPoint(context, rootPoint.x - axisMargin, rootPoint.y);
    CGContextAddLineToPoint(context, self.paddingLeft - axisMargin , self.paddingTop);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawSeparateLineWithHorizonralUnitWidth:(CGFloat)hw verticalUnitWidth:(CGFloat)vw inContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, CGColorCreateCopyWithAlpha([self.axisColor CGColor], 0.3f));
    CGContextSetLineWidth(context, self.lineWidth/10.0f);
    
    CGFloat currentX = self.rootPoint.x + hw; // from x line + 10
    while (currentX < (self.bounds.size.width - hw)) {
        CGContextMoveToPoint(context, currentX, self.rootPoint.y);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, pt.x, hw);
        CGContextDrawPath(context, kCGPathStroke);
        currentX += hw;
    }
    
    CGFloat currentY = self.rootPoint.y - vw; // from y line - 10
    while (currentY > vw) {
        CGContextMoveToPoint(context, self.rootPoint.x, currentY);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, self.bounds.size.width - vw, pt.y);
        CGContextDrawPath(context, kCGPathStroke);
        currentY -= vw;
    }
}

- (CGLayerRef)drawLine:(NSInteger)line inContextRef:(CGContextRef)context {
    CGRect layerRect = CGRectMake(0, 0,
                                  self.bounds.size.width - (self.paddingLeft + self.paddingRight),
                                  self.bounds.size.height - (self.paddingTop + self.paddingBottom));
    
    CGPoint rootPoint = CGPointMake(0, layerRect.size.height);
    
    CGLayerRef layer = CGLayerCreateWithContext(context, layerRect.size, NULL);
    CGContextRef layerContext = CGLayerGetContext(layer);
    CGContextBeginTransparencyLayer(layerContext, NULL);
    
    UIColor *lineColor;
    if ([self.delegate respondsToSelector:@selector(colorOfLine:)]) {
        lineColor = [self.delegate colorOfLine:line];
    }
    if (!lineColor) {
        lineColor = self.axisColor;
    }
    CGContextSetStrokeColorWithColor(layerContext, [lineColor CGColor]);
    CGContextSetLineWidth(layerContext, kDefaultLineWidth);
    
    // move to root O
    CGContextMoveToPoint(layerContext, rootPoint.x, rootPoint.y);
    CGPoint currPoint = CGContextGetPathCurrentPoint(layerContext);
    
    for (int i = 0; i < [self.dataSource chartView:self numberOfValueInLine:line]; i++) {
        NSValue *pointValue = [self.dataSource chartView:self valueAtIndex:i inLine:line];
        CGPoint point = [pointValue CGPointValue];
        CGContextMoveToPoint(layerContext, currPoint.x, currPoint.y);
        CGContextAddLineToPoint(layerContext, point.x, rootPoint.y - point.y);
        currPoint = CGContextGetPathCurrentPoint(layerContext);
        CGContextDrawPath(layerContext, kCGPathFillStroke);
    }
    return layer;
}

@end
