//
//  Violation.h
//  SampleTable
//
//  Created by Matt Luedke on 7/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Violation : NSObject

@property (nonatomic, retain) NSString *violation_id;
@property (nonatomic, retain) NSString *inspection_id;
@property (nonatomic, retain) NSString *violation_category;
@property (nonatomic, retain) NSDate *violation_date;
@property (nonatomic, retain) NSString *violation_date_closed;
@property (nonatomic, retain) NSString *violation_type;

@end
