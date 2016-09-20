//
//  ViewController.m
//  Account
//
//  Created by HuyTCM1 on 9/19/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "ViewController.h"
#import "HSChartView.h"

@interface ViewController () <HSChartViewDataSource>

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
    
    HSChartView *chartView = [[HSChartView alloc] initWithFrame:CGRectMake(20, 20, 128, 128)];
    chartView.backgroundColor = [UIColor clearColor];
    chartView.dataSource = self;
    [self.view addSubview:chartView];
    
    self.avaImage.layer.cornerRadius = 128/2;
}

-(NSInteger)chartView:(HSChartView *)chartView numberOfValueInLine:(NSInteger)line {
    if (line == 1) {
        return [self.pointArr1 count];
    }
    return [self.pointArr count];
}

-(NSValue *)chartView:(HSChartView *)chartView valueAtIndex:(NSInteger)index inLine:(NSInteger)line {
    if (line == 1) {
        return [self.pointArr1 objectAtIndex:index];
    }
    return [self.pointArr objectAtIndex:index];
}

-(NSInteger)numberOfLineInChartView:(HSChartView *)chartView {
    return 2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
