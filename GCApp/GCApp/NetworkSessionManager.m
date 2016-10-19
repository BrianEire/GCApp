//
//  NetworkSessionManager.m
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "NetworkSessionManager.h"

static NSString *const kEventURL = @"http://shrouded-woodland-9458.herokuapp.com";

@implementation NetworkSessionManager

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kEventURL]];
    if(!self) return nil;
    
   self.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

+ (id)sharedManager {
    static NetworkSessionManager *_networkSessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkSessionManager = [[self alloc] init];
    });
    
    return _networkSessionManager;
}


@end
