//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Adriana Jimenez Mangas on 5/18/15.
//  Copyright (c) 2015 Adriana Jimenez Mangas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *enterTaskTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;

@property NSMutableArray *tasks;
@property NSMutableArray *taskColors;

@property NSArray *priorityColors;
@property NSIndexPath *selectedCellPath;
@property BOOL isEditing;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray new];
    self.taskColors = [NSMutableArray new];

    for (int i = 0; i < 20; i++) {
        [self.tasks addObject:[NSString stringWithFormat:@"Task %d", i]];
        [self.taskColors addObject:[UIColor blackColor]];
    }

    self.isEditing = NO;

    [self.swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];


    self.priorityColors = @[[UIColor blackColor], [UIColor redColor], [UIColor yellowColor], [UIColor greenColor]];
}


- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)sender {
    CGPoint swipeLocation = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];


    UIColor *currentColor = cell.textLabel.textColor;
    NSUInteger currentColorIndex = [self.priorityColors indexOfObject:currentColor];

    UIColor *nextColor = [self.priorityColors objectAtIndex:(currentColorIndex + 1) % self.priorityColors.count];

    cell.textLabel.textColor = nextColor;

    [self.taskColors replaceObjectAtIndex:indexPath.row withObject:nextColor];
}


- (IBAction)onAddButtonPressed:(UIButton *)sender {

    [self.tasks addObject:self.enterTaskTextField.text];
    [self.taskColors addObject:[UIColor blackColor]];

    // clear text field, dismiss keyboards
    self.enterTaskTextField.text = @"";
    [self.view endEditing:YES];

    [self.tableView reloadData];
}


- (IBAction)onEditButtonPressed:(UIButton *)sender {

    [self.tableView setEditing:!self.isEditing animated:YES];

    if (!self.isEditing) {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }

    self.isEditing = !self.isEditing;
}


#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *task = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task;
    cell.textLabel.textColor = [self.taskColors objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - TableViewDelegate


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedCellPath = indexPath;

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete task?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        [alert show];
    }

    else {
        [self.tasks removeObjectAtIndex:indexPath.row];
        [self.taskColors removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }

}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSString *task = [self.tasks objectAtIndex:sourceIndexPath.row]; // grab task from tasks list
    [self.tasks removeObjectAtIndex:sourceIndexPath.row];            // remove task from current position
    [self.tasks insertObject:task atIndex:destinationIndexPath.row]; // reinsert task at new position

    UIColor *taskColor = [self.taskColors objectAtIndex:sourceIndexPath.row]; // grab task from tasks list
    [self.taskColors removeObjectAtIndex:sourceIndexPath.row];            // remove task from current position
    [self.taskColors insertObject:taskColor atIndex:destinationIndexPath.row]; // reinsert task at new position

}


#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.tasks removeObjectAtIndex:self.selectedCellPath.row];
        [self.taskColors removeObjectAtIndex:self.selectedCellPath.row];
        [self.tableView reloadData];
    }
}


@end























