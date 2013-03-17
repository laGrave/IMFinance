// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contractor.h instead.

#import <CoreData/CoreData.h>


extern const struct ContractorAttributes {
	__unsafe_unretained NSString *name;
} ContractorAttributes;

extern const struct ContractorRelationships {
	__unsafe_unretained NSString *transactions;
} ContractorRelationships;

extern const struct ContractorFetchedProperties {
} ContractorFetchedProperties;

@class Transaction;



@interface ContractorID : NSManagedObjectID {}
@end

@interface _Contractor : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ContractorID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;





@end

@interface _Contractor (CoreDataGeneratedAccessors)

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(Transaction*)value_;
- (void)removeTransactionsObject:(Transaction*)value_;

@end

@interface _Contractor (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;


@end
