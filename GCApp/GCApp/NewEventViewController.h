//
//  NewEventViewController.h
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEventViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventStartDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventEndDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic)  NSDate *eventStartDate;
@property (strong, nonatomic)  NSDate *eventEndDate;
@property (strong, nonatomic)  UIDatePicker *datePicker;
@property (strong, nonatomic)  NSDateFormatter *dateFormatter;
@property (strong, nonatomic)  NSDateFormatter *dateFormatterTwo;


- (IBAction)submitEvent;
@end
