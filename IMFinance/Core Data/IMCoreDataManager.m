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
#import "Category.h"

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
static NSString *kAccountInitialValue = @"account initial value";
static NSString *kAccountCurrency = @"account currency";

/* 
создание и сохранение нового счета с набором параметров
в фоне с параметрами в виде блоков
*/
- (void)editAccountWithParams:(NSDictionary *)parameters
                      success:(void (^)())successBlock
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
                account.key = [@"account" stringByAppendingString:[[[NSDate date] description] MD5]];
            }
            
            account.name = [parameters objectForKey:kAccountName];
            account.initialValue = ([parameters objectForKey:kAccountInitialValue]);
            account.currency = [parameters objectForKey:kAccountCurrency];
        }
                          completion:^(BOOL success, NSError *error){
                              (success) ? successBlock() : failureBlock(error);
                          }];
    });
}


#pragma mark -
#pragma mark Core Data - Transactions

static NSString *kTransactionKey = @"transaction key";
static NSString *kTransactionIncomeType = @"transaction income type";
static NSString *kTransactionName = @"transaction name";
static NSString *kTransactionValue = @"transaction value";
static NSString *kTransactionCurrency = @"transaction currency";
static NSString *kTransactionStartDate = @"transaction start date";

/*
 создание и сохранение новой транзакции с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)editTransactionWithParams:(NSDictionary *)parameters
                          success:(void (^)())successBlock
                          failure:(void (^)())failureBlock {
    
    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            
            Transaction *transaction;
            
            NSString *key = [parameters valueForKey:kTransactionKey];
            
            if (key && key.length) {
                transaction = [Transaction MR_findFirstByAttribute:@"key" withValue:key inContext:localContext];
            }
            else {
                transaction = [Transaction MR_createInContext:localContext];
                transaction.key = [@"transaction" stringByAppendingString:[[[NSDate date] description] MD5]];
            
                transaction.startDate = [NSDate date];
            }
            
            Account *account = [Account MR_findFirstByAttribute:@"key"
                                                      withValue:[parameters valueForKey:kAccountKey]
                                                      inContext:localContext];
            
            NSString *name = [parameters objectForKey:kTransactionName];
            name = (name) ? name : @"";
            
            transaction.name = name;
            transaction.incomeType = [parameters objectForKey:kTransactionIncomeType];
            transaction.value = [parameters objectForKey:kTransactionValue];
            transaction.currency = [parameters objectForKey:kTransactionCurrency];
            transaction.account = account;
            
            NSDate *startDate = [parameters objectForKey:kTransactionStartDate];
            if (startDate) transaction.startDate = startDate;
            
        }
                          completion:^(BOOL success, NSError *error){
                              (success) ? successBlock() : failureBlock(error);
                          }];
    });
}


static NSString *kCategoryKey = @"category key";
static NSString *kCategoryName = @"categoryName";
static NSString *kCategoryOrder = @"categoryOrder";
static NSString *kCategoryIcon = @"categoryIconName";
static NSString *kCategoryIncomeType = @"categoryIncomeType";
//static NSString *kCategoryParent = @"categoryParent";

- (void)editCategoryWithParams:(NSDictionary *)parameters {

    dispatch_async([self background_save_queue], ^{
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext){
        
            Category *category;
            
            NSString *key = [parameters objectForKey:kCategoryKey];
            if (key && key.length) {
                category = [Category MR_findFirstByAttribute:@"key" withValue:key];
            }
            else {
                category = [Category MR_createInContext:localContext];
                category.key = [@"category" stringByAppendingString:[[[NSDate date] description] MD5]];
            }
            
            if ([parameters objectForKey:kCategoryName])
                category.name = [parameters objectForKey:kCategoryName];
            if ([parameters objectForKey:kCategoryOrder])
                category.order = [parameters objectForKey:kCategoryOrder];
            if ([parameters objectForKey:kCategoryIcon])
                category.image = UIImagePNGRepresentation([UIImage imageNamed:[parameters objectForKey:kCategoryIcon]]);
            if ([parameters objectForKey:kCategoryIncomeType]) {
                category.incomeType = [parameters objectForKey:kCategoryIncomeType];
            }
        }];
    });

}


- (void)setupBaseCategories {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BaseCategories" ofType:@"plist"];
    NSArray *categories = [NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary *categoryParams in categories) {
        [self setCategoryWithParameters:categoryParams];
    }
}


- (void)setCategoryWithParameters:(NSDictionary *)categoryDict {
    
    static int order = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:categoryDict];
    [params setValue:[NSNumber numberWithInt:order] forKey:kCategoryOrder];
    [self editCategoryWithParams:params];
    order++;
    NSArray *values = [categoryDict allValues];
    for (id value in values) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self setCategoryWithParameters:value];
        }
    }
}

@end
