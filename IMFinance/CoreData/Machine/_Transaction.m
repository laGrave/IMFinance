// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Transaction.m instead.

#import "_Transaction.h"

const struct TransactionAttributes TransactionAttributes = {
	.currency = @"currency",
	.endDate = @"endDate",
	.fee = @"fee",
	.hidden = @"hidden",
	.image = @"image",
	.incomeType = @"incomeType",
	.modDate = @"modDate",
	.name = @"name",
	.repeatInterval = @"repeatInterval",
	.startDate = @"startDate",
	.value = @"value",
};

const struct TransactionRelationships TransactionRelationships = {
	.account = @"account",
	.category = @"category",
	.contractor = @"contractor",
};

const struct TransactionFetchedProperties TransactionFetchedProperties = {
};

@implementation TransactionID
@end

@implementation _Transaction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Transaction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc_];
}

- (TransactionID*)objectID {
	return (TransactionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"feeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"incomeTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"incomeType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"repeatIntervalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"repeatInterval"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic currency;






@dynamic endDate;






@dynamic fee;



- (double)feeValue {
	NSNumber *result = [self fee];
	return [result doubleValue];
}

- (void)setFeeValue:(double)value_ {
	[self setFee:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveFeeValue {
	NSNumber *result = [self primitiveFee];
	return [result doubleValue];
}

- (void)setPrimitiveFeeValue:(double)value_ {
	[self setPrimitiveFee:[NSNumber numberWithDouble:value_]];
}





@dynamic hidden;



- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:[NSNumber numberWithBool:value_]];
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





@dynamic modDate;






@dynamic name;






@dynamic repeatInterval;



- (int16_t)repeatIntervalValue {
	NSNumber *result = [self repeatInterval];
	return [result shortValue];
}

- (void)setRepeatIntervalValue:(int16_t)value_ {
	[self setRepeatInterval:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRepeatIntervalValue {
	NSNumber *result = [self primitiveRepeatInterval];
	return [result shortValue];
}

- (void)setPrimitiveRepeatIntervalValue:(int16_t)value_ {
	[self setPrimitiveRepeatInterval:[NSNumber numberWithShort:value_]];
}





@dynamic startDate;






@dynamic value;



- (double)valueValue {
	NSNumber *result = [self value];
	return [result doubleValue];
}

- (void)setValueValue:(double)value_ {
	[self setValue:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result doubleValue];
}

- (void)setPrimitiveValueValue:(double)value_ {
	[self setPrimitiveValue:[NSNumber numberWithDouble:value_]];
}





@dynamic account;

	

@dynamic category;

	

@dynamic contractor;

	






@end
