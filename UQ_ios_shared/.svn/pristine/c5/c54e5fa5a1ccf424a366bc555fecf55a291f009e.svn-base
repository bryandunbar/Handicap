
#import "NSString+Additions.h"


@implementation NSString (Additions)

-(BOOL)isEqualToStringIgnoreCase:(NSString *)aString {
    return ([self caseInsensitiveCompare:aString] == NSOrderedSame);
}
- (BOOL) empty{
	return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}
-(NSString*)capitalizeFirstCharacter {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}
-(NSString*)lowercaseFirstCharacter {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] lowercaseString]];
}

+(BOOL) isNilOrEmpty:(NSString *) s{
	return (s == nil || [s isEqual:[NSNull null]] || [s empty]);
}
+(NSString *)emptyIfNil:(NSString *) s {
	if (s == nil || [s isEqual:[NSNull null]]) {
		return @"";
	} else {
		return s;
	}

}

+ (NSString*)stringWithDeviceToken:(NSData*)deviceToken {
	const char* data = [deviceToken bytes];
	NSMutableString* token = [NSMutableString string];
	
	for (int i = 0; i < [deviceToken length]; i++) {
		[token appendFormat:@"%02.2hhX", data[i]];
	}
	
	return [token copy];
}

-(BOOL)containsString:(NSString *)aString {
    NSRange aRange = [self rangeOfString:aString];
    return aRange.location  != NSNotFound;
}

// Date Formatters
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format {
	if (date == nil) {
		return @"";
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

+ (NSString*)stringFromDate:(NSDate*)date {
	return [NSString stringFromDate:date withDateStyle:NSDateFormatterShortStyle andTimeStyle:NSDateFormatterShortStyle];
}
+ (NSString*)stringFromDate:(NSDate*)date withDateStyle:(NSDateFormatterStyle)style {
	return [NSString stringFromDate:date withDateStyle:style andTimeStyle:NSDateFormatterShortStyle];
	
}
+ (NSString*)stringFromDate:(NSDate*)date withTimeStyle:(NSDateFormatterStyle)style {
	return [NSString stringFromDate:date withDateStyle:NSDateFormatterShortStyle andTimeStyle:style];
	
}
+ (NSString*)stringFromDate:(NSDate*)date withDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle {
	if (date == nil) {
		return @"";
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:dateStyle];
	[formatter setTimeStyle:timeStyle];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

// Other formatter
+ (NSString*)stringAsPhoneNumber:(NSString*)string {
    if ([string length] != 10) {
        return string;
    }
    
    NSArray *stringComponents = [NSArray arrayWithObjects:[string substringWithRange:NSMakeRange(0, 3)],
                                 [string substringWithRange:NSMakeRange(3, 3)],
                                 [string  substringWithRange:NSMakeRange(6, [string length]-6)], nil];
    
    return [NSString stringWithFormat:@"(%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];

}

// Common Validators
-(BOOL)isValidEmail {
	
	if ([NSString isNilOrEmpty:self]) {
		return false;
	}

	NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";  
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
	return [emailTest evaluateWithObject:self];  
}

// File Size Formmatter
+ (NSString*)stringFromFileSize:(long)theSize {
	float floatSize = theSize;
	if (theSize < 0) {
		return @"";
	}
	if (theSize<1023)
		return([NSString stringWithFormat:@"%ld bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
	
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}
@end