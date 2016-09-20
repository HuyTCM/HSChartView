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

@interface ViewController () <HSLineChartViewDataSource, HSLineChartViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avaImage;

@property (strong, nonatomic) NSMutableArray<NSValue *> *pointArr;
@property (strong, nonatomic) NSMutableArray<NSValue *> *pointArr1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pointArr = [[NSMutableArray alloc] init];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(10, 10)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(15, 25)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(20, 26)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(30, 33)]];
    [self.pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(40, 37)]];
    
    self.pointArr1 = [[NSMutableArray alloc] init];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(15, 15)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(20, 30)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(25, 31)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(35, 38)]];
    [self.pointArr1 addObject:[NSValue valueWithCGPoint:CGPointMake(45, 42)]];
    
    HSLineChartView *chartView = [[HSLineChartView alloc] initWithFrame:CGRectMake(20, 20, 128, 128)];
    chartView.delegate = self;
    chartView.dataSource = self;
    [self.view addSubview:chartView];
    
    self.avaImage.layer.cornerRadius = 128/2;
}

-(NSInteger)chartView:(HSLineChartView *)chartView numberOfValueInLine:(NSInteger)line {
    if (line == 1) {
        return [self.pointArr1 count];
    }
    return [self.pointArr count];
}

-(NSValue *)chartView:(HSLineChartView *)chartView valueAtIndex:(NSInteger)index inLine:(NSInteger)line {
    if (line == 1) {
        return [self.pointArr1 objectAtIndex:index];
    }
    return [self.pointArr objectAtIndex:index];
}

-(NSInteger)numberOfLineInChartView:(HSLineChartView *)chartView {
    return 2;
}

-(UIColor *)colorOfLine:(NSInteger)line {
    if (line == 1) {
        return [UIColor greenColor];
    }
    return [UIColor redColor];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
