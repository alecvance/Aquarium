//
//  WebViewController.h
//  radioBPR
//
//  Created by Alec Vance on 4/5/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>



@interface WebViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	NSURL *currentURL;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *currentURL;

-(IBAction) done;
-(IBAction)dialogActionSheet;
- (id)initWithURL:(NSURL *)theURL; // designated initializer
-(void)loadURL: (NSURL *)url;
-(void) openInSafari;

@end
