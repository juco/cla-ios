//
//  ClaNetworkController.m
//  Claromentis
//
//  Created by Julian Cohen on 07/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaNetworkController.h"
#import "SBJson.h"
#import "Remote.h"
#import "ClaRemotesController.h"

@interface ClaNetworkController () <SBJsonStreamParserAdapterDelegate>

- (void)initRequest:(NSURL *)url;

@end

@implementation ClaNetworkController

@synthesize delegate = _delegate;
@synthesize results = _results;
@synthesize connection = _connection;
@synthesize parser = _parser;
@synthesize adapter = _adapter;
@synthesize remote = _remote;

- (id)initWithPath:(NSString *)path {
    self = [super init];
    if(self) {
        
        // Init the adapter
        self.adapter = [[SBJsonStreamParserAdapter alloc] init];
        self.adapter.delegate = self;
        
        // Init the parser
        self.parser = [[SBJsonStreamParser alloc] init];
        self.parser.delegate = self.adapter;
        self.parser.supportMultipleDocuments = YES;
        
        self.remote = [[[ClaRemotesController alloc] init] activeRemote];
        // TODO: Handle this!!
        if(self.remote == nil) {
            NSLog(@"Active Remote is nil!!! Handle this");
            exit(-1);
        }
        
        // Contruct the URL
        NSLog(@"init URL request %@", [NSString stringWithFormat:@"http://%@%@", self.remote.hostname, path]);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", self.remote.hostname, path]];
        [self initRequest:url];
    }
    return self;
}

- (void)initRequest:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark SBJson Delegates
- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
    [self.delegate receivedArray:array];
}

- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
    [self.delegate receivedObject:dict];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSURLCredential *credential = [NSURLCredential credentialWithUser:@"julian" password:@"Cl4r0b4by" persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // TODO: Implement delegate methods here
    NSLog(@"Did failed with error %@", error);
    [self.delegate networkControllerDidFailWithError:error];
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Parse the data for handling by SBJson delegates
    [self.parser parse:data];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"Authentication challenge cancelled");
}

@end
