#import <Foundation/Foundation.h>

#define kAlertViewGenericError 424242

@interface NSObject (AlertHelper)

- (void)displayError:(NSString *)title error:(NSError *)e;
- (void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag;
- (void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag otherButtonTitles:(NSArray*)otherButtonTitles;
- (void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag otherButtonTitles:(NSArray*)otherButtonTitles;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;

@end
