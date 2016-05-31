//
//  YPDPerson.h
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPDPerson : NSObject <NSCoding>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSDate *created;

@end
