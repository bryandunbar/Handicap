//
//  BDPickerFIeld.m
//  Handicap
//
//  Created by Bryan Dunbar on 3/19/14.
//  Copyright (c) 2014 bdun. All rights reserved.
//

#import "BDPickerField.h"

@implementation BDPickerField

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
    self.inputView = self.picker;
}


-(UIPickerView*)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _picker.showsSelectionIndicator = YES;
        _picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _picker;
}

-(void)setSelectedRow:(NSUInteger)row inComponent:(NSUInteger)component animated:(BOOL)animated {
    [self.picker selectRow:row inComponent:component animated:animated];
}


-(void)pickerChanged:(id)sender {
//    self.text = [NSDateFormatter localizedStringFromDate:self.picker.date dateStyle:self.dateStyle timeStyle:self.timeStyle];
//    
//    if ([self.dateFieldDelegate respondsToSelector:@selector(dateChanged:)]) {
//        [self.dateFieldDelegate dateChanged:self.picker.date];
//    }
}
@end
