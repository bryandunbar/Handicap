//
//  GHHandicapSelectionViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/17/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHHandicapSelectionViewController.h"
#import "BDPickerField.h"
#import <CoreData/CoreData.h>
#import "GHCourse.h"
#import "GHLeague.h"
#import "GHHandicapListViewController.h"

#define LEAGUE_TAG      1000
#define COURSE_TAG      1001
#define NO_COURSE_LABEL @"<No Course, Show Index>"

@interface GHHandicapSelectionViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_leagues;
    NSArray *_courses;
}
@property (weak, nonatomic) IBOutlet BDPickerField *leaguePicker;
@property (weak, nonatomic) IBOutlet BDPickerField *coursePicker;
@property (weak, nonatomic) IBOutlet UISwitch *scoresSwitch;

@property (nonatomic,strong) GHLeague *selectedLeague;
@property (nonatomic,strong) GHCourse *selectedCourse;

@end

@implementation GHHandicapSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.coursePicker.picker.dataSource = self;
    self.coursePicker.picker.tag = COURSE_TAG;
    self.coursePicker.picker.delegate = self;
    self.leaguePicker.picker.delegate = self;
    self.leaguePicker.picker.dataSource = self;
    self.leaguePicker.picker.tag = LEAGUE_TAG;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectedCourse:(GHCourse *)selectedCourse {
    if (_selectedCourse != selectedCourse) {
        _selectedCourse = selectedCourse;
        self.coursePicker.text = _selectedCourse ? [_selectedCourse description] : NO_COURSE_LABEL;
        [self.tableView reloadData];
    }
}

-(void)setSelectedLeague:(GHLeague *)selectedLeague {
    if (_selectedLeague != selectedLeague) {
        _selectedLeague = selectedLeague;
        self.leaguePicker.text = selectedLeague.name;
        [self.tableView reloadData];
    }
}
#pragma mark -
#pragma mark - Get Data
-(void)getData {
    
    [self getLeaguesWithBlock:^(NSArray *leagues) {
        _leagues = leagues;
        if (_leagues.count > 0) self.selectedLeague = _leagues[0];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self getCoursesWithBlock:^(NSArray *courses) {
        NSMutableArray *arr = [NSMutableArray arrayWithObject:NO_COURSE_LABEL];
        [arr addObjectsFromArray:courses];
        _courses = arr;
        if (_courses.count > 1) {self.selectedCourse = _courses[1];
            [self.coursePicker setSelectedRow:1 inComponent:0 animated:NO];
        }

        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}
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
        
        if (row == 0) {
            return NO_COURSE_LABEL;
        } else {
            GHCourse *course = _courses[row];
            return [course description];
        }
    }
    
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == LEAGUE_TAG)
        self.selectedLeague = _leagues[row];
    else if (pickerView.tag == COURSE_TAG) {
        
        if (row == 0)
            self.selectedCourse = nil;
        else
            self.selectedCourse = _courses[row];
    }
}

#pragma mark -
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"getHandicapsSegue" isEqualToString:segue.identifier]) {
        GHHandicapListViewController *controller = (GHHandicapListViewController*)segue.destinationViewController;
        controller.league = self.selectedLeague;
        controller.course = self.selectedCourse;
        controller.useScoresFromSelectedLeagueOnly = self.scoresSwitch.on;
    }
    
}


@end
