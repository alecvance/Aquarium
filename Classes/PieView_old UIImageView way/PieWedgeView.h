//
//  PieWedgeView.h
//  Aquarium
//
//  Created by Alec Vance on 9/28/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieWedgeView;

@protocol PieWedgeViewDelegate
@required
-(void) userSelectedPieWedgeNum:(int)number;
@end


@interface PieWedgeView : UIImageView {
	id delegate;
	int	wedgeNum;
}

@property (assign) id delegate;
@property int wedgeNum;

@end
