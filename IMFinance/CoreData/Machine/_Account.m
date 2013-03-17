// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Account.m instead.

#import "_Account.h"

const struct AccountAttributes AccountAttributes = {
	.currency = @"currency",
	.image = @"image",
	.limit = @"limit",
	.modDate = @"modDate",
	.name = @"name",
	.objectId = @"objectId",
	.startDate = @"startDate",
	.type = @"type",
};

const struct AccountRelationships AccountRelationships = {
	.transactions = @"transactions",
};

const struct AccountFetchedProperties AccountFetchedProperties = {
};

@implementation AccountID
@end

@implementation _Account

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Account";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Account" inManagedObjectContext:moc_];
}

- (AccountID*)objectID {
	return (AccountID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"limitValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"limit"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic currency;






@dynamic image;






@dynamic limit;



- (double)limitValue {
	NSNumber *result = [self limit];
	return [result doubleValue];
}

- (void)setLimitValue:(double)value_ {
	[self setLimit:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLimitValue {
	NSNumber *result = [self primitiveLimit];
	return [result doubleValue];
}

- (void)setPrimitiveLimitValue:(double)value_ {
	[self setPrimitiveLimit:[NSNumber numberWithDouble:value_]];
}





@dynamic modDate;






@dynamic name;






@dynamic objectId;






@dynamic startDate;






@dynamic type;



- (int16_t)typeValue {
	NSNumber *result = [self type];
	return [result shortValue];
}

- (void)setTypeValue:(int16_t)value_ {
	[self setType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTypeValue {
	NSNumber *result = [self primitiveType];
	return [result shortValue];
}

- (void)setPrimitiveTypeValue:(int16_t)value_ {
	[self setPrimitiveType:[NSNumber numberWithShort:value_]];
}





@dynamic transactions;

	
- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];
  
	[self didAccessValueForKey:@"transactions"];
	return result;
}
	






@end
