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

static NSString *kAccountName = @"name";
static NSString *kAccountValue = @"value";
static NSString *kAcccountCurrency = @"currency";

/* 
создание и сохранение нового счета с набором параметров
в фоне с параметрами в виде блоков
*/
- (void)addAccountInBackground:(NSDictionary *)parameters
                   withSuccess:(void (^)())successBlock
                       failure:(void (^)(NSError *))failureBlock {
    
    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            Account *newAccount = [Account MR_createInContext:localContext];
            newAccount.key = [[[NSDate date] description] MD5];
            newAccount.name = [parameters objectForKey:kAccountName];
            newAccount.value = [parameters objectForKey:kAccountValue];
            newAccount.currency = [parameters objectForKey:kAcccountCurrency];
        }
                          completion:^(BOOL success, NSError *error){
                              (success) ? successBlock() : failureBlock(error);
                          }];
    });
}


#pragma mark -
#pragma mark Core Data - Transactions

static NSString *kTransactionName = @"name";
static NSString *kTransactionValue = @"value";
static NSString *kTransactionCurrency = @"currency";
static NSString *kTransactionAccountKey = @"account key";

/*
 создание и сохранение новой транзакции с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)addTransaction:(NSDictionary *)parameters
           withSuccess:(void (^)())successBlock
               failure:(void(^)())failureBlock {

    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            Account *account = [Account MR_findFirstByAttribute:@"key"
                                                      withValue:[parameters valueForKey:kTransactionAccountKey]
                                                      inContext:localContext];
            
            Transaction *newT = [Transaction MR_createInContext:localContext];
            newT.key = [[[NSDate date] description] MD5];
            newT.name = [parameters objectForKey:kTransactionName];
            newT.value = [parameters objectForKey:kTransactionValue];
            newT.currency = [parameters objectForKey:kTransactionCurrency];
            newT.account = account;
            
        }
                          completion:^(BOOL success, NSError *error){
                              (success) ? successBlock() : failureBlock(error);
                          }];
    });
}

@end
