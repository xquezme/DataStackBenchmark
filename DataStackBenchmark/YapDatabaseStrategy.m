//
//  YapDatabaseStrategy.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "YapDatabaseStrategy.h"
#import "YPDPerson.h"
#import <YapDatabase/YapDatabase.h>

@interface YapDatabaseStrategy ()

@property (nonatomic, strong) YapDatabase *yapDataBase;
@property (nonatomic, strong) YapDatabaseConnection *writeConnection;

@end


@implementation YapDatabaseStrategy

+ (NSString *)name {
    return @"YapDataBase 2.9.1";
}

- (instancetype)init {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    [self cleanFiles];

    NSString *databasePath = [self databasePath];

    NSLog(@"YapDataBase --> %@", databasePath);
    
    self.yapDataBase = [[YapDatabase alloc] initWithPath:databasePath];

    self.writeConnection = [self.yapDataBase newConnection];
    self.writeConnection.metadataCacheEnabled = NO;
    [self.writeConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {

    }];
}

- (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    NSString *databasePath = [baseDir stringByAppendingPathComponent:@"yapDataBase.sqlite"];
    return databasePath;
}

- (void)cleanFiles {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *databasePath = [self databasePath];
    NSURL *databaseURL = [NSURL fileURLWithPath:databasePath];

    NSArray<NSURL *> *yapdatabaseFileURLs =
    @[ databaseURL,
       [[databaseURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-shm"],
       [[databaseURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-wal"] ];

    for (NSURL *URL in yapdatabaseFileURLs) {
        [manager removeItemAtURL:URL error:nil];
    }
}

- (void)clear {
    [self.writeConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction removeAllObjectsInAllCollections];
    }];
}

- (NSArray<NSString *> *)writeObjectsWithCapacity:(NSUInteger)capacity {
    self.writeConnection.objectCacheEnabled = YES;
    self.writeConnection.objectCacheLimit = capacity;

    NSMutableArray *uuids = [NSMutableArray arrayWithCapacity:capacity];

    [self.writeConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        for (NSUInteger i = 0; i < capacity; i ++) {
            YPDPerson *person = [YPDPerson new];

            NSString *uuid = [NSUUID UUID].UUIDString;
            person.uuid = uuid;
            person.age = [NSNumber numberWithShort:18];
            person.name = @"Andrew";
            person.username = @"andrew";
            person.created = [NSDate date];

            [transaction setObject:person forKey:person.uuid inCollection:@"people"];

            [uuids addObject:person.uuid];
        }
    }];
    
    return [uuids copy];
}

- (NSArray<NSString *> *)writeObjectsToDiskOnlyWithCapacity:(NSUInteger)capacity {
    self.writeConnection.objectCacheLimit = 0;
    self.writeConnection.objectCacheEnabled = NO;

    NSMutableArray *uuids = [NSMutableArray arrayWithCapacity:capacity];

    [self.writeConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        for (NSUInteger i = 0; i < capacity; i ++) {
            YPDPerson *person = [YPDPerson new];

            NSString *uuid = [NSUUID UUID].UUIDString;
            person.uuid = uuid;
            person.age = [NSNumber numberWithShort:18];
            person.name = @"Andrew";
            person.username = @"andrew";
            person.created = [NSDate date];

            [transaction setObject:person forKey:person.uuid inCollection:@"people"];

            [uuids addObject:person.uuid];
        }
    }];
    
    return [uuids copy];
}

- (void)readObjectWithUUID:(NSString *)uuid {
    [self.writeConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        YPDPerson *person = [transaction objectForKey:uuid inCollection:@"people"];
        NSParameterAssert(person.uuid);
    }];
}

- (NSUInteger)countAll {
    __block NSUInteger count = 0;

    [self.writeConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        count = [transaction numberOfKeysInCollection:@"people"];
    }];

    return count;
}

@end
