//
//  GHMainMenuViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/16/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHMainMenuViewController.h"
#import "GHLeague.h"
#import "GHPlayer.h"
#import "GHCourse.h"
#import "GHScore.h"

@interface GHMainMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getHandicapsButton;
@property (weak, nonatomic) IBOutlet UIButton *postScoresButton;
@property (weak, nonatomic) IBOutlet UILabel *needsSetupLabel;

@end

@implementation GHMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureView];
}

-(void)configureView {
    
    [self ensureAllData:^(BOOL setupComplete) {
        self.getHandicapsButton.enabled = setupComplete;
        self.postScoresButton.enabled = setupComplete;
        self.needsSetupLabel.hidden = setupComplete;
    }];
    
}

#pragma mark -
#pragma mark - Get Data
-(void)ensureAllData:(void (^)(BOOL))block  {
    
    NSManagedObjectContext *context = [GHLeague mainQueueContext];
    [context performBlock:^{
       
        NSFetchRequest *leagueFetchRequest = [[NSFetchRequest alloc] init];
        leagueFetchRequest.entity = [GHLeague entityWithContext:context];
        long leagueCount = [context countForFetchRequest:leagueFetchRequest error:nil];
        
        NSFetchRequest *playerFetchRequest = [[NSFetchRequest alloc] init];
        playerFetchRequest.entity = [GHPlayer entityWithContext:context];
        long playerCount = [context countForFetchRequest:playerFetchRequest error:nil];
        
        NSFetchRequest *courseFetchRequest = [[NSFetchRequest alloc] init];
        courseFetchRequest.entity = [GHCourse entityWithContext:context];
        long courseCount = [context countForFetchRequest:courseFetchRequest error:nil];
        
        BOOL setupComplete = leagueCount > 0 && playerCount > 0 && courseCount > 0;
        block(setupComplete);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    vc.hidesBottomBarWhenPushed = YES;
}
@end
