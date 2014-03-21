//
//  NSDate+PrettyPrint.m
//
//  Created by Bryan Dunbar on 2/23/12.
//

#import "NSDate+PrettyPrint.h"
#import "NSDate+Additions.h"

@implementation NSDate (PrettyPrint)


-(NSString*)formattedDateRelativeToNow {

    NSString *time = [self formattedStringUsingFormat:@"h:mm a"];
    NSString *dayOfWeek = [self formattedStringUsingFormat:@"cccc"];
    
    int delta = -(int)[self timeIntervalSinceNow];
    
    if (delta < 60)
        return @"Just Now";
    if (delta < 120)
        return @"One Minute Ago";
    if (delta < 2700)
        return [NSString stringWithFormat:@"%i Minutes Ago", delta/60];
    if (delta < 5400)
        return @"An Hour Ago";
    if (delta < 24 * 3600)
        return [NSString stringWithFormat:@"%i Hours Ago", delta/3600];
    if (delta < 48 * 3600)
        return [NSString stringWithFormat:@"Yesterday at %@", time];
    if (delta < 30 * 7 * 3600) {
        return [NSString stringWithFormat:@"%@ at %@", dayOfWeek, time];
    }
    
    // Default
    return [self formattedStringUsingFormat:@"MMM d' at 'h:mm a"];
}

@end
