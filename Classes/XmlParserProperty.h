//
//  XmlParserBDTMDList.h
//  Blu Fire
//
//  Created by scott bates on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XmlParserProperty : NSObject <NSXMLParserDelegate>{
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
@interface NSObject (XmlParserPropertyDelegateEventAdditions)
- (void)xmlParserPropertyDone:(NSMutableArray *)items;
- (void)xmlParserPropertyDoneWithError:(NSError *)parseError;

@end

