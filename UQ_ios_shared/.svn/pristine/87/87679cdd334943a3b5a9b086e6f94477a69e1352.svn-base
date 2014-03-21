//
//  UIBorderedButton.m
//  Buttons
//
//  Created by Bryan Dunbar on 3/2/14.
//  Copyright (c) 2014 bdun. All rights reserved.
//

#import "UIBorderedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIBorderedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    self.layer.borderColor = self.tintColor.CGColor;
}

-(void)setEnabled:(BOOL)enabled {
    if (self.enabled != enabled) {
        [super setEnabled:enabled];
        
        if (!enabled) {
            self.layer.borderColor =[UIColor lightGrayColor].CGColor;
        } else {
            self.layer.borderColor = self.tintColor.CGColor;
        }
        [self setNeedsDisplay];
    }
}

-(void)setTintColor:(UIColor *)tintColor {
    
    if (self.tintColor != tintColor) {
        [super setTintColor:tintColor];
        self.layer.borderColor = tintColor.CGColor;
    }
    [self setNeedsDisplay];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
}





@end
