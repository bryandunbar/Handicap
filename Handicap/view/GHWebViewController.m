//
//  GHWebViewController.m
//  Handicap
//
//  Created by Bryan Dunbar on 7/10/14.
//  Copyright (c) 2014 bdun. All rights reserved.
//

#import "GHWebViewController.h"
#import "GHHandicapCalculator.h"
#import "GHPrintFormmater.h"

@interface GHWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GHWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.scalesPageToFit = YES;
    [self.webView loadHTMLString:self.printFormmatter.markupText baseURL:nil];
}
- (IBAction)printTapped:(id)sender {
    [self print];
}

-(void)print {
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    pc.printFormatter = self.printFormmatter;
    printInfo.jobName = @"Handicap Cards";
    pc.printInfo = printInfo;
    //pc.showsPageRange = YES;
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                  error.code);
        }
    };
    
    [pc presentAnimated:YES completionHandler:completionHandler];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
