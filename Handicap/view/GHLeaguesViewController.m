//
//  GHLeaguesViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHLeaguesViewController.h"
#import "GHLeague.h"
#import "GHAddOrEditLeagueViewController.h"
@interface GHLeaguesViewController ()
@end

@implementation GHLeaguesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ignoreChange = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - Table View
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHLeagueCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GHLeagueCell"];
    }
    
    GHLeague *league = (GHLeague*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = league.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d players", league.players.count];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editLeagueSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SSManagedObject *obj = (SSManagedObject*)[self.fetchedResultsController objectAtIndexPath:indexPath];
        [obj delete];
        
    }
}


#pragma mark -
#pragma SSDataKit Overrides
-(Class)entityClass {
    return [GHLeague class];
}

#pragma mark -
#pragma mark Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"editLeagueSegue" isEqualToString:segue.identifier]) {
        
        GHAddOrEditLeagueViewController *controller = (GHAddOrEditLeagueViewController*)segue.destinationViewController;
        
        GHLeague *selectedLeague =  (GHLeague*)[self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        controller.league = selectedLeague;
    }
}
@end
