// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contractor.m instead.

#import "_Contractor.h"

const struct ContractorAttributes ContractorAttributes = {
	.name = @"name",
};

const struct ContractorRelationships ContractorRelationships = {
	.transactions = @"transactions",
};

const struct ContractorFetchedProperties ContractorFetchedProperties = {
};

@implementation ContractorID
@end

@implementation _Contractor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Contractor" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Contractor";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Contractor" inManagedObjectContext:moc_];
}

- (ContractorID*)objectID {
	return (ContractorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic transactions;

	
- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];
  
	[self didAccessValueForKey:@"transactions"];
	return result;
}
	






@end
