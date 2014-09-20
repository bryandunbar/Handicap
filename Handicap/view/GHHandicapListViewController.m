//
//  GHHandicapListViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/17/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHHandicapListViewController.h"
#import "GHHandicapCalculator.h"
#import "GHPrintFormmater.h"
#import "GHWebViewController.h"

@interface GHHandicapListViewController () <UIWebViewDelegate, UIActionSheetDelegate> {
    NSArray *data;
    GHHandicapCalculator *calculator;
    
    UIMarkupTextPrintFormatter *cardPrintFormatter;
    UIMarkupTextPrintFormatter *listPrintFormatter;    
}

@property (nonatomic,strong) UIBarButtonItem *printButton;
@end

@implementation GHHandicapListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    calculator = [[GHHandicapCalculator alloc] init];
    
    // Load the table
    [self getDataWithBlock:^{
        [self.tableView reloadData];
        [self preparePrintFormatters];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Get Data
-(void)getDataWithBlock:(void (^)(void))block  {
    
    // Build the data
    NSArray *players = [self.league.players allObjects];
    players = [players sortedArrayUsingDescriptors:[GHPlayer defaultSortDescriptors]];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:players.count];
    
    int count = 0;
    for (GHPlayer *player in players) {
        
        
        // Build the predicate
        NSPredicate *predicate = nil;
        if (self.useScoresFromSelectedLeagueOnly) {
            predicate = [NSPredicate predicateWithFormat:@"league == %@", self.league];
        }
        
        if (self.useScoresFromSelectedCourseOnly) {
            NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"course == %@", self.course];
            if (!predicate) {
                predicate = subPredicate;
            } else {
                predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, subPredicate]];
            }
        }

        NSSet *scores = predicate != nil ?
            [player.scores filteredSetUsingPredicate:predicate] : player.scores;
        
        NSArray *usedScores = [NSArray array];
        double index = [calculator handicapIndexForScores:[scores allObjects] usedScores:&usedScores];
        NSUInteger trend = [calculator courseHandicapForHandicap:index forCourse:self.course];
        
        NSDictionary *dict = @{@"player":player, @"index":@(index), @"trend":@(trend), @"usedScores":usedScores};
        
        [arr addObject:dict];
        count++;
    }
    
    data = [arr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"player.lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"player.firstName" ascending:YES]]];
    block();
}

-(void)preparePrintFormatters {

    // No need to do this if we don't have the ability to print
    if ([UIPrintInteractionController isPrintingAvailable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
       
            GHPrintFormmater *pf = [[GHPrintFormmater alloc] init];
            cardPrintFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:[pf htmlCardsForData:data league:self.league andCourse:self.course showThisLeageOnly:self.useScoresFromSelectedLeagueOnly showThisCourseOnly:self.useScoresFromSelectedCourseOnly]];
            listPrintFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:[pf htmlRankingForData:data league:self.league andCourse:self.course]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Ok to show the print button now
                UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(printButtonTapped:)];
                [self.navigationItem setRightBarButtonItem:barButton animated:NO];
                self.printButton = barButton;
            });
        });
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return data.count;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.course)
        return [self.course description];
    else
        return @"Handicap Index";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GHHandicapListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = data[indexPath.row];
    GHPlayer *player = dict[@"player"];
    cell.textLabel.text = [player description];
    
    if (self.course) { // Showing trends
        NSUInteger trend = [dict[@"trend"] unsignedIntegerValue];
        if (trend == NSNotFound)
            cell.detailTextLabel.text = @"NH";
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", trend];
    } else {
        double index = [dict[@"index"] doubleValue];
        if (index == NSNotFound)
            cell.detailTextLabel.text = @"NH";
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%2.1f", index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Table view delegate


#pragma mark - Printing
-(void)printButtonTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Print", @"View Handicap Cards", nil];
    [actionSheet showFromBarButtonItem:self.printButton animated:YES];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        if (buttonIndex == GHHandicapListViewPrintCards) {
            [self performSegueWithIdentifier:@"getHandicapCardsSegue" sender:self];
        } else {
            [self print:buttonIndex];
        }
    }
}
-(void)print:(GHHandicapListViewPrintOptions)printOption {
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    
    if (printOption == GHHandicapListViewPrintCards) {
        pc.printFormatter = cardPrintFormatter;
        printInfo.jobName = @"Handicap Cards";
    } else {
        pc.printFormatter = listPrintFormatter;
        printInfo.jobName = @"Handicap Listing";
    }
    pc.printInfo = printInfo;
    //pc.showsPageRange = YES;

    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                  error.code);
        }
    };
    
    [pc presentAnimated:YES completionHandler:completionHandler];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GHWebViewController *viewController = (GHWebViewController*)segue.destinationViewController;
    viewController.printFormmatter = cardPrintFormatter;
}

@end
