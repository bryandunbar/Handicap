//
//  UQDefaultAccessoryInputView.h
//  uHost
//
//  Created by Bryan Dunbar on 2/4/13.
//  Copyright (c) 2013 iPwn Technologies, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UQDefaultAccessoryInputView;

@protocol UQDefaultAccessoryInputViewDelegate <NSObject>
-(void)nextPrevTapped:(UISegmentedControl*)sender;
-(void)doneTapped:(UQDefaultAccessoryInputView*)sender;
@end

@interface UQDefaultAccessoryInputView : UIToolbar

@property (nonatomic,strong) UISegmentedControl *nextPrevSegment;
@property (nonatomic,weak) id<UQDefaultAccessoryInputViewDelegate> accessoryInputViewDelegate;
@property (nonatomic) BOOL showsDoneButton;
-(id)initWithExtraButtons:(NSArray*)extraButtons;
@property (nonatomic,strong) NSArray *extraButtons;


@end
