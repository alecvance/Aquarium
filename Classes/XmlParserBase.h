//
//  XmlParserBase.h
//  
//
//  Created by scott bates on 10/16/08.
//  Copyright 2008 Scott bates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface XmlParserBase : NSObject<NSXMLParserDelegate> {
	NSMutableDictionary * item;
	NSMutableArray * items;
	NSString * currentElement;
	NSMutableString * currentString;
	NSXMLParser * xmlParser;
	NSString * itemNodeName;
	BOOL inParent;
	BOOL foundChild;
@private
    id _delegate;
}

@property (nonatomic, retain) NSString * itemNodeName;
- (id)initWithNodeName:(NSString *)nodeName;

// delegate management. The delegate is not retained.
- (id)delegate;
- (void)setDelegate:(id)delegate;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)parseLocalXMLFile:(NSString *)path;
- (void)startParser:(NSURL *)xmlURL;
- (void)parseXMLFromData:(NSData *)data;
@end

// The parser's delegate is informed of events through the methods in the NSXMLParserDelegateEventAdditions category.
@interface NSObject (XmlParserDelegateEventAdditions)
	- (void)xmlParserDone:(NSMutableArray *)items;
	- (void)xmlParserDoneWithError:(NSError *)parseError;

@end
