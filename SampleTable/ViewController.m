//
//  ViewController.m
//  SampleTable
//
//  Created by Matt Luedke on 7/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "ViewController.h"
#import <CHCSVParser/CHCSVParser.h>
#import <CHCSVParser.h>

@interface ViewController () <CHCSVParserDelegate>

@property (nonatomic, retain) NSMutableArray *violation;
@property (nonatomic, retain) NSMutableArray *violations;

@end

@implementation ViewController

# pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.violations = [NSMutableArray array];
    
    // get CSV file
    NSError *err = nil;
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://forever.codeforamerica.org/fellowship-2015-tech-interview/Violations-2012.csv"] encoding:NSStringEncodingConversionAllowLossy error:&err];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithCSVString:csvString];
    parser.delegate = self;
    [parser parse];
    [self.tableView reloadData];
}

# pragma mark CHCSVParserDelegate

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
}

- (void) parser:(CHCSVParser *)parser didStartDocument:(NSString *)csvFile {
    NSLog(@"Parser started!");
}

- (void) parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)lineNumber
{
    // make new object
    self.violation = [NSMutableArray array];
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    // add to object
    [self.violation addObject:field];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
    // if not first, then add object to array
    if (lineNumber > 1) {
        [self.violations addObject:self.violation];
    }
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.violations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"Violations";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
    }
    
    NSArray *currentViolation = [self.violations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [currentViolation objectAtIndex:2];
    cell.detailTextLabel.text = [currentViolation objectAtIndex:5];
    
    return cell;
}

@end
