//
//  UQFormViewController.m
//  uHost
//
//  Created by Bryan Dunbar on 1/5/13.
//  Copyright (c) 2013 iPwn Technologies. All rights reserved.
//

#import "UQFormViewController.h"
#import "NSObject+AlertHelper.h"
@interface UQFormViewController ()

-(UIView*)findFirstResponder:(UIView*)view;
-(UIView*)findNextField:(UIView*)field;
-(UIView*)findPrevField:(UIView*)field;

-(void)nextPrevTapped:(UISegmentedControl*)sender;
-(void)configureNextPrev:(UIView*)view;

@property (nonatomic,strong) UIToolbar *inputAccessoryView;
@property (nonatomic,strong) UISegmentedControl *nextPrevSegment;
@end

@implementation UQFormViewController
@synthesize inputAccessoryView  =_inputAccessoryView;
@synthesize nextPrevSegment=_nextPrevSegment;

-(void)hideKeyboard {
    UIView *firstResponder = [self findFirstResponder:self.view];
    [firstResponder resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    int tag = textField.tag;
    
    id nextField = [self.view viewWithTag:tag + 1];
    if (nextField) {
        [nextField becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyGo) {
        [self go];
    }
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self configureNextPrev:textField];
    
    
}
-(UIView*)findNextField:(UIView *)field {
    int tag = field.tag + 1;
    return [self.view viewWithTag:tag];
}
-(UIView*)findPrevField:(UIView *)field {
    int tag = field.tag - 1;
    
    if (tag > 0)
        return [self.view viewWithTag:tag];
    else
        return nil;
}

-(void)nextPrevTapped:(UISegmentedControl *)sender {
    
    int selectedIndex = sender.selectedSegmentIndex;

    UIView *currentResponder = [self findFirstResponder:self.view];
    UIView *responder = nil;
   
    if (selectedIndex == 0) {
        // Prev
        responder = [self findPrevField:currentResponder];
    } else {
        // Next
        responder = [self findNextField:currentResponder];
    }
    
    [currentResponder resignFirstResponder];
    [responder becomeFirstResponder];
    
}

-(void)configureNextPrev:(UIView*)view {
    UIView *prev = [self findPrevField:view];
    [self.nextPrevSegment setEnabled:(prev != nil) forSegmentAtIndex:0];
    
    UIView *next = [self findNextField:view];
    [self.nextPrevSegment setEnabled:(next != nil) forSegmentAtIndex:1];
}

-(void)go {
    
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

- (UIView *)inputAccessoryView {
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[UIToolbar alloc] init];
        _inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
        _inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_inputAccessoryView sizeToFit];
        CGRect frame = _inputAccessoryView.frame;
        frame.size.height = 44.0f;
        _inputAccessoryView.frame = frame;
        
        
       
        UIBarButtonItem *nextPrevBtn = [[UIBarButtonItem alloc] initWithCustomView:self.nextPrevSegment];
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:nextPrevBtn, flexibleSpaceLeft, doneBtn, nil];
        [_inputAccessoryView setItems:array];
    }
    return _inputAccessoryView;
}

-(void)done:(id)sender {
    [self hideKeyboard];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (UIView *)findFirstResponder:(UIView*)view {
	if (view.isFirstResponder) {
		return view;
	}
	
	for (UIView *subView in view.subviews) {
		UIView *firstResponder = [self findFirstResponder:subView];
		
		if (firstResponder != nil) {
			return firstResponder;
		}
	}
	
	return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
