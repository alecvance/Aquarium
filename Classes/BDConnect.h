/***
 * This code is provided AS IS for your own use by NetBlender Inc.
 */

#import <Foundation/NSNetServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>

//scott::  Because this class makes return calls to the delegates who spawned this object I defined a protocal to declare what methods that need to implement.
@protocol BDConnectDelegate <NSObject>

@required
-(void)signInComplete:(NSString*)connectionData;
-(void)receiveResponseString:(NSString*)response;

@optional
-(void)loginComplete;

//scott:: methods taken from the BDConnectDelegate.h file.  That file is no longer necessary
//scott::  I have no clue yet if these methods are actually used for anything.
- (void) didFinishSendingCommand:(NSString *)result;
- (void) didFinishDownloadingFile:(NSData *)downLoadedFile;
@end


@class AudioStreamer;
//@class AVAudioPlayer;

@interface BDConnect : NSObject
{
	BOOL waitingForResponse;
	BOOL isLoggedIn;
	BOOL askingForAFile;
	BOOL askingForAFileForStorage;
	BOOL askingForAHTMLFile;
	NSString *commandString;
	NSString *sessionId;
	NSString *fullURL;
	NSString *fullURLForDataFiles;
	NSString *fileType;
	NSString *fileName;
	short int port;
	long downloadProgress;
	
	NSNetServiceBrowser *connection;  //scott:: you could consider making this variable a static class variable that way anyone can access it once it is created.
	NSMutableData *receivedData;
	id <BDConnectDelegate> delegate; //scott:: cast to the delegate protocal now defined at the top of this header
	id delegate2; //scott:: really confused by this and why it is here.
	UIImageView *imageView;
	UIButton *imageViewButton;
	UIActivityIndicatorView *waitIcon;
	AudioStreamer *streamer;
	
	NSString *nfId;
	NSString *discName;
	NSString *discId;
	NSString *orgId;
	NSString *uniqueId;
	NSFileHandle *downloadHandle;
}

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *imageViewButton;
@property (nonatomic, readonly) UIActivityIndicatorView *waitIcon;
@property (nonatomic, assign)BOOL isLoggedIn;
@property (nonatomic, retain)NSString *nfId;
@property (nonatomic, retain)NSString *discName;
@property (nonatomic, retain)NSString *discId;
@property (nonatomic, retain)NSString *orgId;
@property (nonatomic, retain)NSString *uniqueId;
@property (nonatomic, retain)NSFileHandle *downloadHandle;
@property (nonatomic, retain)	id <BDConnectDelegate> delegate; 

- (IBAction) toggleSignInClick:(id)sender;
- (void) sendSignIn;
- (void) sendSignOut;
-(void) hostPath:(NSString*)urlConnectionString;
- (void) hostPathForData:(NSString *) path;
//scott:: changed the return parameter from 'id' to proper 'NSData*' which is what is actually being returned
- (NSData*) sendCommand:(NSString *)command param1:(NSString *)param1  param2:(NSString *)param2 param3:(NSString *)param3 param4:(NSString *)param4;
- (void) sendDownloadMovieFile:(id)sender;
- (void) sendDownloadFile:(NSString*)fileURL theFileName:(NSString*)theFileName theFileType:(NSString*)theFileType;
- (void) sendDownloadBinaryFile:(NSString*)fileURL theFileName:(NSString*)theFileName theFileType:(NSString*)theFileType;
- (void) sendDownloadHTMLFile:(NSString*)fileURL theFileName:(NSString*)theFileName theFileType:(NSString*)theFileType;
//- (void) setDeletage:(id)sender;
- (void) setDelegateTwo:(id)sender;
- (void) sendDownloadVideoCommand:(id)sender;
- (void) setUpUIData: (UIImageView*)currentImageView currentImageViewButton:(UIButton*)currentImageViewButton currentWaitIcon:(UIActivityIndicatorView*)currentWaitIcon;
- (void) downloadPhoto;
- (void) downloadMusicFile;
- (void) downloadVideoFile;
- (void) downloadHTMLFile;
-(void) setPort:(NSString*) _stringPort;
- (NSString*) getIP;
- (NSString*) getSessionID;
- (NSString*) getFullURL;

//scott:: changed the return parameter from 'id' to proper 'NSData*' which is what is actually being returned
- (NSData*) sendFileRequestionCommand:(NSString *)command param1:(NSString *)param1  param2:(NSString *)param2 param3:(NSString *)param3 param4:(NSString *)param4;

-(void) launchURL:(NSString*)_urlString;

- (void) playVideoFile:(NSString*)_fileName;
- (void) playAudioFile:(NSString*)_fileName;
- (BOOL) updateImageFile:(NSString*)_fileName forImageView:(UIImageView*)_imgView;
//netblender::added for downloading a html file
- (BOOL) updateHTMLFile:(NSString*)_fileName;
- (void )myMovieFinishedCallback:(NSNotification*)aNotification;
- (void)updateSessionId:(NSString*)_session;

@end

