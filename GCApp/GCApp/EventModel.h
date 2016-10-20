//
//  EventModel.h
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface EventModel : MTLModel <MTLJSONSerializing>


@property (nonatomic, copy) NSNumber *eventID;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSDate *eventStartDate;
@property (nonatomic, copy) NSDate *eventEndDate;
@property (nonatomic, copy) NSDate *eventUploadDate;
@property (nonatomic, copy) NSDate *eventModifiedDate;

@end
