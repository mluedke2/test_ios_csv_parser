//
//  ViewController.m
//  SampleTable
//
//  Created by Matt Luedke on 7/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "ViewController.h"
#import <CHCSVParser/CHCSVParser.h>
#import "Violation.h"

@interface ViewController () <CHCSVParserDelegate>

@property (nonatomic, retain) Violation *violation;
@property (nonatomic, retain) NSMutableArray *violations;

@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, retain) NSMutableArray *stats;

@end

@implementation ViewController

# pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.violations = [NSMutableArray array];
    self.categories = [NSMutableDictionary dictionary];
    self.stats = [NSMutableArray array];
    
    // get CSV file
    NSError *err = nil;
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://forever.codeforamerica.org/fellowship-2015-tech-interview/Violations-2012.csv"] encoding:NSStringEncodingConversionAllowLossy error:&err];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithCSVString:csvString];
    parser.delegate = self;
    [parser parse];
    
    // once parsed, sort and get the stats results!
    for (NSString *key in self.categories.allKeys) {
        // printing count of each category!
        NSLog(@"category: %@. count: %i", key, [[self.categories objectForKey:key] count]);
    }
    
    // reload UI
    [self.tableView reloadData];
}

# pragma mark CHCSVParserDelegate

- (void) parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)lineNumber
{
    // make new object
    self.violation = [Violation new];
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    // add to object
    switch (fieldIndex) {
        case 0:
            self.violation.violation_id = field;
            break;
        case 1:
            self.violation.inspection_id = field;
            break;
        case 2:
            self.violation.violation_category = field;
            break;
        case 3:
            self.violation.violation_date = field;
            break;
        case 4:
            self.violation.violation_date_closed = field;
            break;
        case 5:
            self.violation.violation_type = field;
            break;
        default:
            break;
    }
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
    // if not first, then add object to array
    if (lineNumber > 1) {
        [self.violations addObject:self.violation];
        
        // also sort by category
        NSMutableArray *thisCategory = [self.categories objectForKey:self.violation.violation_category];
        
        if (!thisCategory) {
            [self.categories setObject:[NSMutableArray arrayWithObject:self.violation] forKey:self.violation.violation_category];
        } else {
            [thisCategory addObject:self.violation];
        }
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
    
    Violation *currentViolation = [self.violations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentViolation.violation_category;
    cell.detailTextLabel.text = currentViolation.violation_type;
    
    return cell;
}

@end
