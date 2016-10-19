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
    self.dateFormatter.dateFormat = @"E, d MMM yyyy";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(loadTableData) forControlEvents:UIControlEventValueChanged];
    [self.eventTableView setRefreshControl:self.refreshControl];

}


-(void) viewWillAppear:(BOOL)animated
{
    [self loadTableData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventObjectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    EventModel * EM = [self.eventObjectArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 30)];
        nameLabel.text = EM.eventName;
        nameLabel.textColor = [UIColor blueColor];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        nameLabel.tag = 10;
        [cell.contentView addSubview: nameLabel];
        
        UILabel * startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 280, 20)];
        startDateLabel.text = [self.dateFormatter stringFromDate:EM.eventStartDate];
        [startDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        startDateLabel.tag = 11;
        startDateLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview: startDateLabel];
        
        UILabel * endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 280, 30)];
        endDateLabel.text = [self.dateFormatter stringFromDate:EM.eventEndDate];
        [endDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        endDateLabel.tag = 12;
        endDateLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview: endDateLabel];
        
    }
    else
    {
        for (UILabel* view in [cell.contentView subviews])
        {
            if (view.tag == 10)
            {
                view.text = EM.eventName;
            }
            else if (view.tag == 11)
            {
                view.text = [self.dateFormatter stringFromDate:EM.eventStartDate];
            }
            else if (view.tag == 12)
            {
                view.text = [self.dateFormatter stringFromDate:EM.eventEndDate];
            }
        }
        
    }
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


-(void) loadTableData
{
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


-(NSMutableArray*) sortedArray:(NSArray *)unsortedArray
{
    NSArray *sortedArray = [unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id date1, id date2) {
        NSDate *firstDate = [(EventModel*)date1 eventStartDate];
        NSDate *secondDate = [(EventModel*)date2 eventStartDate];
        return [firstDate compare:secondDate];
         }];
    return [NSMutableArray arrayWithArray:sortedArray];
}


-(void) deleteEvent:(NSNumber*)eventID atIndexPath:(NSIndexPath *)indexPath
{
    [[EventAPI sharedManager] deleteEventWithEventID:eventID callbacks:^(BOOL responseModel) {
        
        [self.eventObjectArray removeObjectAtIndex:indexPath.row];
        [self.eventTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error){
         [self showAlertWithError: error];
     }];
}


-(void) showAlertWithError:(NSError*)error
{
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


@end
