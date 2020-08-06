//
//  CustomAudioCell.h
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomAudioCell : UITableViewCell {
	IBOutlet UILabel *primaryLabel;
	IBOutlet UILabel *secondaryLabel;
	
}

@property (nonatomic, assign) UILabel *primaryLabel;
@property (nonatomic, assign) UILabel *secondaryLabel;

@end
