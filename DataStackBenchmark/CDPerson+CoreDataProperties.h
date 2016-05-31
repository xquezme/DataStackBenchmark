//
//  CDPerson+CoreDataProperties.h
//  
//
//  Created by Sergey Pimenov on 28/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPerson (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nonatomic) int16_t age;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic, strong) NSDate *created;

@end

NS_ASSUME_NONNULL_END
