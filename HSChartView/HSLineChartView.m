//
//  HSChartView.m
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "HSLineChartView.h"

@interface HSLineChartView()

    @property (nonatomic) CGFloat paddingLeft;
    @property (nonatomic) CGFloat paddingRight;
    @property (nonatomic) CGFloat paddingTop;
    @property (nonatomic) CGFloat paddingBottom;
    @property (nonatomic) CGPoint rootPoint;
    @property (nonatomic) CGFloat axisMargin;
    @property (nonatomic) CGPoint verticalLabelPoint;
    @property (nonatomic) CGPoint horizontalLabelPoint;

    @property (nonatomic) CGFloat maxXLength;
    @property (nonatomic) CGFloat maxYLength;
    @property (nonatomic) CGFloat stepX;
    @property (nonatomic) CGFloat stepY;

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
        
        self.stepX = 5;
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
    
    NSDictionary *labelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]};
    
    CGSize labelSize = [self.verticalLabel sizeWithAttributes:labelAttributes];
    
    self.paddingLeft = labelSize.width + kDefaultPadding + self.lineWidth;
    self.paddingBottom = labelSize.height + kDefaultPadding + self.lineWidth;
    
    self.rootPoint = CGPointMake(rect.origin.x + self.paddingLeft, rect.size.height - self.paddingBottom);
    
    NSInteger numOfLine;
    if ([self.delegate respondsToSelector:@selector(numberOfLineInChartView:)]) {
        numOfLine = [self.delegate numberOfLineInChartView:self];
    } else {
        numOfLine = 1;
    }
    
    while (numOfLine > 0) {
        HSLineChartViewLine *line = [self.dataSource chartView:self lineAtIndex:numOfLine];
        if (line) {
            if (self.maxXLength < (line.maxXValue * self.horizontalUnitWidth)) {
                self.maxXLength = line.maxXValue * self.horizontalUnitWidth;
            }
            if (self.maxYLength < (line.maxYValue * self.verticalUnitWidth)) {
                self.maxYLength = line.maxYValue * self.verticalUnitWidth;
            }
            CGLayerRef lineLayer = [line createLineLayerWithHorizontalUnitWidth:self.horizontalUnitWidth
                                                           andVerticalUnitWidth:self.verticalUnitWidth
                                                                   inContextRef:context];
            CGContextDrawLayerAtPoint(context, CGPointMake(self.paddingLeft, self.rootPoint.y - line.maxYValue * self.verticalUnitWidth), lineLayer);
            CGLayerRelease(lineLayer);
        }
        --numOfLine;
    }
    
    // draw X,Y - axis with root point O
    CGContextSetStrokeColorWithColor(context, [self.axisColor CGColor]);
    CGContextSetLineWidth(context, self.lineWidth);
    
    CGPoint axisMaxDestPoint = [self drawAxisInRect:rect atRoot:self.rootPoint inContenxt:context];
    
    self.verticalLabelPoint = CGPointMake(kDefaultPadding, axisMaxDestPoint.x);
    [self drawLabel:self.verticalLabel fontSize:self.fontSize atPoint:self.verticalLabelPoint onHorizontal:NO];
    self.horizontalLabelPoint = CGPointMake(axisMaxDestPoint.y, self.bounds.size.height - kDefaultPadding);
    [self drawLabel:self.horizontalLabel fontSize:self.fontSize atPoint:self.horizontalLabelPoint onHorizontal:YES];
    
    [self drawSeparateLineWithHorizonralUnitWidth:self.horizontalUnitWidth stepX:self.stepX
                                verticalUnitWidth:self.verticalUnitWidth stepY:self.stepY
                                        inContext:context];
}

- (void)drawLabel:(NSString *)label fontSize:(CGFloat)fontSize atPoint:(CGPoint)point onHorizontal:(BOOL)horizontal {
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
}

- (CGPoint)drawAxisInRect:(CGRect)rect atRoot:(CGPoint)rootPoint inContenxt:(CGContextRef)context {
    CGFloat axisMargin = self.lineWidth / 2;
    // x axis
    // point x of X axis was substract to lineWidth to fill the space between two axises.
    CGPoint rootXPoint = CGPointMake(rootPoint.x - self.lineWidth, rootPoint.y + axisMargin);
    CGPoint destXPoint = CGPointMake(self.maxXLength + self.paddingLeft + kDefaultPadding, rootXPoint.y);
    CGContextMoveToPoint(context, rootXPoint.x, rootXPoint.y);
    CGContextAddLineToPoint(context, destXPoint.x, destXPoint.y);
    CGContextDrawPath(context, kCGPathStroke);
    
    // y axis
    CGPoint rootYPoint = CGPointMake(rootPoint.x - axisMargin, rootPoint.y);
    CGPoint destYPoint = CGPointMake(rootYPoint.x, rootPoint.y - (self.maxYLength + kDefaultPadding));
    CGContextMoveToPoint(context, rootYPoint.x, rootYPoint.y);
    CGContextAddLineToPoint(context, destYPoint.x, destYPoint.y);
    CGContextDrawPath(context, kCGPathStroke);
    
    return CGPointMake(destYPoint.y, destXPoint.x);
}

- (void)drawSeparateLineWithHorizonralUnitWidth:(CGFloat)hw stepX:(CGFloat)stepX
                              verticalUnitWidth:(CGFloat)vw stepY:(CGFloat)stepY
                                      inContext:(CGContextRef)context {
    CGColorRef lineColor = CGColorCreateCopyWithAlpha([self.axisColor CGColor], 0.3f);
    CGContextSetStrokeColorWithColor(context, lineColor);
    CGContextSetLineWidth(context, self.lineWidth/10.0f);
    
    CGFloat ra[] = {1,1};
    CGContextSetLineDash(context, 0.0, ra, 2);
    
    CGFloat fontSizeLabel = 4.0f;
    
    CGFloat currentX = self.rootPoint.x + hw; // from x line + 10
    while (currentX < (self.rootPoint.x + self.maxXLength + hw)) {
        int unitX = ((currentX - self.rootPoint.x)/hw);
        if (unitX >= (int)self.stepX && (unitX % (int)self.stepX) == 0) {
            CGContextMoveToPoint(context, currentX, self.rootPoint.y);
            CGPoint pt = CGContextGetPathCurrentPoint(context);
            CGContextAddLineToPoint(context, pt.x, self.rootPoint.y - (self.maxYLength + vw));
            CGContextDrawPath(context, kCGPathStroke);
            
            CGPoint labelPoint = CGPointMake(currentX, self.rootPoint.y + self.lineWidth * 2.5);
            
            NSString *horizontalUnitLabel = [NSString stringWithFormat:@"%d",unitX];
            [self drawLabel:horizontalUnitLabel
                   fontSize:fontSizeLabel
                    atPoint:labelPoint
               onHorizontal:YES];
        }
        
        currentX += hw;
    }
    
    NSDictionary *labelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeLabel]};
    CGSize size = [[NSString stringWithFormat:@"%d", (int)self.bounds.size.width] sizeWithAttributes:labelAttributes];
    CGFloat currentY = self.rootPoint.y - vw; // from y line - 10
    while (currentY > (self.rootPoint.y - self.maxYLength - vw)) {
        int unitY = ((self.rootPoint.y - currentY)/vw);
        if (unitY >= (int)self.stepX && (unitY % (int)self.stepX) == 0) {
            CGContextMoveToPoint(context, self.rootPoint.x, currentY);
            CGPoint pt = CGContextGetPathCurrentPoint(context);
            CGContextAddLineToPoint(context, self.rootPoint.x + self.maxXLength + vw, pt.y);
            CGContextDrawPath(context, kCGPathStroke);
            
            CGPoint labelPoint = CGPointMake((self.rootPoint.x - (size.width) < 0 ? 0 : self.rootPoint.x - (size.width)) - self.lineWidth * 1.5, currentY);
            
            NSString *verticalUnitLabel = [NSString stringWithFormat:@"%d",unitY];
            [self drawLabel:verticalUnitLabel
                   fontSize:fontSizeLabel
                    atPoint:labelPoint
               onHorizontal:NO];
        }
        
        currentY -= vw;
    }
}

@end
