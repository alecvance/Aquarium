//
//  AudioMixerSamplePickerController.m
//  Aquarium
//
//  Created by Alec Vance on 11/10/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "AudioMixerSamplePickerController.h"
#import "CustomAudioCell.h"
#import "UIColor-Expanded.h"
#import "Sprite.h"

#define kSquareWidth 26.0
#define kSquareLeft 240.0
#define kSquareTop 10.0

@implementation AudioMixerSamplePickerController
@synthesize delegate;
@synthesize _tableView, audioMixer;

- (void)dealloc {
	[_tableView release];
	[audioMixer release];
	[playImage release];
	[stopImage release];
	[setSelectedImage release];
	//[setNotSelectedImage release];
	[delegate release];
    [super dealloc];
}

///Josh Warren/Aquarium/Classes/AudioMixerSamplePickerController.m:27: warning: '-release' not found in protocol(s)



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	playImage = [[UIImage imageNamed:@"remote2-play.png"] retain];
	stopImage = [[UIImage imageNamed:@"remote2-stop.png"] retain];
	setSelectedImage = [[UIImage imageNamed:@"create-set_selected.png"] retain];
	//setNotSelectedImage = [[UIImage imageNamed:@"button-select_off.png"] retain];
	
	_tableView.backgroundColor = [UIColor blackColor];
	
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.audioMixer numberOfSoundSets];
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return [NSString stringWithFormat:@"Set: %@\n%@",  [self.audioMixer titleOfSet: section], [self.audioMixer artistNameForSet: section]];
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.audioMixer numberOfSamplesInSet: section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//cell.textLabel.text = [NSString stringWithFormat: @"%i Bottles Of Beer On The Wall", (int)indexPath.row +1];
	
	NSDictionary *song = [self.audioMixer audioInfoAtIndexPath:indexPath];
	/*
	NSString *artist;
	if (artist != [song objectForKey:@"artist"]) {
		artist = [self.audioMixer artistNameForSet:indexPath.section];
	}
	 */
	
	//NSArray *pathComponents = [fileName pathComponents];
	//	NSString *songTitle = [pathComponents lastObject]; 
	cell.textLabel.text = [song objectForKey:@"title"];
	cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
	
	//NSLog(@"font = %f %@ of %@", cell.textLabel.font.lineHeight, cell.textLabel.font.fontName,cell.textLabel.font.familyName);
//	cell.backgroundColor = [UIColor colorWithHexString: [song objectForKey:@"color"]];
	cell.backgroundColor = [self colorForSection:indexPath.section];// [UIColor clearColor];

	//cell.detailTextLabel.text = @"Genre Name (Artist Name)";
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [song objectForKey:@"genre"]];
	cell.detailTextLabel.textColor = [UIColor darkGrayColor];
	
	//if(indexPath.row>0){
	//sample (CAF) play button
	
	UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playButton.frame = CGRectMake(275.0, 10.0, 27.0, 27.0);
	
	//UIImage *playImage = [UIImage imageNamed:@"remote2-play.png"];
	if ([indexPath isEqual:samplePlayingIndexPath]) {
		// sample is playing; set to stop button
		[playButton setImage:stopImage forState:UIControlStateNormal];
	}else {
		[playButton setImage:playImage forState:UIControlStateNormal];
	}
	
	
	cell.accessoryView = playButton;
	
	[playButton addTarget: self
				   action: @selector(accessoryButtonTapped:withEvent:)
		 forControlEvents: UIControlEventTouchUpInside];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//	}
	
	
	
	// Draw Box in cell. Really easy way: set BG color of an empty view.
	UIImageView *squareImageView = [[UIImageView alloc] initWithFrame: CGRectMake(kSquareLeft, kSquareTop, kSquareWidth, kSquareWidth)];
	squareImageView.backgroundColor = [UIColor colorWithHexString: [song objectForKey:@"color"]];
	squareImageView.opaque = YES;
	[cell addSubview:squareImageView];
	[squareImageView release];
	
	return cell;
	
	/*
	 NSString *cellID = @"CustomAudioCell";
	 
	 CustomAudioCell *cell = (CustomAudioCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	 
	 if (cell == nil) {
	 NSArray *bundleObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomAudioCell" owner:nil options:nil];
	 for (id currentObject in bundleObjects){
	 if([currentObject isKindOfClass:[CustomAudioCell class]]){
	 cell = (CustomAudioCell *)currentObject;
	 break;
	 }
	 }
	 //cell.selectionStyle = UITableViewCellSelectionStyleNone;
	 }
	 
	 cell.primaryLabel.text = @"Song Name";
	 cell.secondaryLabel.text = @"Genre Name (Artist Name)";
	 
	 // Configure the cell...
	 
	 return cell;    
	 */
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

-(UIColor *)colorForSection: (NSInteger)section{
	return [UIColor colorWithHexString:[self.audioMixer colorForSet:section]];
}



#pragma mark -
#pragma mark Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(30.0, 0.0, 280.0, 84.0)] autorelease];
	customView.backgroundColor =  [UIColor clearColor]; //[self colorForSection:section];

	// create the header label
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor blackColor];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
	
	headerLabel.frame = CGRectMake(10.0, 0.0, 200.0, 44.0);
	headerLabel.adjustsFontSizeToFitWidth = YES;
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	headerLabel.text = [NSString stringWithFormat:@"%@",  [self.audioMixer titleOfSet: section]];
	
	
	[customView addSubview:headerLabel];
	[headerLabel release];
	
	// create the header label
	UILabel * subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	subHeaderLabel.backgroundColor = [UIColor clearColor];
	subHeaderLabel.opaque = NO;
	subHeaderLabel.textColor = [UIColor whiteColor];
	subHeaderLabel.highlightedTextColor = [UIColor blackColor];
	subHeaderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	subHeaderLabel.frame = CGRectMake(15.0, 26.0, 300.0, 42.0);
	
	// If you want to align the header text as centered
	// subHeaderLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	subHeaderLabel.text = [NSString stringWithFormat:@"by %@", [self.audioMixer artistNameForSet: section]];
		
	[customView addSubview:subHeaderLabel];
	[subHeaderLabel release];
	
	
	if(section==self.audioMixer.currentSetNum){
		// image 
		UIImageView *headerButton = [[UIImageView alloc] initWithFrame:CGRectMake(232.0, 20.0, 
									setSelectedImage.size.width, setSelectedImage.size.height)];
		headerButton.image= setSelectedImage;
		[customView addSubview:headerButton];
		[headerButton release];
		
	}else{
		
		//Create a button for the header
		/*
		--old way using image--
		 UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[headerButton setImage:setNotSelectedImage forState:UIControlStateNormal];
		[headerButton setImage:setSelectedImage forState:UIControlStateHighlighted];
		*/
		
		UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		//headerButton.titleLabel.text = @"load";
		//headerButton.titleLabel.textColor = [UIColor blackColor];
		[headerButton setTitle:@"load" forState:UIControlStateNormal];
		//		headerButton.frame = CGRectMake(220.0, 10.0, 	setSelectedImage.size.width, setSelectedImage.size.height);
		headerButton.frame = CGRectMake(240.0, 20.0, 60.0, 20.0);

		[headerButton addTarget: self
						 action: @selector(activateNewSoundSet:withEvent:)
			   forControlEvents: UIControlEventTouchUpInside];
		headerButton.tag = section;
		
		[customView addSubview:headerButton];
		//[headerButton release];
		 		
	}


	
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 66.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	
	
	
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"tapped %@", indexPath);
	
	if ([indexPath isEqual:samplePlayingIndexPath]){
		// user pressed stop ; stop playing sound!
		[self.audioMixer stopAllPreviewSounds];
		samplePlayingIndexPath = nil;
		
	}else{
		
		/*
		 * IF there is ANOTHER sample already playing set its button back;
		 * the audio manager will automagically stop old sample playing
		 * when we start the new one
		 */
		
		if (samplePlayingIndexPath) {
			// user pressed stop button on current playing sample (switch to play)!
			[self setPreviewButtonToPlayAtIndexPath: samplePlayingIndexPath];
		}
		
		[self.audioMixer previewAudioAtIndexPath:indexPath];
		samplePlayingIndexPath = indexPath; // copy or retain?
		
	}
	
}

#pragma mark -
#pragma mark Custom accessoryButtonTappedForRowWithIndexPath
/*
 * Since we're using a custom accessory button, we have to use this routine that calls the standard one
 *
 */




- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [self._tableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] 
																		locationInView: self._tableView]];
    if ( indexPath == nil )
        return;
	
	if ([indexPath isEqual:samplePlayingIndexPath]) {
		// user pressed stop button on current playing sample (switch to play)!
		[(UIButton *)button setImage:playImage forState:UIControlStateNormal];
		
	}else {
		//user pressed play button on non playing sample (switch to stop)
		[(UIButton *)button setImage:stopImage forState:UIControlStateNormal];
		
	}
	
	
    [self._tableView.delegate tableView: self._tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

#pragma mark -
#pragma mark Preview Button Image Changes

- (void) setPreviewButtonToStopAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self._tableView cellForRowAtIndexPath: indexPath];
	UIButton *button = (UIButton *)cell.accessoryView;
	[button setImage:stopImage forState:UIControlStateNormal];
	
}

- (void) setPreviewButtonToPlayAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self._tableView cellForRowAtIndexPath: indexPath];
	UIButton *button = (UIButton *)cell.accessoryView;
	[button setImage:playImage forState:UIControlStateNormal];
	
}

#pragma mark -
#pragma mark Done Button

- (IBAction) doneButtonTouched:(id)sender{
	//close window
	[self dismissModalViewControllerAnimated:YES];
	
	[self.delegate audioMixerSamplePickerWasDismissed];
}

#pragma mark -
-(void) activateNewSoundSet: (UIControl *) button withEvent: (UIEvent *) event
{
	int section = button.tag;
	//NSLog(@"Section = %i", section);


	[self.audioMixer switchSetTo:section];
	[self._tableView reloadData];
	
	[self performSelector: @selector(doneButtonTouched:) withObject: button afterDelay:0.1];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


@end

