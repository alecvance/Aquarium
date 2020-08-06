#import <UIKit/UIKit.h>
#import <Foundation/NSNetServices.h>
#import "BDConnect.h"

//scott:: file had a bad inlcude here that chould have actually been the class line below
//@class BDConnect;
@class AquariumAppDelegate;

@protocol BrowserViewControllerDelegate<NSObject>
@optional
-(void)signInCompleteWithConnection:(BDConnect *)bdconnection;
@end


//scott::  added the BDConnectDelegate
@interface BrowserViewController : UITableViewController <UITableViewDelegate, BDConnectDelegate,
NSNetServiceBrowserDelegate, NSNetServiceDelegate> {

	id <BrowserViewControllerDelegate> delegate;
	BDConnect *bdconnection;
	
@private
	NSMutableArray *_services;
	NSNetServiceBrowser *_netServiceBrowser;
    NSIndexPath *_currentSelection;
	NSNetService *_currentResolve;
	NSTimer *_timer;
    UITableViewCell *_cellOfCurrentResolve;
	NSString *xmlCallback;
	AquariumAppDelegate *appDelegate;
}

@property (nonatomic, retain) id <BrowserViewControllerDelegate> delegate;
@property (nonatomic, retain) BDConnect *bdconnection;
@property (nonatomic, retain) NSIndexPath *currentSelection;
@property (nonatomic, retain) NSMutableArray *services;
@property (nonatomic, retain) NSNetServiceBrowser *netServiceBrowser;
@property (nonatomic, retain) NSNetService* currentResolve;
@property (nonatomic, retain) UITableViewCell *cellOfCurrentResolve;

- (BOOL)setUpServiceBrowserForDomain:(NSString *)domain type:(NSString *)type;
- (void)stopCurrentResolve;
//- (void)setDeletage:(id)sender;
- (void)signInComplete:(NSString* )responseString;
- (void)receiveResponseString:(NSString*)response;
- (void)xmlParserDone:(NSMutableArray *)items;
- (void)xmlParserDoneWithError:(NSError *)parseError;
- (void)xmlParserPropertyDone:(NSMutableArray *)items;
- (void)setTimer:(NSTimer *)newTimer;
@end
