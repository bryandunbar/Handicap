//
//  GHCoursesViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHCoursesViewController.h"
#import "GHCourse.h"
#import "GHAddOrEditCourseViewController.h"
@interface GHCoursesViewController ()
@end

@implementation GHCoursesViewController

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHCourseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GHCourseCell"];
    }
    
    GHCourse *course = (GHCourse*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]", course.name, course.abbreviation];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Tees: %2.1f/%d", course.tees, [course.rating doubleValue], [course.slope integerValue]];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editCourseSegue" sender:self];
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
    return [GHCourse class];
}

#pragma mark -
#pragma mark Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"editCourseSegue" isEqualToString:segue.identifier]) {
        
        GHAddOrEditCourseViewController *controller = (GHAddOrEditCourseViewController*)segue.destinationViewController;
        
        GHCourse *selectedCourse =  (GHCourse*)[self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        controller.course = selectedCourse;
    }
}
@end
