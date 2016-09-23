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

    @property (nonatomic) CGFloat maxXValue;
    @property (nonatomic) CGFloat maxYValue;

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
    
    CGRect verticalLabelRect = [self drawLabel:self.verticalLabel fontSize:self.fontSize atPoint:self.verticalLabelPoint onHorizontal:NO];
    CGRect horizontalLabelRect = [self drawLabel:self.horizontalLabel fontSize:self.fontSize atPoint:self.horizontalLabelPoint onHorizontal:YES];
    
    self.paddingLeft = verticalLabelRect.size.width + kDefaultPadding + self.lineWidth;
    self.paddingBottom = horizontalLabelRect.size.height + kDefaultPadding + self.lineWidth;
    
    self.rootPoint = CGPointMake(rect.origin.x + self.paddingLeft, rect.size.height - self.paddingBottom);
    
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
    
    // draw X,Y - axis with root point O
    CGContextSetStrokeColorWithColor(context, [self.axisColor CGColor]);
    CGContextSetLineWidth(context, self.lineWidth);
    
    [self drawAxisInRect:rect atRoot:self.rootPoint inContenxt:context];
    [self drawSeparateLineWithHorizonralUnitWidth:self.horizontalUnitWidth
                                verticalUnitWidth:self.verticalUnitWidth
                                        inContext:context];
}

- (CGRect)drawLabel:(NSString *)label fontSize:(CGFloat)fontSize atPoint:(CGPoint)point onHorizontal:(BOOL)horizontal {
    // Draw label
    NSDictionary *labelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    CGSize size = [label sizeWithAttributes:labelAttributes];
    CGRect rect;
    if(!horizontal) {
        rect = CGRectMake(point.x, point.y, size.width, size.height);
    } else {
        rect = CGRectMake(point.x - size.width/2, point.y - size.height/2, size.width, size.height);
    }
    
    [label drawInRect:rect withAttributes:labelAttributes];
    
    return rect;
}

- (void)drawAxisInRect:(CGRect)rect atRoot:(CGPoint)rootPoint inContenxt:(CGContextRef)context {
    CGFloat axisMargin = self.lineWidth / 2;
    // x axis
    // point x of X axis was substract to lineWidth to fill the space between two axises.
    CGContextMoveToPoint(context, rootPoint.x - self.lineWidth, rootPoint.y + axisMargin);
    CGContextAddLineToPoint(context, self.maxXValue + self.paddingLeft + kDefaultPadding, self.bounds.size.height - self.paddingBottom + axisMargin);
    CGContextDrawPath(context, kCGPathStroke);
    
    // y axis
    CGContextMoveToPoint(context, rootPoint.x - axisMargin, rootPoint.y);
    CGContextAddLineToPoint(context, self.paddingLeft - axisMargin , rootPoint.y - (self.maxYValue + kDefaultPadding));
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawSeparateLineWithHorizonralUnitWidth:(CGFloat)hw verticalUnitWidth:(CGFloat)vw inContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, CGColorCreateCopyWithAlpha([self.axisColor CGColor], 0.3f));
    CGContextSetLineWidth(context, self.lineWidth/10.0f);
    
    CGFloat ra[] = {1,1};
    CGContextSetLineDash(context, 0.0, ra, 2);
    
    CGFloat fontSizeLabel = 4.0f;
    
    CGFloat currentX = self.rootPoint.x + hw; // from x line + 10
    while (currentX < (self.rootPoint.x + self.maxXValue + hw)) {
        CGContextMoveToPoint(context, currentX, self.rootPoint.y);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, pt.x, self.rootPoint.y - (self.maxYValue + vw));
        CGContextDrawPath(context, kCGPathStroke);
        
        CGPoint labelPoint = CGPointMake(currentX, self.rootPoint.y + self.lineWidth * 2.5);
        [self drawLabel:[NSString stringWithFormat:@"%d",(int) (currentX - self.rootPoint.x)] fontSize:fontSizeLabel atPoint:labelPoint onHorizontal:YES];
        
        currentX += hw;
    }
    
    NSDictionary *labelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeLabel]};
    CGSize size = [[NSString stringWithFormat:@"%d", (int)self.bounds.size.width] sizeWithAttributes:labelAttributes];
    CGFloat currentY = self.rootPoint.y - vw; // from y line - 10
    while (currentY > (self.rootPoint.y - self.maxYValue - vw)) {
        CGContextMoveToPoint(context, self.rootPoint.x, currentY);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, self.rootPoint.x + self.maxXValue + vw, pt.y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGPoint labelPoint = CGPointMake((self.rootPoint.x - (size.width) < 0 ? 0 : self.rootPoint.x - (size.width)) - self.lineWidth * 1.5, currentY);
        [self drawLabel:[NSString stringWithFormat:@"%d",(int) (self.rootPoint.y - currentY)] fontSize:fontSizeLabel atPoint:labelPoint onHorizontal:NO];
        
        currentY -= vw;
    }
}

- (CGLayerRef)drawLine:(NSInteger)line inContextRef:(CGContextRef)context {
    CGRect layerRect = CGRectMake(0, 0,
                                  self.bounds.size.width - (self.paddingLeft + self.paddingRight),
                                  self.bounds.size.height - (self.paddingTop + self.paddingBottom));
    
    CGPoint rootPoint = CGPointMake(0, 0);
    
    CGLayerRef layer = CGLayerCreateWithContext(context, layerRect.size, NULL);
    CGContextRef layerContext = CGLayerGetContext(layer);
    CGContextBeginTransparencyLayer(layerContext, NULL);
    
    CGContextTranslateCTM(layerContext, 0, layerRect.size.height);
    CGContextScaleCTM(layerContext, 1.0, -1.0);
    
    UIColor *lineColor;
    if ([self.delegate respondsToSelector:@selector(colorOfLine:)]) {
        lineColor = [self.delegate colorOfLine:line];
    }
    if (!lineColor) {
        lineColor = self.axisColor;
    }
    CGContextSetStrokeColorWithColor(layerContext, [lineColor CGColor]);
    CGContextSetLineWidth(layerContext, kDefaultLineWidth);
    
//    CGFloat ra[] = {4,2};
//    CGContextSetLineDash(layerContext, 0.0, ra, 2);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, nil, rootPoint.x, rootPoint.y);
    
    
    for (int i = 0; i < [self.dataSource chartView:self numberOfValueInLine:line]; i++) {
        NSValue *pointValue = [self.dataSource chartView:self valueAtIndex:i inLine:line];
        CGPoint point = [pointValue CGPointValue];
        if (point.x > self.maxXValue) {
            self.maxXValue = point.x;
        }
        if (point.y > self.maxYValue) {
            self.maxYValue = point.y;
        }
        CGPathAddLineToPoint(pathRef, nil, point.x, point.y);
    }
    CGContextAddPath(layerContext, pathRef);
    CGContextStrokePath(layerContext);
    
    CGPathRelease(pathRef);
    
    return layer;
}

@end
