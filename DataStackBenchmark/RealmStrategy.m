//
//  RealmStrategy.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "RealmStrategy.h"
#import <Realm/Realm.h>
#import "RLMPerson.h"

@implementation RealmStrategy

+ (NSString *)name {
    return @"Realm 1.0.0";
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

    NSString *filePath = [[RLMRealm defaultRealm].configuration.fileURL absoluteString];

    NSLog(@"Realm --> %@", filePath);
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)cleanFiles {
    NSFileManager *manager = [NSFileManager defaultManager];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];

    NSArray<NSURL *> *realmFileURLs =
    @[ config.fileURL,
       [config.fileURL URLByAppendingPathExtension:@"lock"],
       [config.fileURL URLByAppendingPathExtension:@"log_a"],
       [config.fileURL URLByAppendingPathExtension:@"log_b"],
       [config.fileURL URLByAppendingPathExtension:@"note"],
       [config.fileURL URLByAppendingPathExtension:@"managment"] ];

    for (NSURL *URL in realmFileURLs) {
        [manager removeItemAtURL:URL error:nil];
    }
}

- (void)clear {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteAllObjects];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (NSArray<NSString *> *)writeObjectsWithCapacity:(NSUInteger)capacity {
    NSMutableArray *uuids = [NSMutableArray arrayWithCapacity:capacity];

    [[RLMRealm defaultRealm] beginWriteTransaction];

    for (NSUInteger i = 0; i < capacity; i ++) {
        RLMPerson *person = [RLMPerson new];

        NSString *uuid = [NSUUID UUID].UUIDString;
        person.uuid = uuid;
        person.age = [NSNumber numberWithShort:18];
        person.name = @"Andrew";
        person.username = @"andrew";
        person.created = [NSDate date];

        [[RLMRealm defaultRealm] addObject:person];

        [uuids addObject:uuid];
    }

    [[RLMRealm defaultRealm] commitWriteTransaction];

    return [uuids copy];
}

- (NSArray<NSString *> *)writeObjectsToDiskOnlyWithCapacity:(NSUInteger)capacity {
    // TODO: flush internal cache?
    return [self writeObjectsWithCapacity:capacity];
}

- (void)readObjectWithUUID:(NSString *)uuid {
    RLMResults *result = [RLMPerson objectsWhere:@"uuid = %@", uuid];
    RLMPerson *person = result.firstObject;
    NSParameterAssert(person.uuid);
}

- (NSUInteger)countAll {
    return [RLMPerson allObjects].count;
}

@end
