//
//  YPDPerson.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "YPDPerson.h"

@implementation YPDPerson

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.age = [decoder decodeObjectForKey:@"age"];
        self.created = [decoder decodeObjectForKey:@"created"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.created forKey:@"created"];
}

@end
