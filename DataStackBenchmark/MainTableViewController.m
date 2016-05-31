//
//  MainTableViewController.m
//  DataStackBenchmark
//
//  Created by Sergey Pimenov on 27/05/16.
//  Copyright © 2016 Sergey Pimenov. All rights reserved.
//

#import "MainTableViewController.h"
#import "ViewController.h"

@implementation MainTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Default" forIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Insert";
            break;
        case 1:
            cell.textLabel.text = @"Read by primary key";
            break;
        case 2:
            cell.textLabel.text = @"Count";
            break;
        default:
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"BenchmarkTest" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *vc = segue.destinationViewController;

    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:
            vc.type = BenchmarkTypeWriting;
            break;
        case 1:
            vc.type = BenchmarkTypeReading;
            break;
        case 2:
            vc.type = BenchmarkTypeCounting;
        default:
            break;
    }
}

@end
