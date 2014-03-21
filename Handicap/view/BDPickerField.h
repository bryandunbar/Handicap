//
//  BDPickerFIeld.h
//  Handicap
//
//  Created by Bryan Dunbar on 3/19/14.
//  Copyright (c) 2014 bdun. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BDPickerField : UITextField

@property (nonatomic, strong) UIPickerView *picker;

-(void)setSelectedRow:(NSUInteger)row inComponent:(NSUInteger)component animated:(BOOL)animated;

@end
