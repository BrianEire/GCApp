//
//  EventAPI.m
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "EventAPI.h"
#import "Mantle.h"

static NSString *const kEventPath = @"/events";

@implementation EventAPI

- (NSURLSessionDataTask *)getEvents:(void (^)(NSArray *responseArrayOfEvents))success
                            failure:(void (^)(NSError *error))failure{
    return [self GET:kEventPath parameters:nil progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSArray *objectsArray = [MTLJSONAdapter modelsOfClass:EventModel.class fromJSONArray:(NSArray*)responseObject error:nil];
                 success(objectsArray);
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 failure(error);
             }];
}


- (NSURLSessionDataTask *)newEventWithDictionary:(NSMutableDictionary*)sender callbacks:(void (^)(BOOL response))success failure:(void (^)(NSError *error))failure{
    return [self POST:kEventPath
       parameters:sender progress:nil
          success:^(NSURLSessionDataTask *task, id responseObject){
         success(YES);
     }
          failure:^(NSURLSessionDataTask *task, NSError *error){
         failure(error);
     }];
}


- (NSURLSessionDataTask *)deleteEventWithEventID:(NSNumber*)eventID callbacks:(void (^)(BOOL response))success failure:(void (^)(NSError *error))failure{
    NSString * deletePath = [NSString stringWithFormat:@"%@/%@",kEventPath,eventID];
    return [self DELETE:deletePath
           parameters:nil
              success:^(NSURLSessionDataTask *task, id responseObject){
                success(YES);
            }
              failure:^(NSURLSessionDataTask *task, NSError *error){
                failure(error);
            }];
}

@end
