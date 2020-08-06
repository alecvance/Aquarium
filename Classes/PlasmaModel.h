//
//  PlasmaModel.h
//  Squadron
//
//  Created by Alec Vance on 8/16/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "PlasmaBlock.h"
#import "ColorModel.h"
#import "ArcWedge.h"

@interface PlasmaModel : NSObject {
	NSMutableArray *sprites; // all sprites
	NSMutableArray *blocks; // 
	NSMutableArray *wedges; // 
	ArcWedge *wheelShadow;
	
	NSMutableArray *deadSprites;
	//NSMutableArray *newSprites;
		
	NSMutableDictionary *state;
	CGFloat time;
	
	ColorModel *palette;
	//NSArray *wheelPalettes;
	//NSArray *monoPalettes;
	
	//int wheelNum;
}

@property (nonatomic, retain) NSMutableDictionary *state;
@property (nonatomic, retain) NSMutableArray *sprites;
@property (nonatomic, retain) NSMutableArray *blocks;
@property (nonatomic, retain) NSMutableArray *wedges;
@property (nonatomic, retain) ArcWedge *wheelShadow;

@property (nonatomic, retain) NSMutableArray *deadSprites;
//@property (nonatomic, retain) NSMutableArray *newSprites;

@property (assign) CGFloat time;

@property (nonatomic, retain) ColorModel *palette;
//@property (nonatomic, retain) NSArray *wheelPalettes;
//@property (nonatomic, retain) NSArray *monoPalettes;

//@property (assign) int wheelNum;
- (id) initWithPalette:(ColorModel *)_palette;
//+ (int) getState: (NSString *) indicator;
//+ (void) setState: (NSString *) indicator to: (int) val;
- (void) kill: (Sprite *) s;
- (void) removeDeadSprites; // aka unleashGrimReaper
- (void) initState;
- (PlasmaBlock *) randomBlock;
- (void) addSprite: (Sprite *) sprite;
- (void) addBlock: (PlasmaBlock *) block;
- (void) addWedge: (ArcWedge *) sprite;
- (void) makeBlocks;
//- (void) makeVectorWheelController;
- (void) makeVectorWheelControllerWithPalette:(ColorModel *)wheelPalette;
- (void) removeVectorWheelController;
- (void) addObjects;
- (ArcWedge*) wedgeAtAngle: (CGFloat)theta;
//- (void) flipWheel;
-(void) replaceWheelForColorsInPalette:(ColorModel *)newPalette;
//-(void)switchToMonochromePalette:(int)paletteNum;
@end
