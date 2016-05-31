//
//  ViewController.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "ViewController.h"
#import "DataStackBenchmarkableStrategy.h"
#import "YapDatabaseStrategy.h"
#import "RealmStrategy.h"
#import "YapDatabaseWithFastCodingStrategy.h"
#import "CoreDataStrategy.h"
#import "DataStackBenchmarkResult.h"
#import <Charts/Charts-Swift.h>
#import "BenchmarkRunner.h"

@interface ViewController () <ChartViewDelegate>

@property (nonatomic, strong) BarChartView *writingChartView;
@property (nonatomic, strong) BenchmarkRunner *benchmarkRunner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;

    self.writingChartView = [[BarChartView alloc] initWithFrame:CGRectZero];
    self.writingChartView.delegate = self;

    self.writingChartView.pinchZoomEnabled = NO;
    self.writingChartView.drawBarShadowEnabled = NO;
    self.writingChartView.drawGridBackgroundEnabled = NO;
    self.writingChartView.descriptionText = @"";
    self.writingChartView.noDataTextDescription = @"Please await...";

    ChartLegend *legend = self.writingChartView.legend;
    legend.font = [UIFont systemFontOfSize:11.f];

    ChartXAxis *xAxis = self.writingChartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];

    ChartYAxis *leftAxis = self.writingChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 1;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.spaceTop = 0.25;

    self.writingChartView.rightAxis.enabled = NO;

    [self.view addSubview:self.writingChartView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.writingChartView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    switch (self.type) {
        case BenchmarkTypeReading:
            [self testReading];
            break;
        case BenchmarkTypeWriting: {
            [self testWriting];
            break;
        }
        case BenchmarkTypeCounting: {
            [self testCounting];
            break;
        }
        default:
            break;
    }
}

- (BenchmarkRunner *)benchmarkRunner {
    if (_benchmarkRunner == nil) {
        _benchmarkRunner = [BenchmarkRunner new];
    }

    return _benchmarkRunner;
}

- (void)testWriting {
    DataStackBenchmarkResult *ypdWriteResult;
    DataStackBenchmarkResult *rlmWriteResult;
    DataStackBenchmarkResult *ypdWithFcWriteResult;
    DataStackBenchmarkResult *cdWriteResult;

    @autoreleasepool {
        YapDatabaseStrategy *ypdStrategy = [YapDatabaseStrategy new];
        ypdWriteResult = [self.benchmarkRunner testWritingWithStrategy:ypdStrategy];
    }

    @autoreleasepool {
        YapDatabaseWithFastCodingStrategy *ypdWithFcStrategy = [YapDatabaseWithFastCodingStrategy new];
        ypdWithFcWriteResult = [self.benchmarkRunner testWritingWithStrategy:ypdWithFcStrategy];
    }

    @autoreleasepool {
        RealmStrategy *rlmStrategy = [RealmStrategy new];
        rlmWriteResult = [self.benchmarkRunner testWritingWithStrategy:rlmStrategy];
    }

    @autoreleasepool {
        CoreDataStrategy *coreDataStrategy = [CoreDataStrategy new];
        cdWriteResult = [self.benchmarkRunner testWritingWithStrategy:coreDataStrategy];
    }

    [self updateChartYAxisFormatWithSuffix:@" ms"];
    [self updateChartDataWithResults:@[ ypdWriteResult, ypdWithFcWriteResult, rlmWriteResult, cdWriteResult ]];
}

- (void)testReading {
    DataStackBenchmarkResult *ypdWriteResult;
    DataStackBenchmarkResult *rlmWriteResult;
    DataStackBenchmarkResult *ypdWithFcWriteResult;
    DataStackBenchmarkResult *cdWriteResult;

    @autoreleasepool {
        YapDatabaseStrategy *ypdStrategy = [YapDatabaseStrategy new];
        ypdWriteResult = [self.benchmarkRunner testReadingWithStrategy:ypdStrategy];
    }

    @autoreleasepool {
        YapDatabaseWithFastCodingStrategy *ypdWithFcStrategy = [YapDatabaseWithFastCodingStrategy new];
        ypdWithFcWriteResult = [self.benchmarkRunner testReadingWithStrategy:ypdWithFcStrategy];
    }

    @autoreleasepool {
        RealmStrategy *rlmStrategy = [RealmStrategy new];
        rlmWriteResult = [self.benchmarkRunner testReadingWithStrategy:rlmStrategy];
    }

    @autoreleasepool {
        CoreDataStrategy *coreDataStrategy = [CoreDataStrategy new];
        cdWriteResult = [self.benchmarkRunner testReadingWithStrategy:coreDataStrategy];
    }

    [self updateChartYAxisFormatWithSuffix:@" μs"];
    [self updateChartDataWithResults:@[ ypdWriteResult, ypdWithFcWriteResult, rlmWriteResult, cdWriteResult ]];
}

- (void)testCounting {
    DataStackBenchmarkResult *ypdWriteResult;
    DataStackBenchmarkResult *rlmWriteResult;
    DataStackBenchmarkResult *ypdWithFcWriteResult;
    DataStackBenchmarkResult *cdWriteResult;

    @autoreleasepool {
        YapDatabaseStrategy *ypdStrategy = [YapDatabaseStrategy new];
        ypdWriteResult = [self.benchmarkRunner testCountingWithStrategy:ypdStrategy];
    }

    @autoreleasepool {
        YapDatabaseWithFastCodingStrategy *ypdWithFcStrategy = [YapDatabaseWithFastCodingStrategy new];
        ypdWithFcWriteResult = [self.benchmarkRunner testCountingWithStrategy:ypdWithFcStrategy];
    }

    @autoreleasepool {
        RealmStrategy *rlmStrategy = [RealmStrategy new];
        rlmWriteResult = [self.benchmarkRunner testCountingWithStrategy:rlmStrategy];
    }

    @autoreleasepool {
        CoreDataStrategy *coreDataStrategy = [CoreDataStrategy new];
        cdWriteResult = [self.benchmarkRunner testCountingWithStrategy:coreDataStrategy];
    }

    [self updateChartYAxisFormatWithSuffix:@" μs"];
    [self updateChartDataWithResults:@[ ypdWriteResult, ypdWithFcWriteResult, rlmWriteResult, cdWriteResult ]];
}

- (void)updateChartYAxisFormatWithSuffix:(NSString *)suffix {
    self.writingChartView.leftAxis.valueFormatter.negativeSuffix = suffix;
    self.writingChartView.leftAxis.valueFormatter.positiveSuffix = suffix;
}

- (void)updateChartDataWithResults:(NSArray<DataStackBenchmarkResult *> *)results {
    NSMutableArray<BarChartDataEntry *> *yVals1 = [NSMutableArray arrayWithCapacity:results.count];
    NSMutableArray<BarChartDataEntry *> *yVals10 = [NSMutableArray arrayWithCapacity:results.count];
    NSMutableArray<BarChartDataEntry *> *yVals100 = [NSMutableArray arrayWithCapacity:results.count];
    NSMutableArray<BarChartDataEntry *> *yVals1000 = [NSMutableArray arrayWithCapacity:results.count];
    NSMutableArray<BarChartDataEntry *> *yVals10000 = [NSMutableArray arrayWithCapacity:results.count];
    NSMutableArray<BarChartDataEntry *> *yVals100000 = [NSMutableArray arrayWithCapacity:results.count];

    NSMutableArray<NSString *> *xVals = [NSMutableArray arrayWithCapacity:results.count];

    [results enumerateObjectsUsingBlock:^(DataStackBenchmarkResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:obj.t1 xIndex:idx]];
        [yVals10 addObject:[[BarChartDataEntry alloc] initWithValue:obj.t10 xIndex:idx]];
        [yVals100 addObject:[[BarChartDataEntry alloc] initWithValue:obj.t100 xIndex:idx]];
        [yVals1000 addObject:[[BarChartDataEntry alloc] initWithValue:obj.t1000 xIndex:idx]];
        [yVals10000 addObject:[[BarChartDataEntry alloc] initWithValue:obj.t10000 xIndex:idx]];
        [yVals100000 addObject:[[BarChartDataEntry alloc] initWithValue:obj.t100000 xIndex:idx]];

        [xVals addObject:obj.stackName];
    }];

    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:[yVals1 copy] label:@"1 object"];
    [set1 setColor:[UIColor grayColor]];
    BarChartDataSet *set10 = [[BarChartDataSet alloc] initWithYVals:[yVals10 copy] label:@"10 object"];
    [set10 setColor:[UIColor yellowColor]];
    BarChartDataSet *set100 = [[BarChartDataSet alloc] initWithYVals:[yVals100 copy] label:@"100 object"];
    [set100 setColor:[UIColor orangeColor]];
    BarChartDataSet *set1000 = [[BarChartDataSet alloc] initWithYVals:[yVals1000 copy] label:@"1000 object"];
    [set1000 setColor:[UIColor redColor]];
    BarChartDataSet *set10000 = [[BarChartDataSet alloc] initWithYVals:[yVals10000 copy] label:@"10000 object"];
    [set10000 setColor:[UIColor brownColor]];
    BarChartDataSet *set100000 = [[BarChartDataSet alloc] initWithYVals:[yVals100000 copy] label:@"100000 object"];
    [set100000 setColor:[UIColor blackColor]];

    NSArray<BarChartDataSet *> *dataSets = @[ set1, set10, set100, set1000, set10000, set100000 ];

    BarChartData *data = [[BarChartData alloc] initWithXVals:[xVals copy] dataSets:dataSets];
    data.groupSpace = 0.8;
    [data setValueFont:[UIFont systemFontOfSize:10.f]];

    self.writingChartView.data = data;
}

@end
