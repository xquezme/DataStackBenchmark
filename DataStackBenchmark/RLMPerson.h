//
//  RLMPerson.h
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMPerson : RLMObject

@property NSString *uuid;
@property NSString *name;
@property NSString *username;
@property NSNumber<RLMInt> *age;
@property NSDate *created;

@end
