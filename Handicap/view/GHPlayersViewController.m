//
//  GHPlayersViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPlayersViewController.h"
#import "GHPlayer.h"
#import "GHAddOrEditPlayerViewController.h"

@interface GHPlayersViewController ()

@end

@implementation GHPlayersViewController

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHPlayerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GHPlayerCell"];
    }
    
    GHPlayer *player = (GHPlayer*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = [player description];
    
    if (player.handicapIndex != nil && [player.handicapIndex intValue] != NSNotFound) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Index: %2.1f", [player.handicapIndex doubleValue]];
    } else {
        cell.detailTextLabel.text = @"Index: NH";
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editPlayerSegue" sender:self];
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
    return [GHPlayer class];
}

#pragma mark -
#pragma mark Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"editPlayerSegue" isEqualToString:segue.identifier]) {
        
        GHAddOrEditPlayerViewController *controller = (GHAddOrEditPlayerViewController*)segue.destinationViewController;
        
        GHPlayer *selectedPlayer =  (GHPlayer*)[self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        controller.player = selectedPlayer;
    }
}


@end
