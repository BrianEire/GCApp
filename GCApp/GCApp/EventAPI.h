//
//  EventAPI.h
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "NetworkSessionManager.h"
#import "EventModel.h"

@interface EventAPI : NetworkSessionManager

- (NSURLSessionDataTask *)getEvents:(void (^)(NSArray *responseModel))success failure:(void (^)(NSError *error))failure;
- (NSURLSessionDataTask *)deleteEventWithEventID:(NSNumber*)eventID callbacks:(void (^)(BOOL response))success failure:(void (^)(NSError *error))failure;
- (NSURLSessionDataTask *)newEventWithDictionary:(NSMutableDictionary*)sender callbacks:(void (^)(BOOL response))success failure:(void (^)(NSError *error))failure;

@end
