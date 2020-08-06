/***
 * This code is provided AS IS for your own use by NetBlender Inc.
 */
#import <Foundation/NSNetServices.h>

@interface BDConnectDelegate : NSObject
{

}

- (void) bdconnectDidFinishSendingCommand:(NSString *)result;
- (void) bdconnectDidFinishDownloadingFile:(NSData *) downLoadedFile;

@end