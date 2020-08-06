//
//  ExpandDetailViewController.h
//  Aquarium
//
//  Created by Alec Vance on 11/18/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ExpandDetailViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSString *contentHTML;
	NSString *baseDir;
	UIView *titleBarBackgroundView;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *contentHTML;
@property (nonatomic, retain) NSString *baseDir;

- (void) setHTMLDir:(NSString *)htmlDir;

@end
