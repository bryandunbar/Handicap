//
//  UQFormTableViewController.m
//  UQ
//
//  Created by Bryan Dunbar on 4/12/12.
//  Copyright (c) 2012 iPwn Technologies LLC. All rights reserved.
//

#import "UQFormTableViewController.h"

@interface UQFormTableViewController () {
    UIView *_selectedField;
    NSArray *_textFields;
}

-(UIView*)findFirstResponder:(UIView*)view;
-(UIView*)findNextField:(UIView*)field;
-(UIView*)findPrevField:(UIView*)field;

-(void)configureNextPrev:(UIView*)view;

@property (nonatomic,strong) UQDefaultAccessoryInputView *inputAccessoryView;


@end

@implementation UQFormTableViewController
@synthesize inputAccessoryView  =_inputAccessoryView;
-(void)hideKeyboard {
    UIView *firstResponder = [self findFirstResponder:self.view];
    [firstResponder resignFirstResponder];
}

-(void)go {
    [self hideKeyboard];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setShowsDoneButton:(BOOL)showsDoneButton {
    self.inputAccessoryView.showsDoneButton = showsDoneButton;
}
-(BOOL)showsDoneButton {
    return self.inputAccessoryView.showsDoneButton;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    _selectedField = nil;
    int tag = textField.tag;
    
    id nextField = [self.tableView viewWithTag:tag + 1];
    if (nextField) {
        [nextField becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyGo) {
        [textField resignFirstResponder];
        [self go];
    } else if (textField.returnKeyType == UIReturnKeyDone && self.showsDoneButton) {
        [self hideKeyboard];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedField = textField;
    
    // Respect the no-scroll of the tableview
    if (self.tableView.scrollEnabled) {
        UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self configureNextPrev:_selectedField];
    });
    
    return YES;
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
    
    if (!responder)
        [currentResponder resignFirstResponder]; // Only resign if it's the last field
    [responder becomeFirstResponder];
    
}

-(void)configureNextPrev:(UIView*)view {
    UIView *prev = [self findPrevField:view];
    [self.inputAccessoryView.nextPrevSegment setEnabled:(prev != nil) forSegmentAtIndex:0];
    
    UIView *next = [self findNextField:view];
    [self.inputAccessoryView.nextPrevSegment setEnabled:(next != nil) forSegmentAtIndex:1];
}



- (UIView *)inputAccessoryView {
    
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[UQDefaultAccessoryInputView alloc] init];
        _inputAccessoryView.accessoryInputViewDelegate = self;
    }
    return _inputAccessoryView;
}

-(void)doneTapped:(UQDefaultAccessoryInputView*)sender {
    [self hideKeyboard];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Find the input view and pretend like it was selected :)
    for (UIView *view in cell.contentView.subviews){
        if ([view conformsToProtocol:@protocol(UITextInput)]) {
            [view becomeFirstResponder];
            break;
        }
    }
}


@end
