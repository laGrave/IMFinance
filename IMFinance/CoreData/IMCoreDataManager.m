//
//  IMCoreDataManager.m
//  IMFinance
//
//  Created by Игорь Мищенко on 27.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMCoreDataManager.h"

#import <NSHash/NSString+NSHash.h>

#import "Account+Extensions.h"
#import "Transaction.h"
#import "Category.h"

#import "NSDate+Utilities.h"

static dispatch_queue_t coredata_background_save_queue;

@implementation IMCoreDataManager


#pragma mark -
#pragma mark Singleton methods

static IMCoreDataManager *sharedInstance = nil;

//  вызываем синглтон (thread safe)
+ (IMCoreDataManager *)sharedInstance {
    @synchronized (self){
        if (!sharedInstance) {
            sharedInstance = [[IMCoreDataManager alloc] init];
        }
        return sharedInstance;
    }
}


#pragma mark -
#pragma mark GCD

// отдельный поток для сохранения core data в фоне
- (dispatch_queue_t)background_save_queue {
    
    if (coredata_background_save_queue == NULL)
        coredata_background_save_queue = dispatch_queue_create("com.magicalpanda.coredata.backgroundsaves", 0);
    return coredata_background_save_queue;
}


#pragma mark -
#pragma mark - Sync

- (void)syncLocalObject:(SyncObject *)localObject withParseObject:(PFObject *)parseObject {
    
    __block SyncObject *object = nil;
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext){
        object = [localObject MR_inContext:localContext];
        
        NSDate *parseDate = parseObject.updatedAt;
        NSDate *localDate = object.last_modified;
        NSComparisonResult compareResult = [parseDate compare:localDate];
        NSLog(@"parse object date: %@", parseDate);
        NSLog(@"local object date: %@", localDate);
        NSLog(@"compare result %d", compareResult);
        if ((localDate && compareResult == NSOrderedDescending) || object.sync_status == [NSNumber numberWithInteger:2])
            [self syncObject:object andObject:parseObject forClass:[[object class] description]];
        else
            [self syncObject:parseObject andObject:object forClass:[[object class] description]];
        
    } completion:^(BOOL success, NSError *error){
        
            [parseObject saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                if (success)
                    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *context){
                        SyncObject *anObject = [object MR_inContext:context];
                        anObject.object_id = parseObject.objectId;
                        anObject.last_modified = parseObject.updatedAt;
                        anObject.sync_status = [NSNumber numberWithInteger:0];
                        if (anObject.is_deleted == [NSNumber numberWithInteger:1])
                            [anObject MR_deleteInContext:context];
                    }];
                else {
                    NSLog(@"error: %@", error.localizedDescription);
                    [parseObject saveEventually:^(BOOL success, NSError *error){
                        if (success)
                            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *context){
                                SyncObject *anObject = [object MR_inContext:context];
                                anObject.object_id = parseObject.objectId;
                                anObject.last_modified = parseObject.updatedAt;
                                anObject.sync_status = [NSNumber numberWithInteger:0];
                                if (anObject.is_deleted == [NSNumber numberWithInteger:1])
                                    [anObject MR_deleteInContext:context];
                            }];
                    }];
                }
            }];
    }];
}

- (void)syncLocalObject:(SyncObject *)localObject {
    
    SyncObject *object = [localObject MR_inThreadContext];
    PFObject *parseObject = nil;
    if (object.object_id && [object.object_id length]) {
        parseObject = [PFQuery getObjectOfClass:[[object class] description] objectId:object.object_id];
    }
    else
        parseObject = [PFObject objectWithClassName:[[object class] description]];
    
    NSLog(@"ppp object date: %@", parseObject.updatedAt);
    [self syncLocalObject:object withParseObject:parseObject];
}

- (void)syncObject:(id)obj1 andObject:(id)obj2 forClass:(NSString *)className {

    [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"name"];
    [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"is_deleted"];
    
    if ([className isEqualToString:@"Account"]) {
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"currency"];
//        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"iconName"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"type"];
    }
    if ([className isEqualToString:@"Category"]) {
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"iconName"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"incomeType"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"key"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"order"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"system"];
    }
    if ([className isEqualToString:@"Contractor"]) {
        //
    }
    if ([className isEqualToString:@"Transaction"]) {
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"currency"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"endDate"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"fee"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"hidden"];
//        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"iconName"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"incomeType"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"repeatInterval"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"startDate"];
        [self setAttributeToObject:obj1 fromObject:obj2 attributeKey:@"value"];
        [self setParentToObject:obj1 fromObject:obj2 parentKey:@"account"];
    }
    
}

- (void)setAttributeToObject:(id)obj1 fromObject:(id)obj2 attributeKey:(NSString *)key {

    id attribute = [obj2 valueForKey:key];
    if (attribute)
        [obj1 setValue:attribute forKey:key];
}


- (void)setParentToObject:(id)obj1 fromObject:(id)obj2 parentKey:(NSString *)key {

    if ([obj2 isMemberOfClass:[PFObject class]]) {
        PFObject *parent = [obj2 valueForKey:@"parent"];
        
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext){
        SyncObject *parentLocalObject = [SyncObject MR_findFirstByAttribute:@"object_id" withValue:parent.objectId inContext:localContext];
        if (parentLocalObject) {
            SyncObject *object1 = [obj1 MR_inContext:localContext];
            if (!object1) {
                Class class = NSClassFromString(parent.className);
                object1 = [class MR_createInContext:localContext];
            }
            [object1 setValue:parentLocalObject forKey:key];
        }
    }];
    }
    else {
        SyncObject *parent = [obj2 valueForKey:key];
        if (parent) {
            PFObject *parseObject = [PFQuery getObjectOfClass:[[parent class] description] objectId:parent.object_id];
            if (parseObject)
                [obj1 setValue:parseObject forKey:@"parent"];
        }
    }
}


- (void)accountSync {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDate *lastSyncDate = [[Account MR_findFirstOrderedByAttribute:@"last_modified" ascending:NO inContext:[NSManagedObjectContext MR_contextForCurrentThread]] last_modified];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Account"];
        if (lastSyncDate)
            [query whereKey:@"updatedAt" greaterThan:lastSyncDate];
        NSArray *accountsToSync = [query findObjects];
        for (PFObject *parseObject in accountsToSync) {
            __block Account *account = [Account MR_findFirstByAttribute:@"object_id" withValue:parseObject.objectId];
            if (!account) {
                [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext){
                    account = [Account MR_createInContext:localContext];
                    account.sync_status = [NSNumber numberWithInteger:2];
                }];
            }
            [self syncLocalObject:account withParseObject:parseObject];
        }
    });
}


- (void)transactionSync {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDate *lastSyncDate = [[Transaction MR_findFirstOrderedByAttribute:@"last_modified" ascending:NO inContext:[NSManagedObjectContext MR_contextForCurrentThread]] last_modified];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
        if (lastSyncDate)
            [query whereKey:@"updatedAt" greaterThan:lastSyncDate];
        NSArray *accountsToSync = [query findObjects];
        for (PFObject *parseObject in accountsToSync) {
            __block Transaction *trans = [Transaction MR_findFirstByAttribute:@"object_id" withValue:parseObject.objectId];
            if (!trans) {
                [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext){
                    trans = [Transaction MR_createInContext:localContext];
                    trans.sync_status = [NSNumber numberWithInteger:2];
                }];
            }
            [self syncLocalObject:trans withParseObject:parseObject];
        }
    });
}


#pragma mark -
#pragma mark - Delete objects

- (void)deleteObject:(SyncObject *)object {

    __block SyncObject *objectToClean = nil;
    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            objectToClean = [object MR_inContext:localContext];
            NSDictionary *keys = [[objectToClean entity] attributesByName];
            for (NSString *key in keys) {
                if (![key isEqualToString:@"object_id"] && ![key isEqualToString:@"last_modified"])
                    [objectToClean setValue:nil forKey:key];
            }
            objectToClean.is_deleted = [NSNumber numberWithInteger:1];
            objectToClean.sync_status = [NSNumber numberWithInteger:1];
        }
                          completion:^(BOOL success, NSError *error){
                              if (success) {
                                  if (objectToClean.object_id && [objectToClean.object_id length]) {
                                      PFObject *parseObject = [PFQuery getObjectOfClass:[[objectToClean class] description] objectId:objectToClean.object_id];
                                      [parseObject setValue:[NSNumber numberWithInteger:1] forKey:@"is_deleted"];
                                      [self syncLocalObject:objectToClean withParseObject:parseObject];
                                  }
                                  else NSLog(@"%@", error.localizedDescription);
                              }
                              else {
                                  NSLog(@"purge completed");
                              }
                          }];
    });
}


#pragma mark -
#pragma mark Core Data - Accounts

static NSString *kAccount = @"account";
static NSString *kAccountName = @"account name";
static NSString *kAccountInitialValue = @"account initial value";
static NSString *kAccountCurrency = @"account currency";
static NSString *kAccountType = @"account type";

/* 
создание и сохранение нового счета с набором параметров
в фоне с параметрами в виде блоков
*/
- (void)editAccountWithParams:(NSDictionary *)parameters
                      success:(void (^)())successBlock
                      failure:(void (^)(NSError *))failureBlock {
    
    dispatch_async([self background_save_queue], ^{
        
        __block Account *account = [parameters objectForKey:kAccount];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            if (account) {
                account = [account MR_inContext:localContext];
            }
            else {
                account = [Account MR_createInContext:localContext];
            }

            [parameters setValue:account forKey:kAccount];
            
            account.sync_status = [NSNumber numberWithInteger:1];
            
            account.name = [parameters objectForKey:kAccountName];
            account.currency = [parameters objectForKey:kAccountCurrency];
            account.type = [parameters objectForKey:kAccountType];
        }
                          completion:^(BOOL success, NSError *error){
                              if (success) {
                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                      [self syncLocalObject:[account MR_inThreadContext]];
                                  });
                                                                    
                                  [self correctTransaction:parameters success:^{
                                      //
                                  }]; 
                                  successBlock();
                              }
                              else {
                                  failureBlock(error);
                              }
                          }];
    });
}

- (void)correctTransaction:(NSDictionary *)parameters success:(void (^)())successBlock {

    NSNumber *initialValue = [parameters objectForKey:kAccountInitialValue];
    if (initialValue) {
        //скрытая транзакция для корректировки текущего значения счета
        Account *account = [[parameters objectForKey:kAccount] MR_inThreadContext];
        double dif = initialValue.doubleValue - account.value.doubleValue;
        if (dif != 0) {
            BOOL income = (dif > 0) ? YES : NO;
            NSMutableDictionary *transParams = [[NSMutableDictionary alloc] init];
            [transParams setValue:[NSNumber numberWithDouble:dif] forKey:kTransactionValue];
            [transParams setValue:[parameters objectForKey:kAccount] forKey:kAccount];
            [transParams setValue:[parameters objectForKey:kAccountCurrency] forKey:kTransactionCurrency];
            [transParams setValue:[NSNumber numberWithBool:income] forKey:kTransactionIncomeType];
            Category *category = [Category MR_findFirstByAttribute:@"system" withValue:[NSNumber numberWithBool:YES]];
            [transParams setValue:category forKey:kTransactionCategory];
            [transParams setValue:[NSDate date] forKey:kTransactionStartDate];
            
            if (account.transactions.count) {
                [transParams setValue:NSLocalizedString(@"Balance correction", NULL) forKey:kTransactionName];
                [transParams setValue:[NSNumber numberWithBool:NO] forKey:kTransactionHidden];
            }
            else {
                [transParams setValue:@"syscorrect" forKey:kTransactionName];
                [transParams setValue:[NSNumber numberWithBool:YES] forKey:kTransactionHidden];
            }
            
            [self editTransactionWithParams:transParams success:successBlock failure:nil];
        }
    }
}


#pragma mark -
#pragma mark Core Data - Transactions

static NSString *kTramsaction = @"transaction";
static NSString *kTransactionIncomeType = @"transaction income type";
static NSString *kTransactionName = @"transaction name";
static NSString *kTransactionValue = @"transaction value";
static NSString *kTransactionFee = @"transaction fee";
static NSString *kTransactionCurrency = @"transaction currency";
static NSString *kTransactionStartDate = @"transaction start date";
static NSString *kTransactionCategory = @"transaction category";
static NSString *kTransactionHidden = @"transaction hidden";

/*
 создание и сохранение новой транзакции с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)editTransactionWithParams:(NSDictionary *)parameters
                          success:(void (^)())successBlock
                          failure:(void (^)())failureBlock {
    
    dispatch_async([self background_save_queue], ^{
        
        __block Transaction *transaction = [parameters objectForKey:kTramsaction];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            
            if (transaction) {
                transaction = [transaction MR_inContext:localContext];
            }
            else {
                transaction = [Transaction MR_createInContext:localContext];
                transaction.startDate = [NSDate date];
            }
            
            transaction.sync_status = [NSNumber numberWithInteger:1];
            
            Account *account = [parameters objectForKey:kAccount];
            transaction.account = [account MR_inContext:localContext];
            
            NSString *name = [parameters objectForKey:kTransactionName];
            name = (name) ? name : @"";
            
            transaction.name = name;
            
            if ([parameters objectForKey:kTransactionIncomeType])
                transaction.incomeType = [parameters objectForKey:kTransactionIncomeType];
            
            if ([parameters objectForKey:kTransactionValue])
                transaction.value = [parameters objectForKey:kTransactionValue];
            
            if ([parameters objectForKey:kTransactionFee])
                transaction.fee = [parameters objectForKey:kTransactionFee];
            
            if ([parameters objectForKey:kTransactionCurrency])
                transaction.currency = [parameters objectForKey:kTransactionCurrency];
            
            if ([parameters objectForKey:kTransactionCategory]) {
                Category *category = [parameters objectForKey:kTransactionCategory];
                Category *categoryInLocalContext = [category MR_inContext:localContext];
                transaction.category = categoryInLocalContext;
            }
            
            if ([parameters objectForKey:kTransactionHidden])
                transaction.hidden = [parameters objectForKey:kTransactionHidden];
            
            
            NSDate *startDate = [parameters objectForKey:kTransactionStartDate];
            if (startDate) {
                transaction.startDate = [startDate dateWithOutTime];
            }
            
        }
                          completion:^(BOOL success, NSError *error){
                              if (success) {
                                  if (successBlock) {
                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                          [self syncLocalObject:[transaction MR_inThreadContext]];
                                      });
                                      successBlock();
                                  }
                              }
                              else if (failureBlock)
                                  failureBlock(error);
                          }];
    });
}


#pragma mark -
#pragma mark - Categories

static NSString *kCategory = @"category";
static NSString *kCategoryKey = @"category key";
static NSString *kCategoryName = @"categoryName";
static NSString *kCategoryOrder = @"categoryOrder";
static NSString *kCategoryIcon = @"categoryIconName";
static NSString *kCategoryIncomeType = @"categoryIncomeType";
static NSString *kCategorySystem = @"categorySystem";
//static NSString *kCategoryParent = @"categoryParent";

- (void)editCategoryWithParams:(NSDictionary *)parameters {

    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext){
        
            Category *category;
            
            if ([parameters objectForKey:kCategory]) {
                Category *c = [parameters objectForKey:kCategory];
                category = [c MR_inContext:localContext];
            }
            else {
                NSString *key = [parameters objectForKey:kCategoryKey];
                if (key && key.length) {
                    category = [Category MR_findFirstByAttribute:@"key" withValue:key inContext:localContext];
                }
                else {
                    category = [Category MR_createInContext:localContext];
                    category.key = [@"category" stringByAppendingString:[[[NSDate date] description] MD5]];
                }
            }
            
            if ([parameters objectForKey:kCategoryName])
                category.name = [parameters objectForKey:kCategoryName];
            
            NSNumber *incomeType;
            if ([parameters objectForKey:kCategoryIncomeType]) {
                incomeType = [parameters objectForKey:kCategoryIncomeType];
            }
            else incomeType = [NSNumber numberWithBool:NO];
            category.incomeType = incomeType;
            
            if ([parameters objectForKey:kCategoryOrder])
                category.order = [parameters objectForKey:kCategoryOrder];
            else {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(incomeType == %@) AND (system != %@)", incomeType, [NSNumber numberWithBool:YES]];
                NSInteger order = [[Category MR_numberOfEntitiesWithPredicate:predicate inContext:localContext] integerValue] - 1;
                NSNumber *orderNumber = [NSNumber numberWithInteger:order];
                category.order = orderNumber;
            }
            
            if ([parameters objectForKey:kCategorySystem]) {
                category.system = [parameters valueForKey:kCategorySystem];
            }
            else category.system = [NSNumber numberWithBool:NO];
        }];
    });

}


- (void)setupBaseCategories {
    
    
    //setup system category
    NSMutableDictionary *systemCategoryParams = [[NSMutableDictionary alloc] init];
    [systemCategoryParams setValue:@"sys" forKey:kCategoryName];
    [systemCategoryParams setValue:[NSNumber numberWithInteger:0] forKey:kCategoryOrder];
    [systemCategoryParams setValue:[NSNumber numberWithBool:YES] forKey:kCategorySystem];
    //income type
    [systemCategoryParams setValue:[NSNumber numberWithBool:YES] forKey:kCategoryIncomeType];
    [self editCategoryWithParams:systemCategoryParams];
    //outcome type
    [systemCategoryParams setValue:[NSNumber numberWithBool:NO] forKey:kCategoryIncomeType];
    [self editCategoryWithParams:systemCategoryParams];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BaseCategories" ofType:@"plist"];
    NSArray *allCategories = [NSArray arrayWithContentsOfFile:plistPath];
    
    for (NSDictionary *categoryParams in allCategories) {
        [self editCategoryWithParams:categoryParams];
    }
}

@end
