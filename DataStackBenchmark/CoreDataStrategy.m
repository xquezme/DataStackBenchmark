//
//  CoreDataStrategy.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 28/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "CoreDataStrategy.h"
#import <CoreData/CoreData.h>
#import "CDPerson.h"

@interface CoreDataStrategy ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation CoreDataStrategy

+ (NSString *)name {
    return @"CoreData";
}

- (instancetype)init {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    NSString *databasePath = [baseDir stringByAppendingPathComponent:@"coreDataBase.sqlite"];
    return databasePath;
}

- (void)commonInit {
    [self cleanFiles];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];

    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;

    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(NO),
                               NSInferMappingModelAutomaticallyOption : @(NO),
                               NSPersistentStoreFileProtectionKey : NSFileProtectionNone };

    NSString *databasePath = [self databasePath];

    NSLog(@"CoreData --> %@", databasePath);

    [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:[NSURL fileURLWithPath:databasePath]
                                                        options:options
                                                          error:nil];

    [self clear];
}

- (void)cleanFiles {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *databasePath = [self databasePath];
    NSURL *databaseURL = [NSURL fileURLWithPath:databasePath];

    NSArray<NSURL *> *coredatadatabaseFileURLs =
    @[ databaseURL,
       [[databaseURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-shm"],
       [[databaseURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-wal"] ];

    for (NSURL *URL in coredatadatabaseFileURLs) {
        [manager removeItemAtURL:URL error:nil];
    }
}

- (void)clear {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;

    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];

    NSError *error;
    [self.managedObjectContext executeRequest:batchDeleteRequest error:&error];
    NSAssert(error == nil, @"%@", error);

    [self.managedObjectContext reset];
}

- (NSArray<NSString *> *)writeObjectsWithCapacity:(NSUInteger)capacity {
    NSMutableArray *uuids = [NSMutableArray arrayWithCapacity:capacity];

    for (NSUInteger i = 0; i < capacity; i ++) {
        CDPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"CDPerson"
                                                         inManagedObjectContext:self.managedObjectContext];
        NSString *uuid = [NSUUID UUID].UUIDString;
        person.uuid = uuid;
        person.age = 18;
        person.name = @"Andrew";
        person.username = @"andrew";
        person.created = [NSDate date];

        [uuids addObject:uuid];
    }

    NSError *error;
    [self.managedObjectContext save:&error];
    NSAssert(error == nil, @"%@", error);

    return [uuids copy];
}

- (NSArray<NSString *> *)writeObjectsToDiskOnlyWithCapacity:(NSUInteger)capacity {
    // TODO: flush internal cache?
    return [self writeObjectsWithCapacity:capacity];
}

- (void)readObjectWithUUID:(NSString *)uuid {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];

    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
    fetchRequest.includesPropertyValues = YES;
    fetchRequest.fetchLimit = 1;

    NSError *error;
    NSArray<CDPerson *> *people = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    CDPerson *person = people.firstObject;

    NSParameterAssert(person.uuid);

    NSAssert(error == nil, @"%@", error);
}

- (NSUInteger)countAll {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;

    NSError *error;
    NSUInteger numberOfObjects = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];

    NSAssert(error == nil, @"%@", error);

    return numberOfObjects;
}

@end
