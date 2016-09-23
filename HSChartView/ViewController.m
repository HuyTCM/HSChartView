//
//  ViewController.m
//  Account
//
//  Created by HuyTCM1 on 9/19/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "CommonUtils.h"
#import "ViewController.h"
#import "HSLineChartView.h"
#import "HSLineChartViewLine.h"

@interface ViewController () <HSLineChartViewDataSource, HSLineChartViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avaImage;

@property (strong, nonatomic) NSMutableArray<NSValue *> *pointArr;
@property (strong, nonatomic) NSMutableArray<NSValue *> *pointArr1;

@property (strong, nonatomic)HSLineChartView *chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pointArr = [[NSMutableArray alloc] init];
//    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(3, 54)]];
//    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(4, 58)]];
//    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(6, 60)]];
//    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(8, 64)]];
//    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(150, 200)]];
    
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(10, 10)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(15, 25)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(20, 26)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(30, 33)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(150, 200)]];
    
    self.pointArr1 = [[NSMutableArray alloc] init];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(1, 45)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(2, 50)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(4, 60)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(7, 63)]];
//    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(210, 80)]];
    
    self.chartView = [[HSLineChartView alloc] initWithFrame:CGRectMake(20, 20, 256, 256)];
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    [self.chartView setBackgroundColor:[CommonUtils colorWithR:255.0f G:247.0f B:234.0f alpha:1.0f]];
    [self.chartView setAxisColor:[CommonUtils colorWithR:238.0f G:167.0f B:59.0f alpha:1.0f]];
    [self.chartView setLineWidth:5.0f];
//    [self.chartView setHorizontalUnitWidth:10];
//    [self.chartView setVerticalUnitWidth:3];
    [self.chartView setVerticalLabel:@"Kg"];
    [self.chartView setHorizontalLabel:@"Week"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    [scrollView setContentSize:CGSizeMake(256, 256)];
//    [scrollView addSubview:chartView];
    [self.view addSubview:self.chartView];
    
//    HSLineChartViewLine *line = [[HSLineChartViewLine alloc] initWithData:self.pointArr type:HSLineStraight];
//    for (NSValue *value  in line.lineData) {
//        CGPoint point = [value CGPointValue];
//        NSLog(@"%f, %f", line.maxXValue, line.maxYValue);
//    }
    
    self.avaImage.layer.cornerRadius = 128/2;
}

- (HSLineChartViewLine *)chartView:(HSLineChartView *)chartView lineAtIndex:(NSInteger)index {
    HSLineChartViewLine *line;
    if (index == 2) {
        line = [[HSLineChartViewLine alloc] initWithData:self.pointArr type:HSLineStraight];
        [line setLineColor:[UIColor redColor]];
//        [line setRootPoint:CGPointMake(20, 30)];
    } else {
        line = [[HSLineChartViewLine alloc]  initWithData:self.pointArr1 type:HSLineDashed];
        [line setLineColor:[UIColor greenColor]];
    }
//    [line setLineWidth:10.0f];
    return line;
}

//-(NSInteger)chartView:(HSLineChartView *)chartView numberOfValueInLine:(NSInteger)line {
//    if (line == 1) {
//        return [self.pointArr1 count];
//    }
//    return [self.pointArr count];
//}
//
//-(NSValue *)chartView:(HSLineChartView *)chartView valueAtIndex:(NSInteger)index inLine:(NSInteger)line {
//    if (line == 1) {
//        return [self.pointArr1 objectAtIndex:index];
//    }
//    return [self.pointArr objectAtIndex:index];
//}

-(NSInteger)numberOfLineInChartView:(HSLineChartView *)chartView {
    return 2;
}

-(UIColor *)colorOfLine:(NSInteger)line {
    if (line == 1) {
        return [UIColor greenColor];
    }
    return [UIColor redColor];
}

- (IBAction)update:(id)sender {
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(40, 72)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(39, 66)]];
    [self.chartView setNeedsDisplay];
    [self.view setNeedsDisplay];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
