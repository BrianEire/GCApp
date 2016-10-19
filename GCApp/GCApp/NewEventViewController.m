//
//  NewEventViewController.m
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "NewEventViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "EventAPI.h"
#import "EventModel.h"
#import "UIView+Toast.h"


@interface NewEventViewController ()

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar * keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] ;
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
    
    [keyboardToolbar setItems:itemsArray];
    
    self.eventStartDateTextField.inputView = self.datePicker;
    self.eventStartDateTextField.inputAccessoryView = keyboardToolbar;
    
    self.eventEndDateTextField.inputView = self.datePicker;
    self.eventEndDateTextField.inputAccessoryView = keyboardToolbar;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    self.dateFormatter.dateFormat = @"E, d MMM yyyy";
    
    self.dateFormatterTwo = [[NSDateFormatter alloc] init];
    self.dateFormatterTwo.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [self.dateFormatterTwo setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    self.dateFormatterTwo.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return textView.text.length + (text.length - range.length) <= 100;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}


- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker{

    if ([self.eventStartDateTextField isFirstResponder]){
        self.eventStartDateTextField.text = [self.dateFormatter stringFromDate:datePicker.date];
        self.eventStartDate = [self.datePicker date];
    }
    else if ([self.eventEndDateTextField isFirstResponder]){
        self.eventEndDateTextField.text = [self.dateFormatter stringFromDate:datePicker.date];
        self.eventEndDate = [self.datePicker date];
    }
}


-(void) hideKeyboard{
    if ([self.eventStartDateTextField isFirstResponder]){
        [self.eventStartDateTextField resignFirstResponder];
    }
    else if ([self.eventEndDateTextField isFirstResponder]){
        [self.eventEndDateTextField resignFirstResponder];
    }
    else if ([self.eventNameTextField isFirstResponder]){
        [self.eventNameTextField resignFirstResponder];
    }
}


-(IBAction) submitEvent
{
    [self hideKeyboard];
    if ([self checkForValidEventInputs]){
   
        NSMutableDictionary *newEventDictionary = [[NSMutableDictionary alloc] init];
        [newEventDictionary setObject:self.eventNameTextField.text forKey:@"event[name]"];
        [newEventDictionary setObject:[self.dateFormatterTwo stringFromDate:self.eventStartDate] forKey:@"event[start]"];
        [newEventDictionary setObject:[self.dateFormatterTwo stringFromDate:self.eventEndDate] forKey:@"event[end]"];
    
        [[EventAPI sharedManager] newEventWithDictionary:newEventDictionary callbacks:^(BOOL responseModel) {
        
            [self clearTextFields];
            [self showToast:@"Success" andBody:@"The Event has been created successfully."];
            
        } failure:^(NSError *error){
         [self showAlertWithError:error];
         }];
    }
}

-(void) clearTextFields{
    self.eventNameTextField.text = @"";
    self.eventStartDateTextField.text = @"";
    self.eventEndDateTextField.text = @"";
}


-(void) showAlertWithError:(NSError*)error{
    UIAlertController * alertController = [UIAlertController
                                           alertControllerWithTitle:[error localizedDescription]
                                           message:[error localizedFailureReason]
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(BOOL) checkForValidEventInputs{
    if (self.eventStartDate && self.eventEndDate && ([[self.eventNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0)){
        if([self.eventStartDate compare:self.eventEndDate] == NSOrderedAscending){
            return YES;
        }
        else{
            [self showToast:@"Invalid Dates" andBody:@"The event 'End Date' must not be befoe the 'Start Date'."];
        }
    }
    else{
        [self showToast:@"Invalid Data" andBody:@"Please enter data in all 3 fields."];
    }
    return NO;
}


-(void) showToast:(NSString*)toastTitle andBody:(NSString*)toastMessage{
    [self.view makeToast:toastMessage
                duration:3.0
                position:CSToastPositionCenter
                   title:toastTitle
                   image:nil
                   style:nil
              completion:^(BOOL didTap) {
              }];
}


@end
