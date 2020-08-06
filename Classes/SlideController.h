//
//  SlideController.h
//  Aquarium
//
//  Created by Alec Vance on 11/1/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlideController : UIViewController <UIScrollViewDelegate> {

	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	IBOutlet UIButton *prevSetButton;
	IBOutlet UIButton *nextSetButton;

	
	NSArray *slideSets;
	NSInteger setNum;
	NSInteger slideNum;
	//CGPoint touchStart;
}

@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *prevSetButton;
@property (nonatomic, retain) UIButton *nextSetButton;

@property (nonatomic, retain) NSArray *slideSets;
@property (assign) NSInteger setNum;
@property (assign) NSInteger slideNum;
//@property (assign) CGPoint touchStart;
-(int)numberOfSets;
-(NSArray *)slidesForSet:(NSInteger)i;
-(int)numberOfSlidesInSet:(int)i;
-(void)loadSlideSet;

-(IBAction) nextSetButtonWasTouched;
-(IBAction) previousSetButtonWasTouched;


@end
