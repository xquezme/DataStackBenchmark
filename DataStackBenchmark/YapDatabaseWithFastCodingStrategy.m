//
//  YapDatabaseWithFastCodingStrategy.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "YapDatabaseWithFastCodingStrategy.h"
#import <YapDatabase/YapDatabase.h>
#import <FastCoding/FastCoder.h>

@interface YapDatabaseWithFastCodingStrategy ()

@property (nonatomic, strong) YapDatabase *yapDataBase;
@property (nonatomic, strong) YapDatabaseConnection *writeConnection;

@end

@implementation YapDatabaseWithFastCodingStrategy

+ (NSString *)name {
    return @"YapDataBase 2.9.1 +FastCoding 3.2.1";
}

- (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    NSString *databasePath = [baseDir stringByAppendingPathComponent:@"yapDataBaseWithFastCoding.sqlite"];
    return databasePath;
}

- (void)commonInit {
    [self cleanFiles];

    NSString *databasePath = [self databasePath];

    NSLog(@"YapDataBase --> %@", databasePath);

    self.yapDataBase = [[YapDatabase alloc] initWithPath:databasePath serializer:^NSData * _Nonnull(NSString * _Nonnull collection, NSString * _Nonnull key, id  _Nonnull object) {
        return [FastCoder dataWithRootObject:object];
    } deserializer:^id _Nonnull(NSString * _Nonnull collection, NSString * _Nonnull key, NSData * _Nonnull data) {
        return [FastCoder objectWithData:data];
    }];

    self.writeConnection = [self.yapDataBase newConnection];
    self.writeConnection.metadataCacheEnabled = NO;
    [self.writeConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {

    }];
}

@end
