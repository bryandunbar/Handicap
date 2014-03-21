//
//  UQDateField2.h
//  uHost
//
//  Created by Bryan Dunbar on 3/5/13.
//  Copyright (c) 2013 iPwn Technologies, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UQDateFieldDelegate <NSObject>

-(void)dateChanged:(NSDate*)newDate;

@end

@interface UQDateField2 : UITextField

@property (nonatomic,readonly) UIDatePicker *picker;
@property (nonatomic,assign) UIDatePickerMode dateMode;
@property (nonatomic) NSDateFormatterStyle dateStyle;
@property (nonatomic) NSDateFormatterStyle timeStyle;
@property (nonatomic,weak) id<UQDateFieldDelegate> dateFieldDelegate;
-(void)initialize;

-(void)setSelectedDate:(NSDate*)date;
@end
