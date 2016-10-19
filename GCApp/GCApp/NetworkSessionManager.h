//
//  NetworkSessionManager.h
//  GCApp
//
//  Created by BD on 18/10/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NetworkSessionManager : AFHTTPSessionManager

+ (id)sharedManager;

@end
