//
//  iIndoorLocator.h
//  ibt_indoor
//
//  Created by Rafael.Wen on 15/9/15.
//  Copyright (c) 2015年 imapview. All rights reserved.
//

#ifndef ibt_indoor_iIndoorLocator_h
#define ibt_indoor_iIndoorLocator_h

#import <Foundation/Foundation.h>

@interface iIndoorLocator : NSObject

+ (void)fliterBeaconUUID:(NSArray*)beaconUUIDs;

@end

#endif