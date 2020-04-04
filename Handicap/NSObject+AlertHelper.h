//
//  NSObject+AlertHelper.h
//  Handicap
//
//  Created by Dunbar, Bryan on 4/4/20.
//  Copyright © 2020 bdun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define kAlertViewGenericError 424242
@interface NSObject_AlertHelper : NSObject

- (void)displayError:(NSString *)title error:(NSError *)e;
- (void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag;
- (void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag otherButtonTitles:(NSArray*)otherButtonTitles;
- (void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag otherButtonTitles:(NSArray*)otherButtonTitles;
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;

@end

NS_ASSUME_NONNULL_END
