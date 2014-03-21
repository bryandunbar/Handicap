#import "NSObject+AlertHelper.h"

@implementation NSObject (AlertHelper)

- (void)displayError:(NSString *) title error:(NSError *)e {
	[self displayError:title error:e tag:kAlertViewGenericError];
}
- (void)displayError:(NSString *) title error:(NSError *)e tag:(NSUInteger)tag{
    [self displayError:title error:e tag:tag otherButtonTitles:nil];
}
-(void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag otherButtonTitles:(NSArray *)otherButtonTitles {
    [self displayError:title error:e tag:tag cancelButtonTitle:@"OK" otherButtonTitles:otherButtonTitles];
}
-(void)displayError:(NSString *)title error:(NSError *)e tag:(NSUInteger)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
	NSString *detailMessage = [[NSString alloc]
							   initWithFormat:@"%@",
							   [e.userInfo valueForKey:NSLocalizedDescriptionKey]];
	
	if (!detailMessage && detailMessage != NULL) {
		detailMessage = [[NSString alloc]
						 initWithFormat:@"%@",
						 [e description]];
	}
	[self showAlert:title detailMessage:detailMessage tag:tag cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}	
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg {
	[self showAlert:title detailMessage:msg tag:kAlertViewGenericError];
}
- (void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag {
    [self showAlert:title detailMessage:msg tag:tag otherButtonTitles:nil];
}

-(void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag otherButtonTitles:(NSArray *)otherButtonTitles {
    [self showAlert:title detailMessage:msg tag:tag cancelButtonTitle:@"OK" otherButtonTitles:otherButtonTitles];
}

-(void)showAlert:(NSString *)title detailMessage:(NSString *)msg tag:(NSUInteger)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	alert.delegate = self;
	alert.tag = tag;
    
    for (NSString *buttonTitle in otherButtonTitles) {
        [alert addButtonWithTitle:buttonTitle];
    }
	[alert show];
}

@end
