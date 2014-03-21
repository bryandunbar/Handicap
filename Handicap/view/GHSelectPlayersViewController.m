//
//  GHSelectPlayersViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHSelectPlayersViewController.h"
#import "GHPlayer.h"
@interface GHSelectPlayersViewController ()

@end

@implementation GHSelectPlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma SSDataKit Overrides
-(Class)entityClass {
    return [GHPlayer class];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHSelectPlayersCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GHSelectPlayersCell"];
    }
    
    
    GHPlayer *player = (GHPlayer*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [player description];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_selectedPlayers containsObject:player]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellEditingStyleNone;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([_selectedPlayers containsObject:obj])
        [_selectedPlayers removeObject:obj];
    else
        [_selectedPlayers addObject:obj];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
