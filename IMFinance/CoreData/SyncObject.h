//
//  SyncObject.h
//  IMFinance
//
//  Created by Игорь Мищенко on 18.03.13.
//  Copyright (c) 2013 Igor Mishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SyncObject : NSManagedObject

@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSDate * last_modified;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSNumber * sync_status;

@end
