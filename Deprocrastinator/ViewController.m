//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Adriana Jimenez Mangas on 5/18/15.
//  Copyright (c) 2015 Adriana Jimenez Mangas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *enterTaskTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *tasks;
@property BOOL isEditing;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray arrayWithObjects:@"Task 1",  @"Task 2", @"Task 3", @"Task 4", nil];
    self.isEditing = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *task = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task;
    return cell;
}

- (IBAction)onAddButtonPressed:(UIButton *)sender {
    [self.tasks addObject:self.enterTaskTextField.text];
    self.enterTaskTextField.text = @"";
    [self.view endEditing:YES];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (IBAction)onEditButtonPressed:(UIButton *)sender {
    if (!self.isEditing) {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }
    self.isEditing = !self.isEditing;
}

@end























