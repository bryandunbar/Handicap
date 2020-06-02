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
#define TEES_TAG        1002
#define NO_COURSE_LABEL @"<No Course, Show Index>"
#define NO_TEES_LABEL   @"<All>"

@interface GHHandicapSelectionViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_leagues;
    NSArray *_allCourses;
    NSArray *_courses;
    NSArray *_tees;
}
@property (weak, nonatomic) IBOutlet BDPickerField *leaguePicker;
@property (weak, nonatomic) IBOutlet BDPickerField *coursePicker;
@property (weak, nonatomic) IBOutlet BDPickerField *teesPicker;
@property (weak, nonatomic) IBOutlet UISwitch *scoresSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *scoresFromThisCourseSwitch;

@property (nonatomic,strong) GHLeague *selectedLeague;
@property (nonatomic,strong) GHCourse *selectedCourse;

@property (nonatomic,strong) NSString *selectedTees;

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
    self.teesPicker.picker.dataSource = self;
    self.teesPicker.picker.tag = TEES_TAG;
    self.teesPicker.picker.delegate = self;
    
    self.scoresSwitch.on = NO;
    self.scoresFromThisCourseSwitch.on = NO;
    
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
        self.coursePicker.text = _selectedCourse ? [_selectedCourse name] : NO_COURSE_LABEL;
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

-(void)setSelectedTees:(NSString *)selectedTees {
    _selectedTees = selectedTees;
    self.teesPicker.text = _selectedTees ? _selectedTees : NO_TEES_LABEL;
    [self.tableView reloadData];
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
        _allCourses = courses;
        
        // Group courses by name
        NSMutableArray *tCourses = [NSMutableArray array];
        NSMutableArray *tTees = [NSMutableArray array];
        for (GHCourse *course in _allCourses) {
            NSArray *filtered = [tCourses filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", course.name]];
            if (filtered.count == 0) {
                [tCourses addObject:course];
            }
            
            if (![tTees containsObject:course.tees]) {
                [tTees addObject:course.tees];
            }
        }
        
        [tCourses insertObject:NO_COURSE_LABEL atIndex:0];
        _courses = [tCourses copy];
        if (_courses.count > 1) {self.selectedCourse = _courses[1];
            [self.coursePicker setSelectedRow:1 inComponent:0 animated:NO];
        }

        [tTees insertObject:NO_TEES_LABEL atIndex:0];
        _tees = [tTees copy];
        self.selectedTees = nil;
        [self.teesPicker setSelectedRow:0 inComponent:0 animated:NO];
        
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
    else if (pickerView.tag == TEES_TAG)
        return [_tees count];
    
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
            return course.name;
        }
    } else if (pickerView.tag == TEES_TAG) {
        
        if (row == 0) {
            return NO_TEES_LABEL;
        } else {
            return _tees[row];
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
    } else if (pickerView.tag == TEES_TAG) {
        
        if (row == 0) {
            self.selectedTees = nil;
        } else {
            self.selectedTees = _tees[row];
        }
    }
}

#pragma mark -
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"getHandicapsSegue" isEqualToString:segue.identifier]) {
        
        
        NSArray *arr = nil;
        NSPredicate *predicate = nil;
        
        if (self.selectedCourse) {
            if (self.selectedTees) {
                predicate = [NSPredicate predicateWithFormat:@"name == %@ and tees == %@", self.selectedCourse.name, self.selectedTees];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"name == %@", self.selectedCourse.name];
            }

            arr = [_allCourses filteredArrayUsingPredicate:predicate];
        }
        
        GHHandicapListViewController *controller = (GHHandicapListViewController*)segue.destinationViewController;
        controller.league = self.selectedLeague;
        controller.courses = arr;
        controller.tees = self.selectedTees;
        controller.useScoresFromSelectedLeagueOnly = self.scoresSwitch.on;
        controller.useScoresFromSelectedCourseOnly = self.scoresFromThisCourseSwitch.on;
    }
    
}


@end
