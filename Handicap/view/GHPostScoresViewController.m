//
//  GHPostScoresViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/16/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPostScoresViewController.h"
#import "GHLeague.h"
#import "GHPlayer.h"
#import "GHCourse.h"
#import "GHScore.h"
#import "GHPlayerScoreCell.h"
#import "UQDateField2.h"
#import "BDPickerField.h"
#import "GHAppDelegate.h"

#define LEAGUE_TAG      1000
#define COURSE_TAG      1001
#define DATE_TAG        1002
#define SCORE_BEGIN_TAG 1003

@interface GHPostScoresViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UQDateFieldDelegate> {
    NSArray *_leagues;
    NSArray *_courses;
    NSArray *_players;
}

@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic,strong) GHLeague *selectedLeague;
@property (nonatomic,strong) GHCourse *selectedCourse;

-(void)getCoursesWithBlock:(void (^)(NSArray *courses))block;
-(void)getLeaguesWithBlock:(void (^)(NSArray *leagues))block;
-(void)getPlayersWithBlock:(void (^)(NSArray *players))block;

@end

@implementation GHPostScoresViewController


-(void)setSelectedLeague:(GHLeague *)selectedLeague {
    
    if (_selectedLeague != selectedLeague) {
        _selectedLeague = selectedLeague;
        
        // Grab the players for the new league
        [self getPlayersWithBlock:^(NSArray *players) {
            _players = players;
            for (GHPlayer *player in _players) {
                player.score = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedDate = [NSDate date];
    
    [self getCoursesWithBlock:^(NSArray *courses) {
        _courses = courses;
        if (courses.count > 0)self.selectedCourse = _courses[0];
        
        [self getLeaguesWithBlock:^(NSArray *leagues) {
            _leagues = leagues;
            _players = nil;
            
            if (leagues.count > 0)
                [self setSelectedLeague:leagues[0]];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_players.count > 0)
        return 2;
    else
        return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3; // Leauge and Date
    } else {
        return _players.count;
    }
    
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Information";
    } else {
        return @"Players";
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) { // League Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHPostScoreLeagueCell"];
            
            BDPickerField *pickerField = (BDPickerField*)[cell viewWithTag:LEAGUE_TAG];
            pickerField.picker.delegate = self;
            pickerField.picker.dataSource = self;
            pickerField.picker.tag = LEAGUE_TAG;
            pickerField.text = self.selectedLeague.name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1){ // Course Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHPostScoreCourseCell"];
            
            BDPickerField *pickerField = (BDPickerField*)[cell viewWithTag:COURSE_TAG];
            pickerField.picker.delegate = self;
            pickerField.picker.tag = COURSE_TAG;
            pickerField.picker.dataSource = self;
            pickerField.text = [self.selectedCourse description];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else { // Date Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHPostScoreDateCell"];
            
            UQDateField2 *dateField =  (UQDateField2*)[cell viewWithTag:DATE_TAG];
            dateField.dateMode = UIDatePickerModeDate;
            dateField.dateStyle = NSDateFormatterShortStyle;
            dateField.timeStyle = NSDateFormatterNoStyle;
            dateField.dateFieldDelegate = self;
            [dateField setSelectedDate:self.selectedDate];

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    } else {
        
        // Players...
        GHPlayerScoreCell *cell = (GHPlayerScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"GHPlayerScoreCell"];
        GHPlayer *player = [_players objectAtIndex:indexPath.row];
        cell.playerName.text = [player description];
        cell.score.text = [player.score stringValue];
        cell.score.tag = SCORE_BEGIN_TAG + indexPath.row;
        cell.score.delegate = self;
        
        return cell;
    }
    

    
}

#pragma mark -
#pragma mark - Get Data
-(void)getLeaguesWithBlock:(void (^)(NSArray *))block  {
    
    NSManagedObjectContext *context = [GHLeague mainQueueContext];
    [context performBlock:^{
       
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [GHLeague entityWithContext:context];
        fetchRequest.sortDescriptors = [GHLeague defaultSortDescriptors];
        
        NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
        block(array);
    }];
}

-(void)getCoursesWithBlock:(void (^)(NSArray *))block {
    
    NSManagedObjectContext *context = [GHCourse mainQueueContext];
    [context performBlock:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [GHCourse entityWithContext:context];
        fetchRequest.sortDescriptors = [GHCourse defaultSortDescriptors];
        
        NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
        block(array);
    }];
}
-(void)getPlayersWithBlock:(void (^)(NSArray *))block {
    
    NSArray *arr = [[self.selectedLeague.players allObjects] sortedArrayUsingDescriptors:[GHPlayer defaultSortDescriptors]];
    block(arr);
}


#pragma mark - UIPickerViewDelegate and Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == LEAGUE_TAG)
        return [_leagues count];
    else if (pickerView.tag == COURSE_TAG)
        return [_courses count];
    
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == LEAGUE_TAG)
        return [[_leagues objectAtIndex:row] name];
    else if (pickerView.tag == COURSE_TAG) {
        GHCourse *course = _courses[row];
        return [course description];
    }
    
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == LEAGUE_TAG)
        self.selectedLeague = _leagues[row];
    else if (pickerView.tag == COURSE_TAG) {
        self.selectedCourse = _courses[row];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //[super textFieldDidEndEditing:textField];
    
    // Set the score value
    if (textField.tag >= SCORE_BEGIN_TAG) {
        
        int idx = textField.tag - SCORE_BEGIN_TAG;
        GHPlayer *player = _players[idx];
        player.score = @([textField.text integerValue]);
    }
}

-(void)dateChanged:(NSDate*)newDate {
    self.selectedDate = newDate;
}

#pragma mark -
#pragma mark Actions
- (IBAction)postTapped:(id)sender {
    [self hideKeyboard];
    
    // Create all the scores save and pop
    for (GHPlayer *player in _players) {
        NSLog(@"%@ %@: %d", player.firstName, player.lastName, [player.score intValue]);
        
        if ([player.score intValue] > 0) {
        
            GHScore *score = [[GHScore alloc] init];
            score.value = player.score;
            score.date = self.selectedDate;
            score.course = self.selectedCourse;
            score.league = self.selectedLeague;
            score.player = player;
            [score save];

            // Update the player as well
            [player addScoresObject:score];
            [player calculateIndex]; // Calls save for us
            
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    GHAppDelegate *app = (GHAppDelegate*)[UIApplication sharedApplication].delegate;
    [app.dbBackup backupDatabaseWithCompletion:nil];
    
    
}

@end
