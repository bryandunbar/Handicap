#import <Foundation/Foundation.h>


@interface NSString (Additions)

-(BOOL)isEqualToStringIgnoreCase:(NSString *)aString;
- (BOOL) empty;
- (NSString*)capitalizeFirstCharacter;
-(NSString*)lowercaseFirstCharacter;
+ (BOOL) isNilOrEmpty:(NSString *) s;
+ (NSString*) emptyIfNil:(NSString *)s;
+ (NSString*)stringWithDeviceToken:(NSData*)deviceToken;
-(BOOL)containsString:(NSString*)aString;

// Date Formatters
+ (NSString*)stringFromDate:(NSDate*)date;
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)stringFromDate:(NSDate*)date withDateStyle:(NSDateFormatterStyle)style;
+ (NSString*)stringFromDate:(NSDate*)date withTimeStyle:(NSDateFormatterStyle)style;
+ (NSString*)stringFromDate:(NSDate*)date withDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle;


// Other Formatters
+ (NSString*)stringAsPhoneNumber:(NSString*)string;

// Common String Validators
-(BOOL)isValidEmail;

// File Size Formatter
+ (NSString*)stringFromFileSize:(long)theSize;
@end
