// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Category.h instead.

#import <CoreData/CoreData.h>
#import "FTASyncParent.h"

extern const struct CategoryAttributes {
	__unsafe_unretained NSString *budget;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *incomeType;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *system;
} CategoryAttributes;

extern const struct CategoryRelationships {
	__unsafe_unretained NSString *parent;
	__unsafe_unretained NSString *subcategories;
	__unsafe_unretained NSString *transactions;
} CategoryRelationships;

extern const struct CategoryFetchedProperties {
} CategoryFetchedProperties;

@class Category;
@class Category;
@class Transaction;









@interface CategoryID : NSManagedObjectID {}
@end

@interface _Category : FTASyncParent {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CategoryID*)objectID;





@property (nonatomic, strong) NSNumber* budget;



@property double budgetValue;
- (double)budgetValue;
- (void)setBudgetValue:(double)value_;

//- (BOOL)validateBudget:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* incomeType;



@property BOOL incomeTypeValue;
- (BOOL)incomeTypeValue;
- (void)setIncomeTypeValue:(BOOL)value_;

//- (BOOL)validateIncomeType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* order;



@property int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* system;



@property BOOL systemValue;
- (BOOL)systemValue;
- (void)setSystemValue:(BOOL)value_;

//- (BOOL)validateSystem:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Category *parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *subcategories;

- (NSMutableSet*)subcategoriesSet;




@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;





@end

@interface _Category (CoreDataGeneratedAccessors)

- (void)addSubcategories:(NSSet*)value_;
- (void)removeSubcategories:(NSSet*)value_;
- (void)addSubcategoriesObject:(Category*)value_;
- (void)removeSubcategoriesObject:(Category*)value_;

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(Transaction*)value_;
- (void)removeTransactionsObject:(Transaction*)value_;

@end

@interface _Category (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBudget;
- (void)setPrimitiveBudget:(NSNumber*)value;

- (double)primitiveBudgetValue;
- (void)setPrimitiveBudgetValue:(double)value_;




- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;




- (NSNumber*)primitiveIncomeType;
- (void)setPrimitiveIncomeType:(NSNumber*)value;

- (BOOL)primitiveIncomeTypeValue;
- (void)setPrimitiveIncomeTypeValue:(BOOL)value_;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;




- (NSNumber*)primitiveSystem;
- (void)setPrimitiveSystem:(NSNumber*)value;

- (BOOL)primitiveSystemValue;
- (void)setPrimitiveSystemValue:(BOOL)value_;





- (Category*)primitiveParent;
- (void)setPrimitiveParent:(Category*)value;



- (NSMutableSet*)primitiveSubcategories;
- (void)setPrimitiveSubcategories:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;


@end
