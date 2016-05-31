//
//  DataStackBenchmarkResult.h
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStackBenchmarkResult : NSObject

@property (nonatomic, strong) NSString *stackName;
@property (nonatomic) uint64_t t1;
@property (nonatomic) uint64_t t10;
@property (nonatomic) uint64_t t100;
@property (nonatomic) uint64_t t1000;
@property (nonatomic) uint64_t t10000;
@property (nonatomic) uint64_t t100000;


@end
