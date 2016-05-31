//
//  DataStackBenchmarkableStrategy.h
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#ifndef DataStackBenchmarkableStrategy_h
#define DataStackBenchmarkableStrategy_h

@protocol DataStackBenchmarkableStrategy <NSObject>

+ (NSString *)name;

- (NSArray<NSString *> *)writeObjectsToDiskOnlyWithCapacity:(NSUInteger)capacity;
- (NSArray<NSString *> *)writeObjectsWithCapacity:(NSUInteger)capacity;
- (void)readObjectWithUUID:(NSString *)uuid;
- (NSUInteger)countAll;

- (void)cleanFiles;
- (void)clear;

@end

#endif /* DataStackBenchmarkableStrategy_h */
