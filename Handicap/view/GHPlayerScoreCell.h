//
//  GHPlayerScoreCell.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/16/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHPlayerScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UITextField *score;

@end
