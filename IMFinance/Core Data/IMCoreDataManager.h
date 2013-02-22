//
//  IMCoreDataManager.h
//  IMFinance
//
//  Created by Игорь Мищенко on 27.01.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMCoreDataManager : NSObject

// создание синглтона
+ (IMCoreDataManager *)sharedInstance;

// отдельный поток для сохранения core data в фоне
- (dispatch_queue_t)background_save_queue;


/*
 создание и сохранение нового счета с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)editAccountWithParams:(NSDictionary *)parameters
                      success:(void (^)())successBlock
                      failure:(void (^)(NSError *error))failureBlock;


/*
 создание и сохранение новой транзакции с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)editTransactionWithParams:(NSDictionary *)parameters
                          success:(void (^)())successBlock
                          failure:(void(^)())failureBlock;


/*
 создание и сохранение новой категории с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)editTransactionWithParams:(NSDictionary *)parameters;
- (void)setupBaseCategories; //занесение в базу стандартных категорий

@end
