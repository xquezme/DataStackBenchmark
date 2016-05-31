//
//  BenchmarkRunner.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 30/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "BenchmarkRunner.h"
#import "DataStackBenchmarkableStrategy.h"
#import "DataStackBenchmarkResult.h"

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

@implementation BenchmarkRunner

#pragma mark -- Count 

- (uint64_t)testCountingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy
                            capacity:(NSUInteger)capacity {
    @autoreleasepool {
        [strategy clear];
        [strategy writeObjectsWithCapacity:capacity];

        uint64_t t = dispatch_benchmark(100, ^{
            NSUInteger count = [strategy countAll];
            NSAssert(count == capacity, @"Implementation error");
        }) / 1000;

        return t;
    }
}

- (DataStackBenchmarkResult *)testCountingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy {
    uint64_t t1 = [self testCountingWithStrategy:strategy
                                        capacity:1];
    uint64_t t10 = [self testCountingWithStrategy:strategy
                                         capacity:10];
    uint64_t t100 = [self testCountingWithStrategy:strategy
                                          capacity:100];
    uint64_t t1000 = [self testCountingWithStrategy:strategy
                                           capacity:1000];
    uint64_t t10000 = [self testCountingWithStrategy:strategy
                                            capacity:10000];
    uint64_t t100000 = [self testCountingWithStrategy:strategy
                                             capacity:100000];
    [strategy clear];

    DataStackBenchmarkResult *result = [DataStackBenchmarkResult new];

    result.stackName = [[strategy class] name];
    result.t1 = t1;
    result.t10 = t10;
    result.t100 = t100;
    result.t1000 = t1000;
    result.t10000 = t10000;
    result.t100000 = t100000;

    NSLog(@"[%@ countAll:1] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t1);
    NSLog(@"[%@ countAll:10] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t10);
    NSLog(@"[%@ countAll::100] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t100);
    NSLog(@"[%@ countAll:1000] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t1000);
    NSLog(@"[%@ countAll:10000] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t10000);
    NSLog(@"[%@ countAll:100000] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t100000);
    
    return result;
}

#pragma mark -- Read by primary key

- (uint64_t)testReadingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy
                           capacity:(NSUInteger)capacity {

    @autoreleasepool {
        [strategy clear];

        NSArray<NSString *> *uuids = [strategy writeObjectsWithCapacity:capacity];
        NSMutableSet *uuidsSet = [NSMutableSet setWithArray:uuids];

        uint64_t t = dispatch_benchmark(capacity, ^{
            NSString *uuid = uuidsSet.anyObject;
            [strategy readObjectWithUUID:uuid];
            [uuidsSet removeObject:uuid];
        }) / 1000;

        return t;
    }
}

- (DataStackBenchmarkResult *)testReadingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy {
    uint64_t t1 = [self testReadingWithStrategy:strategy
                                       capacity:1];
    uint64_t t10 = [self testReadingWithStrategy:strategy
                                        capacity:10];
    uint64_t t100 = [self testReadingWithStrategy:strategy
                                         capacity:100];
    uint64_t t1000 = [self testReadingWithStrategy:strategy
                                          capacity:1000];
    uint64_t t10000 = [self testReadingWithStrategy:strategy
                                           capacity:10000];
    uint64_t t100000 = [self testReadingWithStrategy:strategy
                                            capacity:100000];
    [strategy clear];

    DataStackBenchmarkResult *result = [DataStackBenchmarkResult new];

    result.stackName = [[strategy class] name];
    result.t1 = t1;
    result.t10 = t10;
    result.t100 = t100;
    result.t1000 = t1000;
    result.t10000 = t10000;
    result.t100000 = t100000;

    NSLog(@"[%@ readObjectWithUUID:1] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t1);
    NSLog(@"[%@ readObjectWithUUID:10] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t10);
    NSLog(@"[%@ readObjectWithUUID:100] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t100);
    NSLog(@"[%@ readObjectWithUUID:1000] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t1000);
    NSLog(@"[%@ readObjectWithUUID:10000] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t10000);
    NSLog(@"[%@ readObjectWithUUID:100000] Avg. Runtime: %llu μs", NSStringFromClass([strategy class]), t100000);

    return result;
}

#pragma mark -- Insert

- (uint64_t)testWritingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy
                           capacity:(NSUInteger)capacity {
    @autoreleasepool {
        [strategy clear];

        uint64_t t = dispatch_benchmark(1, ^{
            [strategy writeObjectsToDiskOnlyWithCapacity:capacity];
        }) / 100000;

        return t;
    }
}

- (DataStackBenchmarkResult *)testWritingWithStrategy:(id<DataStackBenchmarkableStrategy>)strategy {
    uint64_t t1 = [self testWritingWithStrategy:strategy
                                       capacity:1];
    uint64_t t10 = [self testWritingWithStrategy:strategy
                                        capacity:10];
    uint64_t t100 = [self testWritingWithStrategy:strategy
                                         capacity:100];
    uint64_t t1000 = [self testWritingWithStrategy:strategy
                                          capacity:1000];
    uint64_t t10000 = [self testWritingWithStrategy:strategy
                                           capacity:10000];
    uint64_t t100000 = [self testWritingWithStrategy:strategy
                                            capacity:100000];
    [strategy clear];

    DataStackBenchmarkResult *result = [DataStackBenchmarkResult new];

    result.stackName = [[strategy class] name];
    result.t1 = t1;
    result.t10 = t10;
    result.t100 = t100;
    result.t1000 = t1000;
    result.t10000 = t10000;
    result.t100000 = t100000;

    NSLog(@"[%@ writeObjectsWithCapacity:1] Avg. Runtime: %llu ms", NSStringFromClass([strategy class]), t1);
    NSLog(@"[%@ writeObjectsWithCapacity:10] Avg. Runtime: %llu ms", NSStringFromClass([strategy class]), t10);
    NSLog(@"[%@ writeObjectsWithCapacity:100] Avg. Runtime: %llu ms", NSStringFromClass([strategy class]), t100);
    NSLog(@"[%@ writeObjectsWithCapacity:1000] Avg. Runtime: %llu ms", NSStringFromClass([strategy class]), t1000);
    NSLog(@"[%@ writeObjectsWithCapacity:10000] Avg. Runtime: %llu ms", NSStringFromClass([strategy class]), t10000);
    NSLog(@"[%@ writeObjectsWithCapacity:100000] Avg. Runtime: %llu ms", NSStringFromClass([strategy class]), t100000);
    
    return result;
}

@end
