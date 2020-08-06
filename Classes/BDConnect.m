/***
 * This code is provided AS IS for your own use by NetBlender Inc.
 */

#import "BDConnect.h"

@implementation BDConnect

//scott:: Following line was added by scott.  unless you define getter/setter methods for properties declared in the header, you must synthesize them to envoke the convenience getter/setter mothods.
@synthesize imageView, imageViewButton, waitIcon, isLoggedIn, nfId, discName, discId, orgId, uniqueId, downloadHandle;
@synthesize delegate;


-(void) dealloc{
	
	[imageView release];
	[imageViewButton release];
	[waitIcon release];
	[nfId release];
	[discName release];
	[discId release];
	[orgId release];
	[uniqueId release];
	[downloadHandle release];
	[delegate release];
	
	[super dealloc];
}

/**
 * This is to set the host path so it can be access by other methods.
 */
-(void) hostPath:(NSString*)urlConnectionString
{
	fullURL = [[NSString alloc] initWithString: urlConnectionString];
}

/**
 * This is to set the host path so it can be access by other methods.  This host path NORMALLY is the same as fullURL but this was a unique case. SHOULD NOT BE DONE THIS WAY.
 */
-(void) hostPathForData:(NSString *) urlConnectionString
{
	fullURLForDataFiles = [[NSString alloc] initWithString: urlConnectionString];
}

/**
 * Changes the sign in button based on the sign in status.
 */
- (IBAction) toggleSignInClick:(id)sender
{
	if (isLoggedIn)
	{
		[self sendSignOut];
	}
	else
	{
		[self sendSignIn];
	}
	
}

/**
 *  This sends the offical BD Touch Specification Command to the disc.
 */
//scott:: changed the return parameter from 'id' to proper 'NSData*' which is what is actually being returned
- (NSData*) sendCommand:(NSString *)command param1:(NSString *)param1  param2:(NSString *)param2 param3:(NSString *)param3 param4:(NSString *)param4
{
	NSString *_command = [@"COMMAND=" stringByAppendingString:command];
	_command = [_command stringByAppendingString:@"&SESSION_ID="];
	_command = [_command stringByAppendingString:sessionId];
	if (param1 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param1];
	}
	if (param2 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param2];
	}
	if (param3 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param3];
	}
	if (param4 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param4];
	}
	
	
	
	commandString = [[NSString alloc] initWithString:_command];
	[commandString retain];
	NSData* okData = [commandString dataUsingEncoding:NSASCIIStringEncoding];		
	NSString* postLength = [NSString stringWithFormat:@"%d", [okData length]];
	
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:fullURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:okData];
	
	//NSLog(@"Sending command: %@", commandString);

	waitingForResponse = YES;
	// create the connection with the request and start loading the data 
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request 
																   delegate:self]; 
	if (theConnection) 
	{ 
		receivedData=[[NSMutableData data] retain]; 
		return receivedData;
	} 
	else 
	{ 
		// inform the user that the download could not be made
		
	}
	//scott:: added the following line to make the method compliant with it's declaration that it returns something.
	return nil;
}

/**
 * This sends a file Requrest Command to the disc.  IT IS BEST to review the BD Touch SDK sample application for this.
 */
//scott:: changed the return parameter from 'id' to proper 'NSData*' which is what is actually being returned
- (NSData*) sendFileRequestionCommand:(NSString *)command param1:(NSString *)param1  param2:(NSString *)param2 param3:(NSString *)param3 param4:(NSString *)param4
{
	NSString *_command = [@"COMMAND=" stringByAppendingString:command];
	_command = [_command stringByAppendingString:@"&SESSION_ID="];
	_command = [_command stringByAppendingString:sessionId];
	if (param1 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param1];
	}
	if (param2 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param2];
	}
	if (param3 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param3];
	}
	if (param4 != nil)
	{
		_command = [_command stringByAppendingString:@"&"];
		_command = [_command stringByAppendingString:param4];
	}
	commandString = [[NSString alloc] initWithString:_command];
	[commandString retain];
	NSData* okData = [commandString dataUsingEncoding:NSASCIIStringEncoding];		
	NSString* postLength = [NSString stringWithFormat:@"%d", [okData length]];
	
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:fullURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:okData];
	
	waitingForResponse = YES;
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request 
																   delegate:self]; 
	if (theConnection) 
	{ 
		receivedData=[[NSMutableData data] retain]; 
		return receivedData;
	} 
	else 
	{ 
		// inform the user that the download could not be made 
	}
	//scott:: added the following line to make the method compliant with it's declaration that it returns something.
	return nil;
}

/**
 * Sends the sign out code command to the disc.
 */
- (void) sendSignOut
{
	commandString = @"COMMAND=sign_out";
	//scott:: the following call is to a method that does not exist.  should it be removed?
	//[self sendCreatedCommand];
	//scott::  this seems backwards.  if this var is being used, shouldn't it now be NO?
	isLoggedIn = NO; // ALEC FLIPPED!
	
}

/**
 * Sends the sign in code command to the disc.
 */
- (void) sendSignIn
{
	commandString = [[NSString alloc] initWithString: @"COMMAND=sign_in&application_name=BD_Touch_Fire_Application&application_company=NetBlender&application_version=1.0&application_guid=FAE04EC0-301F-11D3-BF4B-00C04F79EFBC&bdconnect_version=1.0&receives_files=true"];
	[commandString retain];
	NSData* okData = [commandString dataUsingEncoding:NSASCIIStringEncoding];		
	NSString* postLength = [NSString stringWithFormat:@"%d", [okData length]];
	
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:fullURL]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:okData];
	
	waitingForResponse = YES;
	askingForAFile = NO;
	// create the connection with the request and start loading the data 
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request 
																   delegate:self]; 
	if (theConnection) 
	{ 
		// Create the NSMutableData that will hold the received data 
		// receivedData is declared as a method instance elsewhere 
		receivedData=[[NSMutableData data] retain]; 
		
	} else 
	{ 
		// inform the user that the download could not be made 
		NSLog(@"The connection could not be made.");
	}

}

/**
 * Sends tthe command to dowonload a specific file
 */
- (void) sendDownloadMovieFile:(id)sender
{
	askingForAFile = YES;
	[self sendCommand:@"request_file" param1:@"file_path=jar/trailer.m4v" param2:nil param3:nil param4:nil];
}

/**
 * Performs the downloading
 */
- (void) sendDownloadFile:(NSString*)fileURL theFileName:(NSString*)theFileName theFileType:(NSString*)theFileType
{
	askingForAFile = YES;
	fileType = [theFileType copy];
	fileName = [theFileName copy];
	
	
	
	NSString *filePath = [[NSString alloc] initWithString:@"file_path="];
	filePath = [filePath stringByAppendingString:fileURL];
	//[self sendCommand:@"request_file" param1:@"file_path=jar/trailer.m4v" param2:nil param3:nil param4:nil];	
	
	[self sendFileRequestionCommand:@"request_file" param1:filePath param2:nil param3:nil param4:nil];	
	
}
/**
 * Performs the downloading
 */
- (void) sendDownloadHTMLFile:(NSString*)fileURL theFileName:(NSString*)theFileName theFileType:(NSString*)theFileType
{
	askingForAHTMLFile = YES;
	fileType = [theFileType copy];
	fileName = [theFileName copy];
	
	NSString *filePath = [[NSString alloc] initWithString:@"file_path="];
	filePath = [filePath stringByAppendingString:fileURL];
	[self sendFileRequestionCommand:@"request_file" param1:filePath param2:nil param3:nil param4:nil];	
	
}


- (void) sendDownloadBinaryFile:(NSString*)fileURL theFileName:(NSString*)theFileName theFileType:(NSString*)theFileType
{
	askingForAFileForStorage = YES;
	fileType = [theFileType copy];
	fileName = [theFileName copy];
	
	NSString *filePath = [[NSString alloc] initWithString:@"file_path="];
	filePath = [filePath stringByAppendingString:fileURL];
	//[self sendCommand:@"request_file" param1:@"file_path=jar/trailer.m4v" param2:nil param3:nil param4:nil];	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
		[fileManager removeItemAtPath:appFile error:nil];
	[fileManager createFileAtPath:appFile contents:nil attributes:nil];
	self.downloadHandle = [NSFileHandle fileHandleForWritingAtPath:appFile];
	[self sendFileRequestionCommand:@"request_file" param1:filePath param2:nil param3:nil param4:nil];	
	
}

/** Impelmented Delegates **/
- (void)connection:(NSURLConnection *)currentConnection didReceiveResponse:(NSURLResponse *)response
{
	//if (askingForAFileForStorage = YES)
	//{
	//	[receivedData writeToFile:fileName atomically:YES];
	//}
	//askingForAFileForStorage = NO;
	//askingForAFile = NO;
	[receivedData setLength:0];
	downloadProgress = 0;
}

- (void)connection:(NSURLConnection *)currentConnection didReceiveData:(NSData *)data
{
	if (askingForAFileForStorage == YES)
	{
		//append the data to the file handle
		downloadProgress += [data length];
		//NSLog(@"dl: %d",downloadProgress);
		[downloadHandle writeData:data];
	}
	else
	{
		//scott:: dont break legacy method as I think sign in and such still uses this.
		[receivedData appendData:data];
	}
}

- (void)connection:(NSURLConnection *)currentConnection didFailWithError:(NSError *)error
{
    
	if(receivedData != nil){
		receivedData = nil;
	}
	[currentConnection release];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

/**
 * This will handle the response and currently always assumes an OK response. 
 * TODO: Add error handling.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)currentConnection
{
	if (askingForAFileForStorage == YES)
	{
		//scott:: I just received a binary file, so dont proceed with this function as it was, since it attempts to convert the received data to a string.
		//need to close the file that has been written to.
		[downloadHandle closeFile];
		
		askingForAFileForStorage = NO;
		[delegate receiveResponseString:@""];
	}
	else
	{
		NSString* dataString = [[NSString alloc] initWithData: receivedData encoding:NSASCIIStringEncoding];
		//scott:: added this line just for debugging
		//NSLog(@"got response %@",dataString); 
		if (askingForAFile == NO && isLoggedIn == NO)
		{
			NSString *status = [dataString substringWithRange:NSMakeRange(25,2)];
			if ([status isEqual:@"OK"])
			{
				sessionId =  [[dataString substringWithRange:NSMakeRange(40,36)] retain];
				isLoggedIn = YES;
				[delegate signInComplete:dataString];
				if (delegate2 != nil)
					[delegate2 loginComplete];
			}
		}

		else if (askingForAFile == YES && isLoggedIn == YES)
		{
			//[streamer stop];
			askingForAFile = NO;
			if ([fileType isEqualToString:@"Video"] || [fileType isEqualToString:@"Audio"] || [fileType isEqualToString:@"Image"])
			{
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
				NSString *documentsDirectory = [paths objectAtIndex:0];
				if (!documentsDirectory) 
				{
					//NSLog(@"Documents directory not found!");
					return;
				}
				NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
				NSFileManager *fileManager = [NSFileManager defaultManager];
				if ([fileManager fileExistsAtPath:appFile])
					[fileManager removeItemAtPath:appFile error:nil];
				
				askingForAFile = NO;
				
				//Write the file to the local file system
				BOOL success = [receivedData writeToFile:appFile atomically:YES];	
				if(!success)NSLog(@"error writing file");
			}
			else if (fileType == @"png")
				[self downloadPhoto];
			else if (fileType == @"mp3")
				[self downloadMusicFile];
			else if (fileType == @"m4v")
				[self downloadVideoFile];

			
			[delegate receiveResponseString:dataString];

		}
		
		else if (isLoggedIn)
		{
			//this is jus the result text in the reposne from the button presses on the remote
			//scott:: this next line was done at the top of the method and thus can be removed
			//NSString *stringResult = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			
			//scott:: the delegate protocal notes this as a required method for the delegate as it resuts in a fatal crash if not implemented
			//scott:: should really look at providing proper error handling and checking that the delegate can handle the method before calling it.
			if([fileType isEqualToString:@"Rocks Star Bios"] || [fileType isEqualToString:@"Actor Bios"])
			{
				if (askingForAHTMLFile == YES)
					[self downloadHTMLFile];
			}
			[delegate receiveResponseString:dataString];
		}
		
		[currentConnection release];
		//[receivedData release];
	}
}

/** 
 * Sets the dellegate.  Normally there is only one delegate.
 */
//- (void)setDeletage:(id)sender
//{
//	delegate = sender;
//}

/** 
 * Sets the dellegate.  Normally there is only one delegate.
 */
-(void)setDelegateTwo:(id)sender
{
	delegate2 = sender;
}

/**
 * This method performs the saving of the image
 */
-(void) downloadPhoto
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
		[fileManager removeItemAtPath:appFile error:nil];
	
	askingForAFile = NO;
	
	//Write the file to the local file system
	[receivedData writeToFile:appFile atomically:YES];
	
	//scott::  the following is not used for photos(?).  It should be removed.
	//Create the url for the media player to use
	//NSURL *theURL = [[NSURL alloc] initFileURLWithPath:appFile];
	
	//scott:: the following line is redundant it was just called two lines above.  It should be removed.
	//[receivedData writeToFile:appFile atomically:YES];  
	
	//scott:: if you are just passing nil for params 2 and 3, then there is a valid method for invoking without them and avoids the compile warning from invalidly passing in nil.
	//NSData *imageData = [NSData dataWithContentsOfFile:appFile options:nil error:nil];
	NSData *imageData = [NSData dataWithContentsOfFile:appFile];

	UIImage *theImage = [UIImage imageWithData:imageData];
	UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil);
	[imageView setImage:theImage];
	imageView.hidden = FALSE;
	imageViewButton.hidden = FALSE;
}
//NetBlender:: - downlods and HTML File
-(void) downloadHTMLFile
{
	NSString* _dataString = [[NSString alloc] initWithData: receivedData encoding:NSASCIIStringEncoding];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
		[fileManager removeItemAtPath:appFile error:nil];
	askingForAFile = NO;
	askingForAHTMLFile = NO;
	
	NSString* htmlSearch = @"bdconnect.bdt? ";
	NSRange htmlSearchRange = [_dataString rangeOfString:htmlSearch options:(NSCaseInsensitiveSearch)];
	if (htmlSearchRange.length > 0)
	{
		NSString *firstHalf = [_dataString substringWithRange:NSMakeRange(0, htmlSearchRange.location)];
		NSRange tempRange = NSMakeRange(htmlSearchRange.location + 15, _dataString.length - (htmlSearchRange.location + 15));
		NSString *secondHalf = [_dataString substringWithRange:tempRange];
		NSString *fullHTML = [firstHalf stringByAppendingString:[self getFullURL]];
		fullHTML = [fullHTML stringByAppendingString:@"?"];
		fullHTML = [fullHTML stringByAppendingString:secondHalf];
		_dataString = fullHTML;
								
	}
	else
		_dataString = [_dataString substringWithRange:NSMakeRange(121, [_dataString length] - 121)];
	
	//Write the file to the local file system
	//NSUTF8StringEncoding
	//NSASCIIStringEncoding
	[@"<html></html>" writeToFile:@"<HTML></HTML>" atomically:NO encoding:NSASCIIStringEncoding error:nil];
	if ([_dataString writeToFile:appFile atomically:NO encoding:NSUTF8StringEncoding error:nil])
	{
		NSLog(@"Write File");
	}
	else
		NSLog(@"Did not Write File");
	if ([fileManager fileExistsAtPath:appFile])
		NSLog(@"Write Fle");
	else
		NSLog(@"Did not Write File");
	
	//[_dataString writeToFile:appFile atomically:NO encoding:NSASCIIStringEncoding error:error];
}
/**
 * This method performs the saving of the video file
 */
-(void) downloadVideoFile
{
	[waitIcon startAnimating];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
		[fileManager removeItemAtPath:appFile error:nil];
	
	askingForAFile = NO;
	
	//Write the file to the local file system
	[receivedData writeToFile:appFile atomically:YES];
	
	//scott:: the following does not seem to be used for anything.  Should be removed.
	//Create the url for the media player to use
	//NSURL *theURL = [[NSURL alloc] initFileURLWithPath:appFile];
	[receivedData writeToFile:appFile atomically:YES];
	
	//AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:receivedData error:nil];
	//[player play];
	[self playVideoFile:fileName];
	[waitIcon stopAnimating];
	
}

/**
 * This method performs the saving of the music file
 */
-(void) downloadMusicFile
{
	[waitIcon startAnimating];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
		[fileManager removeItemAtPath:appFile error:nil];
	
	askingForAFile = NO;
	
	//Write the file to the local file system
	[receivedData writeToFile:appFile atomically:YES];
	
	//scott:: the following does not seem to be used for anything.  Should be removed.
	//Create the url for the media player to use
	//NSURL *theURL = [[NSURL alloc] initFileURLWithPath:appFile];
	[receivedData writeToFile:appFile atomically:YES];

	AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:receivedData error:nil];
	[player play];
	[waitIcon stopAnimating];

}

/**
 * TSends the command to download the video and updates varialbes that indicate the iphone is waiting for a video to be downloaded
 */
-(void) sendDownloadVideoCommand:(id)sender{
	
	//(NSURL*)theURL
	NSString *urlString = [fullURL stringByAppendingString:@"?COMMAND=request_file&file_path=jar/trailer.m4v&SESSION_ID="];
	urlString = [urlString stringByAppendingString:sessionId];
	NSURL * theURL = [[NSURL alloc] initWithString:urlString];
	
	MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL];
	theMovie.scalingMode=MPMovieScalingModeAspectFill;
	//theMovie.userCanShowTransportControls=NO;
	
	// Register for the playback finished notification.		
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:theMovie];
	
	// Movie playback is asynchronous, so this method returns immediately.
	[theMovie play]; 
}


// When the movie is done,release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
	MPMoviePlayerController* theMovie=[aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:theMovie];
	
	// Release the movie instance created in playMovieAtURL
	[theMovie release];
}

- (void) setUpUIData: (UIImageView*)currentImageView currentImageViewButton:(UIButton*)currentImageViewButton currentWaitIcon:(UIActivityIndicatorView*)currentWaitIcon;
{
	imageView = currentImageView;
	imageViewButton = currentImageViewButton;
	waitIcon = currentWaitIcon;
}

/**
 * Plays a video file.
 */
-(void) playVideoFile:(NSString*)_fileName
{
	
	//[waitIcon startAnimating];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:_fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
	{
		NSURL *theURL = [[NSURL alloc] initFileURLWithPath:appFile];
		MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL];
		theMovie.scalingMode=MPMovieScalingModeAspectFill;
		[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myMovieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:theMovie];
	
		// Movie playback is asynchronous, so this method returns immediately.
		[theMovie play]; 
	}
}

-(void)launchURL:(NSString*)_urlString
{
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlString]])
	{
		// there was an error trying to open the URL. for the moment we'll simply ignore it.
	}
}

-(void) playAudioFile:(NSString*)_fileName
{
	
	[waitIcon startAnimating];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:_fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
	{
		NSURL *theURL = [[NSURL alloc] initFileURLWithPath:appFile];
		
		//AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:receivedData error:nil];
		AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:theURL error:nil];
		[player play];
	}
}

-(BOOL)updateImageFile:(NSString*)_fileName forImageView:(UIImageView*)_imgView
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return NO;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:_fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile]){
		NSData *imageData = [NSData dataWithContentsOfFile:appFile];
		UIImage *theImage = [UIImage imageWithData:imageData];
		[_imgView setImage:theImage];
		return YES;
	}
	return NO;
}

-(BOOL)updateHTMLFile:(NSString*)_fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return NO;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:_fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL fileFound = [fileManager fileExistsAtPath:appFile];
	return fileFound;
}


-(void) setPort:(NSString*) _stringPort
{
	port = [_stringPort intValue];
	NSString* _urlString = [[NSString alloc] initWithString:@"http://"];
	NSString* defaultDiscIp = [[NSString alloc] initWithString:@"10.0.1.202:"];
	_urlString = [_urlString stringByAppendingString:defaultDiscIp];
	_urlString = [_urlString stringByAppendingString:_stringPort];
	_urlString = [_urlString stringByAppendingString:@"?bdconnect.bdt"];
	
	[self hostPath:_urlString];
}

- (NSString*) getIP
{	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"Documents directory not found!");
		return nil;
	}
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"ip.txt"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:appFile])
	{
		NSString *ip = [[NSString alloc] initWithContentsOfFile:appFile];
		if (ip != nil)
		{
			NSArray *lines = [ip componentsSeparatedByString:@"#"];
			NSString *storedIP = [lines objectAtIndex:0];
			return storedIP;
		}
	}
	return nil;
}
- (NSString*) getSessionID
{
	return sessionId;
}

-(NSString*) getFullURL
{
	return fullURL;
}

- (void)updateSessionId:(NSString*)_session{
	sessionId = _session;
}
@end
