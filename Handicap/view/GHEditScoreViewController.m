//
//  GHEditScoreViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHEditScoreViewController.h"
#import "BDPickerField.h"
#import "UQDateField2.h"
#import "GHLeague.h"
#import "GHCourse.h"

#define LEAGUE_TAG      1002
#define COURSE_TAG      1003

@interface GHEditScoreViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UQDateFieldDelegate> {
    NSArray *_leagues;
    NSArray *_courses;
}
@property (weak, nonatomic) IBOutlet BDPickerField *leaguePicker;

@property (weak, nonatomic) IBOutlet BDPickerField *coursePicker;
@property (weak, nonatomic) IBOutlet UQDateField2 *dateField;
@property (weak, nonatomic) IBOutlet UITextField *scoreValue;

@end

@implementation GHEditScoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.coursePicker.picker.dataSource = self;
    self.coursePicker.picker.tag = COURSE_TAG;
    self.coursePicker.picker.delegate = self;

    self.leaguePicker.picker.delegate = self;
    self.leaguePicker.picker.dataSource = self;
    self.leaguePicker.picker.tag = LEAGUE_TAG;

    self.dateField.dateFieldDelegate = self;
    self.dateField.dateMode = UIDatePickerModeDate;
    self.dateField.dateStyle = NSDateFormatterShortStyle;
    self.dateField.timeStyle = NSDateFormatterNoStyle;

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self getData];
    [self configureView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)configureView {
    self.coursePicker.text = [self.score.course description];
    self.leaguePicker.text = self.score.league.name;
    self.scoreValue.text = [NSString stringWithFormat:@"%d", [self.score.value intValue]];
    [self.dateField setSelectedDate:self.score.date];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.score) {
        
        int scoreValue = [self.scoreValue.text intValue];
        [self.score changeScoreValue:@(scoreValue)];

        // Other fields are set via the pickers directly
        [self.score save];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark - Get Data
-(void)getData {
    
    [self getLeaguesWithBlock:^(NSArray *leagues) {
        _leagues = leagues;
        [self.leaguePicker setSelectedRow:[_leagues indexOfObject:self.score.league] inComponent:0 animated:NO];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self getCoursesWithBlock:^(NSArray *courses) {
        _courses = courses;
        [self.coursePicker setSelectedRow:[_courses indexOfObject:self.score.course] inComponent:0 animated:NO];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}
-(void)getLeaguesWithBlock:(void (^)(NSArray *))block  {
    
    NSManagedObjectContext *context = [GHLeague mainQueueContext];
    [context performBlock:^{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [GHLeague entityWithContext:context];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"players contains %@", self.score.player];
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
        GHCourse *course = _courses[row];
        return [course description];
    }
    
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == LEAGUE_TAG) {
        self.score.league = _leagues[row];
        self.leaguePicker.text = self.score.league.name;
    } else if (pickerView.tag == COURSE_TAG) {
        self.score.course = _courses[row];
        self.coursePicker.text = [self.score.course description];
    }
}

#pragma  mark -
#pragma mark DateFieldDelegate
-(void)dateChanged:(UQDateField2 *)dateField {
    self.score.date = dateField.picker.date;
}


@end
