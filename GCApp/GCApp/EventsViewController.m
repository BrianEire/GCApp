//
//  EventsViewController.m
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "EventsViewController.h"
#import "EventAPI.h"
#import "EventModel.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.eventTableView.allowsMultipleSelectionDuringEditing = NO;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    self.dateFormatter.dateFormat = @"E, d MMM, yyyy HH:MM";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(downloadTableData) forControlEvents:UIControlEventValueChanged];
    [self.eventTableView setRefreshControl:self.refreshControl];

}


-(void) viewWillAppear:(BOOL)animated{
    [self downloadTableData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.eventObjectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    EventModel * EM = [self.eventObjectArray objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = EM.eventName;
    
    UILabel *startDateLabel = (UILabel *)[cell viewWithTag:2];
    startDateLabel.text = [self.dateFormatter stringFromDate:EM.eventStartDate];
    
    UILabel *endDateLabel = (UILabel *)[cell viewWithTag:3];
    endDateLabel.text = [self.dateFormatter stringFromDate:EM.eventEndDate];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 100;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            EventModel * EM = [self.eventObjectArray objectAtIndex:indexPath.row];
            [self deleteEvent: EM.eventID atIndexPath:indexPath];
        }
    }
}


-(NSMutableArray*) sortedArray:(NSArray *)unsortedArray{
    NSArray *sortedArray = [unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id date1, id date2) {
        NSDate *firstDate = [(EventModel*)date1 eventStartDate];
        NSDate *secondDate = [(EventModel*)date2 eventStartDate];
        return [firstDate compare:secondDate];
         }];
    return [NSMutableArray arrayWithArray:sortedArray];
}


#pragma mark - Error Alert Method
-(void) showAlertWithError:(NSError*)error{
    UIAlertController * alertController = [UIAlertController
                                 alertControllerWithTitle:[error localizedDescription]
                                 message:[error localizedFailureReason]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - API Methods
-(void) deleteEvent:(NSNumber*)eventID atIndexPath:(NSIndexPath *)indexPath{
    [[EventAPI sharedManager] deleteEventWithEventID:eventID callbacks:^(BOOL responseModel) {
        
        [self.eventObjectArray removeObjectAtIndex:indexPath.row];
        [self.eventTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error){
        [self showAlertWithError: error];
    }];
}


-(void) downloadTableData{
    [[EventAPI sharedManager] getEvents:^(NSArray *responseModel) {
        
        self.eventObjectArray = [self sortedArray:responseModel];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        [self.eventTableView reloadData];
        
    } failure:^(NSError *error){
        [self showAlertWithError: error];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}


@end
