//
//  GHAddOrEditLeagueViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHAddOrEditLeagueViewController.h"
#import "GHSelectPlayersViewController.h"
#import "NSString+Additions.h"
@interface GHAddOrEditLeagueViewController () {
    
    NSMutableArray *_players;
    
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *numPlayers;

@end

@implementation GHAddOrEditLeagueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.league) {
        self.navigationItem.leftBarButtonItem = self.navigationItem.rightBarButtonItem = nil; // Pushed, use default back
        self.title = @"Edit League";
        _players = [NSMutableArray arrayWithArray:[self.league.players allObjects]];
    } else {
        _players = [NSMutableArray array];
    }
    
    [self configureView];
    [self.name becomeFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureView];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.league) {
        self.league.name = self.name.text;
        [self.league setPlayers:[NSSet setWithArray:_players]];
        [self.league save];
    }
}

-(void)configureView {
    
    if ([NSString isNilOrEmpty:self.name.text]) self.name.text = self.league.name;
    self.numPlayers.text = [NSString stringWithFormat:@"%d Player%@", _players.count, (_players.count == 1 ? @"" : @"s")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTapped:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)saveTapped:(id)sender {
    
    [self hideKeyboard];
    
    if (!self.league) {
        self.league = [[GHLeague alloc] init];
    }
    
    if ([self.navigationController viewControllers][0] == self)
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"selectPlayersSegue" isEqualToString:segue.identifier]) {
        GHSelectPlayersViewController *controller = (GHSelectPlayersViewController*)segue.destinationViewController;
        controller.selectedPlayers = _players;
    }
}
@end
