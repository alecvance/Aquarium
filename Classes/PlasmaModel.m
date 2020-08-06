//
//  PlasmaModel.m
//  Squadron
//
//  Created by Alec Vance on 8/16/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "PlasmaModel.h"
#import "Constants.h"
#import "ArcWedge.h"

@implementation PlasmaModel

@synthesize sprites, blocks, wedges, wheelShadow, state;
@synthesize deadSprites, time;
@synthesize palette;//, monoPalettes; //wheelPalettes
//@synthesize wheelNum;

- (void) dealloc {
	[palette release];
	//[wheelPalettes release];
	//[monoPalettes release];
	
	[sprites release];
	[blocks release];
	[wedges release];
	[wheelShadow release];
	
	[deadSprites release];
	//[newSprites release];
	
	[state release];
	[super dealloc];
	
}

#pragma mark game state
/*
+ (PlasmaModel *) sharedModel
{
	static PlasmaModel *sharedInstance;
	
	@synchronized(self)
	{
		if (!sharedInstance)
			sharedInstance = [[PlasmaModel alloc] init];
		
		return sharedInstance;
	}
	return sharedInstance;
}

+ (int) getState: (NSString *) indicator 
{
	PlasmaModel *model = [PlasmaModel sharedModel]; 
	if (model.state == nil) model.state = [[NSMutableDictionary alloc] init];
	NSNumber *n = [model.state objectForKey: indicator];
	if (n) {
		return [n intValue];
	}
	return kUnknown;
}

+ (void) setState: (NSString *) indicator to: (int) val
{
	PlasmaModel *model = [PlasmaModel sharedModel];
	if (model.state == nil) model.state = [[NSMutableDictionary alloc] init];
	NSNumber *n = [NSNumber numberWithInt: val];
	[model.state setObject: n forKey: indicator];
}
*/

#pragma mark model methods

- (id) initWithPalette:(ColorModel *)_palette;
{
	self = [super init];
	if (self) {
		state = [[NSMutableDictionary alloc] init];
		sprites = [[NSMutableArray alloc] init];
		blocks = [[NSMutableArray alloc] init];
		wedges = [[NSMutableArray alloc] init];
		
		deadSprites = [[NSMutableArray alloc] init];
		//newSprites = [[NSMutableArray alloc] init];
		state = [[NSMutableDictionary alloc] init];
		/*
		wheelNum = 0;
		
		ColorModel *wheelPalette1 = [[ColorModel alloc] initWithHexValues: 
									 [NSArray arrayWithObjects: @"d9e020",@"3cbded",@"3E5DA9",@"D9529C",@"F27B82",nil]];
		
		ColorModel *wheelPalette2 = [[ColorModel alloc] initWithHexValues: 
									 [NSArray arrayWithObjects: @"EF5A28",@"EB297B",@"800000",@"2B388E",@"00ACED",@"009245",nil]];
		
		wheelPalettes = [[NSArray alloc] initWithObjects: wheelPalette1, wheelPalette2, nil];
		*/
		
		//fingers = [[NSMutableDictionary alloc] init];
		
		self.palette = _palette;
		/*
		self.palette = [[ColorModel alloc] initWithHexValues: [NSArray arrayWithObjects:
		  @"DAE120", @"E5E72F", @"CDE14A", @"B5DB66", @"9CD681", @"84D09C", @"6CCAB8", @"54C4D3",
		  @"3CBEEE", @"3CB2E6", @"3CA6DD", @"3D9AD4", @"3D8ECC", @"3D81C3", @"3E66B0", @"3E62AD",
		  @"3E5DAA", @"515CA8", @"655AA7", @"7859A5", @"8B58A3", @"9F57A2", @"B256A0", @"C6549F",
		  @"D9539D", @"DC589A", @"E05D96", @"E36293", @"E66790", @"E96C8D", @"EC718A", @"F07686",
		  @"F37B83", @"F48975", @"F59867", @"F7A659", @"F8B44B", @"F9C23E", @"FBD030", @"FCDF22",
		  nil]];
	  
		
		ColorModel *palette2 = [[ColorModel alloc] initWithHexValues: [NSArray arrayWithObjects:
		   @"9CC8DB", @"89B6CA", @"75A5BA", @"6293A9", @"4E8298", @"3B7087", @"275F76", @"134D66",
		   @"003C55", @"004765", @"005275", @"005D85", @"006895", @"0074A5", @"007FB5", @"008AC5",
		   @"0095D5", @"038BC5", @"0681B5", @"0A77A5", @"0D6D95", @"106285", @"145875", @"174E65",
		   @"1A4455", @"174A5F", @"144F68", @"105572", @"0D5A7B", @"0A6085", @"06668F", @"036B98",
		   @"0071A2", @"147ca9", @"2787B0", @"3b92b7", @"4e9cbe", @"62a7c6", @"75b2cd", @"89bdd4",
		   nil]];
		
		
		monoPalettes = [[NSArray alloc] initWithObjects: 
						[[ColorModel alloc] initWithRangeFrom:@"EFEFEF" to: @"EF5A28"],
						[[ColorModel alloc] initWithRangeFrom:@"EBEBEB" to: @"EB297B"], 
						[[ColorModel alloc] initWithRangeFrom:@"808080" to: @"800000"],
						[[ColorModel alloc] initWithRangeFrom:@"8E8E8E" to: @"2B388E"],
						[[ColorModel alloc] initWithRangeFrom:@"EDEDED" to: @"00ACED"],
						[[ColorModel alloc] initWithRangeFrom:@"929292" to: @"009245"],
						nil
						];
	*/		
		
		time = 0;
		[self addObjects];
	}
	return self;
}

- (void) kill: (Sprite *) s
{
	[deadSprites addObject: s];
}

- (void) removeDeadSprites // aka unleashGrimReaper
{
	int count = [deadSprites count];
	if (count > 0) {
		printf("Reaping %d sprites\n",count);
		[sprites removeObjectsInArray: deadSprites];
		
		[deadSprites removeAllObjects];
	}
}

- (void) initState
{
	// [PlasmaModel setState: kScore to:0]; //etc
}

#pragma mark Blocks


- (PlasmaBlock *) randomBlock
{
	PlasmaBlock *block;
	
	block = [[[PlasmaBlock alloc] init] autorelease];
	
	block.width = 20;
	block.height = 20;
	block.wrap = YES;
	
	block.x = RANDOM_INT(0,kScreenWidth-1) - kScreenWidth/2;
	block.y = RANDOM_INT(0,kScreenHeight-1) -kScreenHeight/2;
	block.r = RANDOM_INT(0,100)/100.0;
	block.g = RANDOM_INT(0,100)/100.0;
	block.b = RANDOM_INT(0,100)/100.0;
	block.alpha = RANDOM_INT(0,100)/100.0;// 0.25;
	//block.scale = (1900-i)/1900.0; // 0-25%
	//block.rotation = RANDOM_INT(0,90); // 0-90
	block.speed = RANDOM_INT(0,100)/2.0 + 4.0;
	block.angle = 90;
	//block.angle = RANDOM_INT(0,359);
	block.spinSpeed = 0.4 *100;
	
	//[block updateBox]; // needed?
		
//	[block retain];
	
	return block;

}


- (void) addSprite: (Sprite *) sprite
{
	[sprites addObject: sprite];	
}

- (void) addBlock: (PlasmaBlock *) block
{
	[blocks addObject: block];	
}

- (void) addWedge: (ArcWedge *) sprite
{
	[wedges addObject: sprite];	
	[self addSprite: sprite];
}


#pragma mark Blocks

- (void) makeBlocks
{
	
	float blockSize = kBlockSize; 
	
	float xPos = 0 - kScreenWidth/2; // middle of screen
	float yPos = 0 - kScreenHeight/2; // middle of screen
	int blockCount = 0;
	
	int maxRows = kScreenHeight / blockSize + 0.5;// round up	
	int maxColumns = kScreenWidth / blockSize + 0.5;
	
	//blocks = [NSMutableArray arrayWithCapacity:maxRows];
	
	
	for (int row=0; row<maxRows; row++) {
	//	NSMutableArray *thisRow = [NSMutableArray arrayWithCapacity: maxColumns];
		for (int i=0; i<maxColumns; i++) {
			PlasmaBlock *block = [[PlasmaBlock alloc] init];
			block.width = blockSize;
			block.height = blockSize;
			//block.alpha = RANDOM_INT(0,100)/100.0;// 0.25;
			
			//PlasmaBlock *block = [self randomBlock];

			block.x = xPos + i*blockSize + blockSize/2; // the + blockSize/2 is because regPt is @ center of sprite
			block.y = yPos + row*blockSize + blockSize/2;
			
			block.palette = self.palette;
			//block.palette = self.palette2;
			
			[block setColorToIndex: i];
			[block updateBox];

			
			block.blockNum = blockCount++; 
			[self addSprite: block];
			[self addBlock: block];
            
            [block release];
			
		//	[thisRow addObject:block];
		}
		
		//[blocks addObject:thisRow];
	}
	
}

/*
- (void) makeVectorWheelController{
	ColorModel *wheelPalette = [wheelPalettes objectAtIndex:wheelNum];
	[self makeVectorWheelControllerWithPalette: wheelPalette];

};
 */

- (void) makeVectorWheelControllerWithPalette:(ColorModel *)wheelPalette{
	
	CGFloat pieX = kWheelControllerX;
	CGFloat pieY = kWheelControllerY;
	CGFloat pieRadius = kWheelRadius;
	
	//ColorModel *wheelPalette = [wheelPalettes objectAtIndex:wheelNum];
	int numPieces = [wheelPalette.colors count]; // the number of colors in the wheel palette is the number of wedges
	CGFloat wedgeArcSize = 360.0/numPieces;
	
	for (int i = 0; i<numPieces; i++) {
		ArcWedge *wedge = [[ArcWedge alloc] init];
		wedge.pieceNum = i;
		
		wedge.radius = pieRadius;
		wedge.rotation = -90.0 - wedgeArcSize/2.0;  // puts wedge 0 centered at top.
		wedge.spinTo = wedge.rotation;
		
		wedge.startAngle = 0.0  + (wedgeArcSize * i ) ;
		wedge.arcTheta = wedgeArcSize +.5 ;
		
		wedge.x = pieX;
		wedge.y = pieY;
		
		//	wedge.r = 0.1 + (0.15 * i);
		//		wedge.g = 0;
		//		wedge.b = 0;
		wedge.alpha = .95;
		
		wedge.palette = wheelPalette;
		[wedge setColorToIndex: i];
		//NSLog(@"wedge color is %@", [wedge colorAsRGBString]);
		wedge.spinSpeed = 0.5 *100;
		
		[self addWedge: wedge];
        [wedge release];
	}
	
	if(! wheelShadow){
		wheelShadow = [[ArcWedge alloc] init];
		wheelShadow.radius = pieRadius + 1.5;
		//wheelShadow.rotation = -90.0 - wedgeArcSize/2.0;  // puts wedge 0 centered at top.
		//wheelShadow.spinTo = wedge.rotation;
		
		wheelShadow.startAngle = 0.0 ;
		wheelShadow.arcTheta = 360.0 ;
		
		wheelShadow.x = pieX + 2.5;
		wheelShadow.y = pieY + 2.5;
		
		wheelShadow.r = 0.0;
		wheelShadow.g = 0.0;
		wheelShadow.b = 0.0;
		wheelShadow.alpha = .15;
		
		
		
	}
	
	[self addSprite: wheelShadow];
}

- (void) removeVectorWheelController{
	for (ArcWedge *wedge in wedges){
		[self kill:wedge];
	}
	[wedges removeAllObjects];
	[self removeDeadSprites];
}

- (ArcWedge*) wedgeAtAngle: (CGFloat)theta{
	
	if (theta<0) {
		theta=theta+360;
	}
	
	for (int tries=0; tries<2; tries++) {
		//NSLog(@"wedgeNumAtAngle(%f) ==> Try#%i", theta, tries);
		
		CGFloat offset = tries * 360; 
		for(ArcWedge *wedge in wedges){
			
			CGFloat a1 = wedge.startAngle + wedge.rotation +360;
			if(a1>360.0) a1 = a1-360.0;
			
			CGFloat a2 = a1 + wedge.arcTheta;
			
			//NSLog(@"(theta=%f) wedge#%i: a1=%f  a2=%f (rot=%f)", theta, wedge.pieceNum, a1, a2,wedge.rotation);
			
			if ((a1 <= theta+offset) && (theta+offset <= a2 )) {
				return wedge;
			}
		}
	}
	
	return nil; // this is an error and should never happen.
}

- (void) addObjects
{
	
	//make plasma bg
	[self makeBlocks];
		
	//make pie shape/pieces
	//[self makeVectorWheelController];
	
	

}

/*
- (void) flipWheel
{
	wheelNum = 1 - wheelNum;
	[self removeVectorWheelController];
	[self makeVectorWheelController];
	
	ColorModel *newPalette;
	if (wheelNum == 0) {
		newPalette	= palette;
	}else {
		newPalette = [monoPalettes objectAtIndex:0]; // should be set to whatever chapter we're on, along with the wheel
	}

	for(PlasmaBlock *block in blocks){
		[block setPalette: newPalette];
	}
}
*/

-(void)setPalette:(ColorModel *)newPalette{
	palette = newPalette;
	for(PlasmaBlock *block in blocks){
		[block setPalette: newPalette];
	}
	
}

-(void) replaceWheelForColorsInPalette:(ColorModel *)newPalette{
	[self removeVectorWheelController];
	[self makeVectorWheelControllerWithPalette:newPalette];
	
	/*ColorModel *newPalette;
	if (wheelNum == 0) {
		newPalette	= palette;
	}else {
		newPalette = [monoPalettes objectAtIndex:0]; // should be set to whatever chapter we're on, along with the wheel
	}
	
	for(PlasmaBlock *block in blocks){
		[block setPalette: newPalette];
	}
	*/
}




// Only do this if we are using wheel #1
/*
-(void)switchToMonochromePalette:(int)paletteNum{
	//if(wheelNum==1){
		ColorModel *newPalette = [monoPalettes objectAtIndex:paletteNum];
		for(PlasmaBlock *block in blocks){
			[block setPalette: newPalette];
		}
	//}
	
}
 */
@end
