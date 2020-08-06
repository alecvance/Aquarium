//
//  PieView.h
//  Aquarium
//
//  Created by Alec Vance on 9/28/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieWedgeView.h"


@class PieView;

@protocol PieViewDelegate
@optional
-(void) userSelectedPieWedgeNum:(int)number;
@end


@interface PieView : UIView <PieWedgeViewDelegate> {
	id delegate;
}

@property (assign) id delegate;

-(void) createWheel;
-(void) startAnimation;
-(void) stopAnimation;

@end
