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
- (void)addAccountInBackground:(NSDictionary *)parameters
                   withSuccess:(void (^)())successBlock
                       failure:(void (^)(NSError *error))failureBlock;


/*
 создание и сохранение новой транзакции с набором параметров
 в фоне с параметрами в виде блоков
 */
- (void)addTransaction:(NSDictionary *)parameters
           withSuccess:(void (^)())successBlock
               failure:(void(^)())failureBlock;

@end
