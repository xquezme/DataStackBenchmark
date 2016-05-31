//
//  ViewController.h
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 26/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BenchmarkType) {
    BenchmarkTypeWriting,
    BenchmarkTypeReading,
    BenchmarkTypeCounting
};

@interface ViewController : UIViewController

@property BenchmarkType type;

@end

