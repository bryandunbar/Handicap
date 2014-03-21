#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+(NSDate *)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat;
+(NSDate *)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat andTimezone:(NSTimeZone*)timeZone;

+(NSDate *)dateFromISO8601String:(NSString*)dateString;
+(NSDate *)dateWithoutTime;
+(NSString *)formatTimeInterval:(NSTimeInterval)timeInterval;
+(NSString *)formatTimeIntervalLong:(NSTimeInterval)timeInterval;

-(NSDate *)dateByAddingDays:(NSInteger)numDays;
-(NSDate *)dateAsDateWithoutTime;
-(int)differenceInDaysTo:(NSDate *)toDate;
-(NSString *)formattedDateString;
-(NSString *)formattedDateStringInTimezone:(NSTimeZone*)timeZone;
-(NSString *)formattedStringUsingFormat:(NSString *)dateFormat;
-(NSString *)formattedStringUsingFormat:(NSString *)dateFormat inTimeZone:(NSTimeZone*)timeZone;
-(NSString *)ISO8601FormattedString;
-(NSString *)ISO8601FormattedStringWithTimezone:(NSTimeZone*)timeZone;

-(BOOL)isToday;

+(NSDate*)dateByRoundingToNearestMinutes:(int)minuteInterval;

@end
