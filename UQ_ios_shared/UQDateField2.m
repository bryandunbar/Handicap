//
//  UQDateField2.m
//  uHost
//
//  Created by Bryan Dunbar on 3/5/13.
//  Copyright (c) 2013 iPwn Technologies, LLC. All rights reserved.
//

#import "UQDateField2.h"

@interface UQDateField2 ()

-(void)datePickerChanged:(id)sender;
@end

@implementation UQDateField2
@synthesize picker=_picker;
@synthesize dateMode=_dateMode;


-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    self.dateStyle = NSDateFormatterShortStyle;
    self.timeStyle = NSDateFormatterShortStyle;
    self.inputView = self.picker;
}
-(void)setSelectedDate:(NSDate *)date {
    self.picker.date = date;
    self.text = [NSDateFormatter localizedStringFromDate:self.picker.date dateStyle:self.dateStyle timeStyle:self.timeStyle];

}
-(UIDatePicker*)picker {
    if (!_picker) {
        _picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        [_picker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _picker;
}

-(void)setDateMode:(UIDatePickerMode)dateMode {
    _dateMode = dateMode;
    self.picker.datePickerMode = _dateMode;
}

-(void)datePickerChanged:(id)sender {
    self.text = [NSDateFormatter localizedStringFromDate:self.picker.date dateStyle:self.dateStyle timeStyle:self.timeStyle];
    
    if ([self.dateFieldDelegate respondsToSelector:@selector(dateChanged:)]) {
        [self.dateFieldDelegate dateChanged:self.picker.date];
    }
}
@end