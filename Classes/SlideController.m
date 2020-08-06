//
//  SlideController.m
//  Aquarium
//
//  Created by Alec Vance on 11/1/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "SlideController.h"
#import "Constants.h"

@implementation SlideController

@synthesize pageControl, scrollView; //, slideStack;
@synthesize slideSets, setNum, slideNum; //, touchStart;
@synthesize prevSetButton, nextSetButton;

- (void)dealloc {
	[scrollView release];
	[pageControl release];
	//[slideStack release];
	[prevSetButton release];
	[nextSetButton release];
    [super dealloc];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	NSString *path = [[NSBundle mainBundle] pathForResource: @"Library" ofType:@"plist"];
	NSDictionary *library = [[NSDictionary alloc] initWithContentsOfFile: path];
	slideSets = [[library objectForKey:@"Slides"] retain];
	[library release];

	setNum = 0;
	slideNum = 0;
	
	// pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
	
	[self loadSlideSet];
}

-(int)numberOfSets{
	return [slideSets count];
}

-(NSArray *)slidesForSet:(NSInteger)i{
	return [slideSets objectAtIndex:i]; 
}

-(int)numberOfSlidesInSet:(int)i{
	return [[self slidesForSet:i] count];
}

-(void)loadSlideSet{
	
	//NSLog(@"Loading set %i; slideNum=%i",setNum,slideNum);
	int numberOfPages = [self numberOfSlidesInSet: setNum];
	
	//if(slideNum>numberOfPages-1)slideNum=numberOfPages-1; // might do NSASSERT?
	
	CGFloat w = scrollView.frame.size.width;
	CGFloat h = scrollView.frame.size.height;
	
	scrollView.contentSize = CGSizeMake(w * numberOfPages, h);
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    pageControl.numberOfPages = numberOfPages;
    pageControl.currentPage = slideNum;
	
	[scrollView setContentOffset:CGPointMake(slideNum*w, 0)];
	
	[prevSetButton setEnabled:(setNum>0)];
	[nextSetButton setEnabled:(setNum<[self numberOfSets]-1)];
	
	
	
	NSArray *slideFileNames = [self slidesForSet: setNum];
	
	/* This method loads ALL the slides for the set into memory. '
	 * COSTLY!!
	 */
	 
	int i = 0;
	for (NSString *slideFile in slideFileNames) {
		slideFile = [NSString stringWithFormat: @"Slides/%@",slideFile];
		//NSLog(@"Loading slide file named: %@", slideFile);
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:slideFile]];		
		[imageView setFrame: CGRectMake(i*w, 0, w, h)];
		[scrollView addSubview:imageView];
		[imageView release];
		 i++;
	}

}
-(void) removeAllSlides{
	for (UIImageView *imageView in scrollView.subviews){
		[imageView removeFromSuperview];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	touchStart = [[touches anyObject] locationInView: self.view];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint touchEnd = [[touches anyObject] locationInView: self.view];

	CGFloat deltaX = touchEnd.x - touchStart.x;
	CGFloat deltaY = ABS(touchEnd.y - touchStart.y);
	
	if ((deltaX>kMinSwipeDistance) && (deltaY<kMaxSwipeTolerance)) {
		// right swipe, page ++
		if (slideNum<[slideStack count]) {
			slideNum++;
			//[UIView beginAnimations:@"slideRight" context:nil];
//			[UIView setAnimationDuration:0.2f];
//			[UIView setAnimationBeginsFromCurrentState:YES];
//
//			slideImageView.image = [UIImage imageNamed:[slideStack objectAtIndex:slideNum]];
//			[UIView commitAnimations];
		}
		
	}else{
		if ((deltaX<-kMinSwipeDistance) && (deltaY<kMaxSwipeTolerance)) {
			// left swipe, page ++--
			if (slideNum>0) {
				slideNum--;
//				slideImageView.image = [UIImage imageNamed:[slideStack objectAtIndex:slideNum]];
			}
			
		}
			
	}
	
	pageControl.currentPage = slideNum; 
}
*/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark  -
#pragma mark Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)_scrollView{
	slideNum = (int) ( _scrollView.contentOffset.x / _scrollView.bounds.size.width  +  0.5);
	//2NSLog(@"xPos = %f", xPos);
	pageControl.currentPage = slideNum; 

}



#pragma mark -
#pragma mark User Actions

-(IBAction) nextSetButtonWasTouched{
	[self removeAllSlides];
	setNum++;
	slideNum = 0;
	[self loadSlideSet];
}
-(IBAction) previousSetButtonWasTouched{
	[self removeAllSlides];
	setNum--;
	slideNum = 0; //[self numberOfSlidesInSet:setNum];
	[self loadSlideSet];
}

@end
