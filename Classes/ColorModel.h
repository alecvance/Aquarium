//
//  ColorModel.h
//  Aquarium
//
//  Created by Alec Vance on 9/14/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ColorModel : NSObject {
	NSArray *colors;
	BOOL unidirectional; // if true, palette doesn't "wrap"
}

@property (nonatomic, retain) NSArray *colors;
@property (assign) BOOL unidirectional;

- (ColorModel*) initWithHexValues:(NSArray *)hexValues;
- (ColorModel*) initWithRangeFrom:(NSString *)fromValue to:(NSString *)toValue;
- (void)setPaletteColorsFromHexValues:(NSArray *)hexValues;
- (UIColor *) getColorAtIndex:(int)index;

@end
