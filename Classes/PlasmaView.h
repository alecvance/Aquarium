//
//  PlasmaView.h
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sprite.h"
#import "PlasmaModel.h"


@interface PlasmaView : UIView {
	PlasmaModel *model;
	BOOL ready;

}

@property (nonatomic, retain) PlasmaModel *model;

- (void) useModel: (PlasmaModel *) model;
- (void) tic: (NSTimeInterval) dt;

@end
