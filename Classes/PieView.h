//
//  PieView.h
//  Aquarium
//
//  Created by Alec Vance on 9/28/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlasmaModel.h"

@class PieView;

//@protocol PieViewDelegate
//@optional
//-(void) userSelectedPieWedgeNum:(int)number;
//@end


@interface PieView : UIView {
	//id delegate;
	PlasmaModel *model;
	BOOL ready;
}

//@property (assign) id delegate;

@property (nonatomic, retain) PlasmaModel *model;

- (void) useModel: (PlasmaModel *) model;
- (void) tic: (NSTimeInterval) dt;
//-(void) createWheel;
//-(void) startAnimation;
//-(void) stopAnimation;

@end	
