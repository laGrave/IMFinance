// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Account.h instead.

#import <CoreData/CoreData.h>


extern const struct AccountAttributes {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *limit;
	__unsafe_unretained NSString *modDate;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *type;
} AccountAttributes;

extern const struct AccountRelationships {
	__unsafe_unretained NSString *transactions;
} AccountRelationships;

extern const struct AccountFetchedProperties {
} AccountFetchedProperties;

@class Transaction;









@interface AccountID : NSManagedObjectID {}
@end

@interface _Account : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AccountID*)objectID;





@property (nonatomic, strong) NSString* currency;



//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* limit;



@property double limitValue;
- (double)limitValue;
- (void)setLimitValue:(double)value_;

//- (BOOL)validateLimit:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* modDate;



//- (BOOL)validateModDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* type;



@property int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;





@end

@interface _Account (CoreDataGeneratedAccessors)

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(Transaction*)value_;
- (void)removeTransactionsObject:(Transaction*)value_;

@end

@interface _Account (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;




- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;




- (NSNumber*)primitiveLimit;
- (void)setPrimitiveLimit:(NSNumber*)value;

- (double)primitiveLimitValue;
- (void)setPrimitiveLimitValue:(double)value_;




- (NSDate*)primitiveModDate;
- (void)setPrimitiveModDate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int16_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int16_t)value_;





- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;


@end
