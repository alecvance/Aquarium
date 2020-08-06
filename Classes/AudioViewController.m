//
//  AudioViewController.m
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "AudioViewController.h"
#import "CustomAudioCell.h"

@implementation AudioViewController

@synthesize _tableView, loopButton, shuffleButton, songPlayer;

- (void)dealloc {
	[_tableView release];
	[songPlayer release];
	[playImage release];
	[stopImage release];
	[shuffleButton release];
	[loopButton release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;

	[self updateButtons];
}

- (void) updateButtons{
	[shuffleButton setSelected: self.songPlayer.shuffle];
	[loopButton setSelected: self.songPlayer.loopSong];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	playImage = [[UIImage imageNamed:@"remote2-play.png"] retain];
	stopImage = [[UIImage imageNamed:@"remote2-stop.png"] retain];
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	
	self.songPlayer.delegate = self;
	[self._tableView reloadData]; // makes sure buttons are updated.

	
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	if(self.songPlayer.delegate == self){
		self.songPlayer.delegate = nil;
	};
	
}

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
    return 1;//[self.songPlayer numberOfSongs];
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [NSString stringWithFormat:@"Set: %@\n%@",  [self.songPlayer titleOfSet: section], [self.songPlayer artistNameForSet: section]];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.songPlayer numberOfSongs];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//cell.textLabel.text = [NSString stringWithFormat: @"%i Bottles Of Beer On The Wall", (int)indexPath.row +1];
	
	//NSDictionary *song = [self.songPlayer audioInfoForSong:indexPath.row];
	
	//NSArray *pathComponents = [fileName pathComponents];
//	NSString *songTitle = [pathComponents lastObject]; 
	cell.textLabel.text = [self.songPlayer titleForSong:indexPath.row] ;
//	cell.detailTextLabel.text = @"Genre Name (Artist Name)";
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ (%@)", 
								 [self.songPlayer artistNameForSong:indexPath.row],
								 [self.songPlayer genreNameForSong:indexPath.row]];


	
	//if(indexPath.row>0){
		//sample (CAF) play button
		
		UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
		playButton.frame = CGRectMake(275.0, 10.0, 27.0, 27.0);
		
		//UIImage *playImage = [UIImage imageNamed:@"remote2-play.png"];
		if (indexPath.row ==self.songPlayer.currentSongNum) {
			// sample is playing; set to stop button
			[playButton setImage:stopImage forState:UIControlStateNormal];
			
			
			// animate text
			
			cell.textLabel.textColor = [UIColor redColor];
			[UIView beginAnimations:@"animateText" context:nil];
			cell.textLabel.textColor = [UIColor blueColor];
			[UIView setAnimationDuration:2.0];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationRepeatAutoreverses:YES];
			[UIView setAnimationRepeatCount:1.7E+38]; //forever
			[UIView commitAnimations];
			
			cell.detailTextLabel.textColor = [UIColor darkGrayColor];
			
		}else {
			// sample is stopped -- default state
			cell.textLabel.textColor = [UIColor blackColor];
			cell.detailTextLabel.textColor = [UIColor grayColor];


			[playButton setImage:playImage forState:UIControlStateNormal];
			
		
			
		}

		

		cell.accessoryView = playButton;
		
		[playButton addTarget: self
				   action: @selector(accessoryButtonTapped:withEvent:)
		 forControlEvents: UIControlEventTouchUpInside];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

//	}
	
	
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


		

#pragma mark -
#pragma mark Table view delegate
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 84.0)] autorelease];
	
	// create the header label
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0];
	
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	headerLabel.text = [NSString stringWithFormat:@"Set: %@",  [self.songPlayer titleOfSet: section]];

	[customView addSubview:headerLabel];
	[headerLabel release];
	
	// create the header label
	UILabel * subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	subHeaderLabel.backgroundColor = [UIColor clearColor];
	subHeaderLabel.opaque = NO;
	subHeaderLabel.textColor = [UIColor blackColor];
	subHeaderLabel.highlightedTextColor = [UIColor whiteColor];
	subHeaderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	subHeaderLabel.frame = CGRectMake(15.0, 26.0, 300.0, 42.0);
	
	// If you want to align the header text as centered
	// subHeaderLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	subHeaderLabel.text = [NSString stringWithFormat:@"Artist: %@", [self.songPlayer artistNameForSong: indexPath.row]];
	
	[customView addSubview:subHeaderLabel];
	[subHeaderLabel release];
	
	
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 66.0;
}

*/
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
	
	if (indexPath.row == self.songPlayer.currentSongNum){
		// user pressed stop ; stop playing sound!
		
		[self.songPlayer stopSong];
		
	}else{
		
		/*
		 * IF there is ANOTHER sample already playing set its button back;
		 * the audio manager will automagically stop old sample playing
		 * when we start the new one
		 */
		
		if (self.songPlayer.currentSongNum) {
			// user pressed stop button on current playing sample (switch to play)!
			[self setPreviewButtonToPlayForSong: self.songPlayer.currentSongNum];
		}

		[self.songPlayer startPlaylistFromSong:indexPath.row];
		
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
		
	if (indexPath.row == self.songPlayer.currentSongNum) {
		// user pressed stop button on current playing sample (switch to play)!
		[(UIButton *)button setImage:playImage forState:UIControlStateNormal];

	}else {
		//user pressed play button on non playing sample (switch to stop)
		[(UIButton *)button setImage:stopImage forState:UIControlStateNormal];

	}

	
    [self._tableView.delegate tableView: self._tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

- (void) setPreviewButtonToStopForSong:(int)i {
	UITableViewCell *cell = [self._tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
	UIButton *button = (UIButton *)cell.accessoryView;
	[button setImage:stopImage forState:UIControlStateNormal];

}

- (void) setPreviewButtonToPlayForSong:(int)i {
	UITableViewCell *cell = [self._tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
	UIButton *button = (UIButton *)cell.accessoryView;
	[button setImage:playImage forState:UIControlStateNormal];
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark get reference to SongPlayer singleton

-(SongPlayer *)songPlayer{
	if(songPlayer == nil){
		songPlayer = [SongPlayer sharedManager];
		songPlayer.delegate = self;
	}
	
	return songPlayer;

}

#pragma mark -
#pragma mark User actions
-(IBAction) loopButtonWasTouched{
	// only loops one song (for now)
	self.songPlayer.loopSong = !(self.songPlayer.loopSong);
	[self updateButtons];
}
-(IBAction) shuffleButtonWasTouched{
	//self.songPlayer.shuffle = !(self.songPlayer.shuffle);
	[self.songPlayer toggleShuffle];
	
	[self updateButtons];
}

#pragma mark -
#pragma mark SongPlayerDelegate 
-(void)songPlayerDidChangeSongs{
	[self._tableView reloadData];
}


@end

