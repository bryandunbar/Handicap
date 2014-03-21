//
//  UQDefaultAccessoryInputView.m
//  uHost
//
//  Created by Bryan Dunbar on 2/4/13.
//  Copyright (c) 2013 iPwn Technologies, LLC. All rights reserved.
//

#import "UQDefaultAccessoryInputView.h"

@interface UQDefaultAccessoryInputView ()

-(void)configureButtons;

@end
@implementation UQDefaultAccessoryInputView
@synthesize nextPrevSegment=_nextPrevSegment;
@synthesize accessoryInputViewDelegate=_accessoryInputViewDelegate;
@synthesize extraButtons=_extraButtons;
@synthesize showsDoneButton=_showsDoneButton;

-(void)setShowsDoneButton:(BOOL)showsDoneButton {
    if (_showsDoneButton != showsDoneButton) {
        _showsDoneButton = showsDoneButton;
        [self configureButtons];
    }
}
-(UISegmentedControl*)nextPrevSegment {
    if (!_nextPrevSegment) {
        _nextPrevSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
        _nextPrevSegment.segmentedControlStyle = UISegmentedControlStyleBar;
        [_nextPrevSegment addTarget:self action:@selector(nextPrevTapped:) forControlEvents:UIControlEventValueChanged];
        _nextPrevSegment.momentary = YES;
    }
    return _nextPrevSegment;
}

-(id)init {
    return [self initWithExtraButtons:nil];
}

-(id)initWithExtraButtons:(NSArray *)extraButtons {
    if (self = [super init]) {
        _extraButtons = extraButtons;
        //self.barStyle = UIBarStyleBlack;
        //self.barStyle = UIBarStyleBlackTranslucent;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self sizeToFit];
        _showsDoneButton = YES;
        CGRect frame = self.frame;
        frame.size.height = 44.0f;
        self.frame = frame;
        [self configureButtons];
    }
    
    return self;
}

-(void)configureButtons {
    UIBarButtonItem *nextPrevBtn = [[UIBarButtonItem alloc] initWithCustomView:self.nextPrevSegment];
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpaceright = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSDictionary* textAttributes = @{
                                     UITextAttributeFont:[UIFont systemFontOfSize:16]
                                     };
    [nextPrevBtn setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    //[doneBtn setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:nextPrevBtn, flexibleSpaceLeft, flexibleSpaceright, nil];
    
    if (self.showsDoneButton) {
        [array addObject:doneBtn];
    } else {
        // Have to have something here to stop the flexible space
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = 1;
        [array addObject:space];
    }
    
    // Add any extra buttons
    for (int i = self.extraButtons.count - 1; i >= 0; i--) {
        
        UIBarButtonItem *extraButton = [self.extraButtons objectAtIndex:i];
        [extraButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        
        [array insertObject:extraButton atIndex:1]; // After the segment control
    }
    
    self.items = nil;
    [self setItems:array];
    [self setNeedsDisplay];

}

-(void)setExtraButtons:(NSArray *)extraButtons {
    _extraButtons = extraButtons;
    [self configureButtons];
}

-(void)nextPrevTapped:(UISegmentedControl *)sender {
    if ([self.accessoryInputViewDelegate respondsToSelector:@selector(nextPrevTapped:)]) {
        [self.accessoryInputViewDelegate nextPrevTapped:self.nextPrevSegment];
    }
}

-(void)done:(id)sender {
    if ([self.accessoryInputViewDelegate respondsToSelector:@selector(doneTapped:)]) {
        [self.accessoryInputViewDelegate doneTapped:self];
    }
    
}

@end
