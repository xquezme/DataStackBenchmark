//
//  BenchmarkRunner.h
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 30/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStackBenchmarkableStrategy.h"

@class DataStackBenchmarkResult;

@interface BenchmarkRunner : NSObject

- (DataStackBenchmarkResult *)testCountingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy;
- (DataStackBenchmarkResult *)testWritingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy;
- (DataStackBenchmarkResult *)testReadingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy;

@end
