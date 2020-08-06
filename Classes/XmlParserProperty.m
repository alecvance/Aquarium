//
//  XmlParserBDTMDList.m
//  Blu Fire
//
//  Created by scott bates on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "XmlParserProperty.h"
#import "XmlParserBase.h"


@implementation XmlParserProperty
@synthesize itemNodeName;


- (id)initWithNodeName:(NSString *)nodeName {
    self = [super init];
	if(self !=nil){
		//do stuff
		itemNodeName = nodeName;
	}
	return self;
}

- (id)init{
    self = [super init];
	if(self !=nil){
		//do stuff
		itemNodeName = (NSString *)@"item";
	}
	return self;
}

- (void)setDelegate:(id)sender
{
	_delegate = sender;
}

- (id)delegate{
	return _delegate;
}

- (void)parseXMLFileAtURL:(NSString *)URL
{	
	//you must then convert the path to a proper NSURL or it won't work
	[self startParser:[NSURL URLWithString:URL]];
}

- (void)parseLocalXMLFile:(NSString *)path
{		
    //you must then convert the path to a proper NSURL or it won't work
	[self startParser:[NSURL fileURLWithPath:path]];
}

- (void)startParser:(NSURL *)xmlURL
{	
	items = [[NSMutableArray alloc] init];
	
	foundChild = NO;
	inParent = NO;
	//NSLog(@"url was: %@", xmlURL);
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [xmlParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
	
    [xmlParser parse];
	
}

- (void)parseXMLFromData:(NSData *)data {
	items = [[NSMutableArray alloc] init];
	foundChild = NO;
	inParent = NO;
	xmlParser = [[NSXMLParser alloc] initWithData:data];
	[xmlParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
	
    [xmlParser parse];
	//[xmlParser release];
	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"(Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[_delegate xmlParserDoneWithError:(NSError *)parseError];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	currentString = [[NSMutableString alloc] init];
	if ([elementName isEqualToString:itemNodeName]) {
		item = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:itemNodeName]) {
			[items addObject:[item copy]];
			inParent = NO;
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	[currentString appendString:string];	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"items array has %d items", [items count]);
	[items retain];
	[_delegate xmlParserPropertyDone:[items copy]];
	[items release];
}

/*
 //removing dealloc becuase I wrap the alloc of the parser objec tin an autorelease pool
 - (void)dealloc {
 [xmlParser release];
 [item release];
 [currentString release];
 [items release];
 [super dealloc];
 }
 */

@end