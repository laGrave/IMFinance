// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Transaction.h instead.

#import <CoreData/CoreData.h>
#import "FTASyncParent.h"

extern const struct TransactionAttributes {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *fee;
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *incomeType;
	__unsafe_unretained NSString *modDate;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *repeatInterval;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *value;
} TransactionAttributes;

extern const struct TransactionRelationships {
	__unsafe_unretained NSString *account;
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *contractor;
} TransactionRelationships;

extern const struct TransactionFetchedProperties {
} TransactionFetchedProperties;

@class Account;
@class Category;
@class Contractor;













@interface TransactionID : NSManagedObjectID {}
@end

@interface _Transaction : FTASyncParent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TransactionID*)objectID;





@property (nonatomic, strong) NSString* currency;



//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fee;



@property double feeValue;
- (double)feeValue;
- (void)setFeeValue:(double)value_;

//- (BOOL)validateFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* hidden;



@property BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* incomeType;



@property BOOL incomeTypeValue;
- (BOOL)incomeTypeValue;
- (void)setIncomeTypeValue:(BOOL)value_;

//- (BOOL)validateIncomeType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* modDate;



//- (BOOL)validateModDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* repeatInterval;



@property int16_t repeatIntervalValue;
- (int16_t)repeatIntervalValue;
- (void)setRepeatIntervalValue:(int16_t)value_;

//- (BOOL)validateRepeatInterval:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* value;



@property double valueValue;
- (double)valueValue;
- (void)setValueValue:(double)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Account *account;

//- (BOOL)validateAccount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Category *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Contractor *contractor;

//- (BOOL)validateContractor:(id*)value_ error:(NSError**)error_;





@end

@interface _Transaction (CoreDataGeneratedAccessors)

@end

@interface _Transaction (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSNumber*)primitiveFee;
- (void)setPrimitiveFee:(NSNumber*)value;

- (double)primitiveFeeValue;
- (void)setPrimitiveFeeValue:(double)value_;




- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;




- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;




- (NSNumber*)primitiveIncomeType;
- (void)setPrimitiveIncomeType:(NSNumber*)value;

- (BOOL)primitiveIncomeTypeValue;
- (void)setPrimitiveIncomeTypeValue:(BOOL)value_;




- (NSDate*)primitiveModDate;
- (void)setPrimitiveModDate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveRepeatInterval;
- (void)setPrimitiveRepeatInterval:(NSNumber*)value;

- (int16_t)primitiveRepeatIntervalValue;
- (void)setPrimitiveRepeatIntervalValue:(int16_t)value_;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (double)primitiveValueValue;
- (void)setPrimitiveValueValue:(double)value_;





- (Account*)primitiveAccount;
- (void)setPrimitiveAccount:(Account*)value;



- (Category*)primitiveCategory;
- (void)setPrimitiveCategory:(Category*)value;



- (Contractor*)primitiveContractor;
- (void)setPrimitiveContractor:(Contractor*)value;


@end
