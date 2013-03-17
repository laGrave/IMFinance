// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Category.m instead.

#import "_Category.h"

const struct CategoryAttributes CategoryAttributes = {
	.budget = @"budget",
	.image = @"image",
	.incomeType = @"incomeType",
	.key = @"key",
	.name = @"name",
	.order = @"order",
	.system = @"system",
};

const struct CategoryRelationships CategoryRelationships = {
	.parent = @"parent",
	.subcategories = @"subcategories",
	.transactions = @"transactions",
};

const struct CategoryFetchedProperties CategoryFetchedProperties = {
};

@implementation CategoryID
@end

@implementation _Category

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Category";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc_];
}

- (CategoryID*)objectID {
	return (CategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"budgetValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"budget"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"incomeTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"incomeType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"systemValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"system"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic budget;



- (double)budgetValue {
	NSNumber *result = [self budget];
	return [result doubleValue];
}

- (void)setBudgetValue:(double)value_ {
	[self setBudget:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveBudgetValue {
	NSNumber *result = [self primitiveBudget];
	return [result doubleValue];
}

- (void)setPrimitiveBudgetValue:(double)value_ {
	[self setPrimitiveBudget:[NSNumber numberWithDouble:value_]];
}





@dynamic image;






@dynamic incomeType;



- (BOOL)incomeTypeValue {
	NSNumber *result = [self incomeType];
	return [result boolValue];
}

- (void)setIncomeTypeValue:(BOOL)value_ {
	[self setIncomeType:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIncomeTypeValue {
	NSNumber *result = [self primitiveIncomeType];
	return [result boolValue];
}

- (void)setPrimitiveIncomeTypeValue:(BOOL)value_ {
	[self setPrimitiveIncomeType:[NSNumber numberWithBool:value_]];
}





@dynamic key;






@dynamic name;






@dynamic order;



- (int16_t)orderValue {
	NSNumber *result = [self order];
	return [result shortValue];
}

- (void)setOrderValue:(int16_t)value_ {
	[self setOrder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result shortValue];
}

- (void)setPrimitiveOrderValue:(int16_t)value_ {
	[self setPrimitiveOrder:[NSNumber numberWithShort:value_]];
}





@dynamic system;



- (BOOL)systemValue {
	NSNumber *result = [self system];
	return [result boolValue];
}

- (void)setSystemValue:(BOOL)value_ {
	[self setSystem:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSystemValue {
	NSNumber *result = [self primitiveSystem];
	return [result boolValue];
}

- (void)setPrimitiveSystemValue:(BOOL)value_ {
	[self setPrimitiveSystem:[NSNumber numberWithBool:value_]];
}





@dynamic parent;

	

@dynamic subcategories;

	
- (NSMutableSet*)subcategoriesSet {
	[self willAccessValueForKey:@"subcategories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"subcategories"];
  
	[self didAccessValueForKey:@"subcategories"];
	return result;
}
	

@dynamic transactions;

	
- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];
  
	[self didAccessValueForKey:@"transactions"];
	return result;
}
	






@end
