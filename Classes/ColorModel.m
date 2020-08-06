//
//  ColorModel.m
//  Aquarium
//
//  Created by Alec Vance on 9/14/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "ColorModel.h"
#import "UIColor-Expanded.h"

@implementation ColorModel

@synthesize colors, unidirectional;

- (ColorModel*) initWithHexValues:(NSArray *)hexValues {
	
	if (self = [super init]) {
		
		unidirectional = NO;
		
		// rows: yellow, light blue, dark blue, dark pink, light pink
		/*
		NSArray *hexValues = [NSArray arrayWithObjects:
				  @"d9e020", @"e1e74c", @"e9ed79",
				  @"afe5f9", @"88d9f5", @"3cbded",
				  @"3e5da9", @"8b9ecc", @"b1bedd",
				  @"e997c5", @"e274b1", @"d9529c",
				  @"f37b83", @"f59397", @"f8adad", 
				  nil];
		 */
		
		/*
		NSArray *hexValues = [NSArray arrayWithObjects:
		 @"DAE120", @"E5E72F", @"CDE14A", @"B5DB66", @"9CD681", @"84D09C", @"6CCAB8", @"54C4D3",
		 @"3CBEEE", @"3CB2E6", @"3CA6DD", @"3D9AD4", @"3D8ECC", @"3D81C3", @"3E66B0", @"3E62AD",
		 @"3E5DAA", @"515CA8", @"655AA7", @"7859A5", @"8B58A3", @"9F57A2", @"B256A0", @"C6549F",
		 @"D9539D", @"DC589A", @"E05D96", @"E36293", @"E66790", @"E96C8D", @"EC718A", @"F07686",
		 @"F37B83", @"F48975", @"F59867", @"F7A659", @"F8B44B", @"F9C23E", @"FBD030", @"FCDF22",
							  nil];
		*/
		[self setPaletteColorsFromHexValues: hexValues];
	
	}
	
	
	return self;
}

- (ColorModel*) initWithRangeFrom:(NSString *)fromValue to:(NSString *)toValue{	
	if (self = [super init]) {
		
		unidirectional = YES;
		
		int numLevels = 20; // should be a parameter
		
		// add initial components
		
		UIColor *c1 = [UIColor colorWithHexString:fromValue];
		UIColor *c2 = [UIColor colorWithHexString:toValue];
		
		//make rest of array
		double stepR = (c2.red - c1.red ) / numLevels;
		double stepG = (c2.green - c1.green ) / numLevels;
		double stepB = (c2.blue - c1.blue ) / numLevels;
		
		//create array with first color
		NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:c1,nil];

		// do everything but the first and last color
		for (int i=1; i<numLevels-1; i++) {
			UIColor *mixMidColor = [UIColor colorWithRed:(c1.red + stepR * i)
												   green:(c1.green + stepG * i) 
													blue:(c1.blue + stepB * i) alpha:1.0];
			[tempArray addObject: mixMidColor];
			
		}
		
		//add last color
		[tempArray addObject:c2];
		
		colors = [[NSArray alloc] initWithArray: tempArray];
		
		//NSLog(@"Generated dynamic palette with %i colors", [colors count]);
		
		//[colors retain];
		
	}
		
	return self;
}
 
/*
 - (ColorModel*) initWithRangeFrom:(NSString *)fromValue to:(NSString *)toValue{	
 if (self = [super init]) {
 
 // add initial components
 colors = [[NSArray alloc] initWithObjects: 
 [UIColor colorWithHexString:fromValue],
 [UIColor colorWithHexString:toValue], nil];
 
 //make rest of array

 for(int levels= 0; levels<5; levels++){
 NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:[colors objectAtIndex:0],nil];
 
 for (int i=0; i<colors.count-1; i++) {
 UIColor *c1 = [colors objectAtIndex:i];
 UIColor *c2 = [colors objectAtIndex:i+1];
 UIColor *mixMidColor = [c1 colorByMixingWithColor:c2];
 [tempArray addObject: mixMidColor];
 [tempArray addObject:c2];
 }
 colors = [NSArray arrayWithArray: tempArray];
 }
 }
 
 NSLog(@"Generated dynamic palette with %i colors", [colors count]);
 [colors retain];
 
 return self;
 }
*/
 
-(void)setPaletteColorsFromHexValues:(NSArray *)hexValues{
	NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[hexValues count]];
	colors = [[NSMutableArray alloc] init];
	
	//UIColor *lastColor = nil;
	
	for(NSString *hexValue in hexValues){
		UIColor *newColor = [UIColor colorWithHexString:hexValue];
		/*
		 if (lastColor!=nil) {
		 UIColor *mixMidColor = [newColor colorByMixingWithColor:lastColor];
		 UIColor *mixLoColor = [mixMidColor colorByMixingWithColor:lastColor];
		 UIColor *mixHiColor = [mixMidColor colorByMixingWithColor:newColor];
		 
		 [tempArray addObject: mixLoColor];
		 [tempArray addObject: mixMidColor];
		 [tempArray addObject: mixHiColor];
		 }
		 */
		[tempArray addObject: newColor];
		
		//lastColor = newColor;
		
	}
	
	
	
	
	colors = [[NSArray alloc] initWithArray: tempArray];
	//NSLog(@"Made palette with %i colors.",[colors count]);
	
}

- (UIColor *) getColorAtIndex:(int)index{
	
//	if (index>[colors count]-1) {
//		// fix out of bounds?
//		index = colors.count-1;
//	}
//	
	if (unidirectional) {
		index = index % ([colors count]*2);
		if (index> [colors count]-1){
			index = [colors count] -1 - (index % [colors count]);
		}
		//return [colors objectAtIndex: [colors count] - 1 - index];
		
	}else {
		// wrap (preferred)
		index = index % [colors count];
	}

	
	
	return [colors objectAtIndex: index];
}

-(void)dealloc{
	[colors release];
	[super dealloc];
}

@end
