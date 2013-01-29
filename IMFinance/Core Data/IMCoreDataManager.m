//
//  IMCoreDataManager.m
//  IMFinance
//
//  Created by Игорь Мищенко on 27.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMCoreDataManager.h"

#import <NSHash/NSString+NSHash.h>

#import "Account.h"
#import "Transaction.h"

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
    
    if (coredata_background_save_queue == NULL) {
        
        coredata_background_save_queue = dispatch_queue_create("com.magicalpanda.coredata.backgroundsaves", 0);
    }
    
    return coredata_background_save_queue;
}


#pragma mark -
#pragma mark Core Data - Accounts

static NSString *kAccountKey = @"account key";
static NSString *kAccountName = @"account name";
static NSString *kAccountValue = @"account value";
static NSString *kAcccountCurrency = @"account currency";

/* 
создание и сохранение нового счета с набором параметров
в фоне с параметрами в виде блоков
*/
- (void)editAccountInBackground:(NSDictionary *)parameters
                    withSuccess:(void (^)())successBlock
                        failure:(void (^)(NSError *))failureBlock {
    
    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            Account *account;
            
            NSString *key = [parameters valueForKey:kAccountKey];
            
            if (key && key.length) {
                account = [Account MR_findFirstByAttribute:@"key" withValue:key inContext:localContext];
            }
            else {
                account = [Account MR_createInContext:localContext];
                account.key = [[[NSDate date] description] MD5];
            }
            
            account.name = [parameters objectForKey:kAccountName];
            account.value = ([parameters objectForKey:kAccountValue]);
//            account.currency = [parameters objectForKey:kAcccountCurrency];
        }
                          completion:^(BOOL success, NSError *error){
                              (success) ? successBlock() : failureBlock(error);
                          }];
    });
}


#pragma mark -
#pragma mark Core Data - Transactions

static NSString *kTransactionKey = @"transaction key";
static NSString *kTransactionName = @"transaction name";
static NSString *kTransactionValue = @"transaction value";
static NSString *kTransactionCurrency = @"transaction currency";

/*
 создание и сохранение новой транзакции с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)addTransaction:(NSDictionary *)parameters
           withSuccess:(void (^)())successBlock
               failure:(void(^)())failureBlock {

    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            
            Transaction *transaction;
            
            NSString *key = [parameters valueForKey:kTransactionKey];
            
            if (key && key.length) {
                transaction = [Transaction MR_findFirstByAttribute:@"key" withValue:key inContext:localContext];
            }
            else {
                transaction = [Transaction MR_createInContext:localContext];
                transaction.key = [[[NSDate date] description] MD5];
            }
            
            Account *account = [Account MR_findFirstByAttribute:@"key"
                                                      withValue:[parameters valueForKey:kAccountKey]
                                                      inContext:localContext];
            
            transaction.name = [parameters objectForKey:kTransactionName];
            transaction.value = [parameters objectForKey:kTransactionValue];
            transaction.currency = [parameters objectForKey:kTransactionCurrency];
            transaction.account = account;
            
        }
                          completion:^(BOOL success, NSError *error){
                              (success) ? successBlock() : failureBlock(error);
                          }];
    });
}

@end
