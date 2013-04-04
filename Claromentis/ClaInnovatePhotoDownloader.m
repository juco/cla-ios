//
//  ClaInnovatePhotoDownloader.m
//  Claromentis
//
//  Created by Julian Cohen on 11/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaInnovatePhotoDownloader.h"
#import "ClaInnovateComment.h"

@interface ClaInnovatePhotoDownloader () <NSURLConnectionDataDelegate>

@end

@implementation ClaInnovatePhotoDownloader

@synthesize model = _model;
@synthesize indexPath = _indexPath;
@synthesize delegate = _delegate;
@synthesize activeDownload = _activeDownload;
@synthesize connection = _connection;

- (void)startDownload {
    self.activeDownload = [NSMutableData data];
    self.connection = [[NSURLConnection alloc] initWithRequest:
                           [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://codedev2.claromentis.com/appdata/people/%d.jpg", (int)self.model.userID]]] delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed to download photo with error: %@", error);
    self.connection = nil;
    self.activeDownload = nil;
    // TODO Handle me properly
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [UIImage imageWithData:self.activeDownload];
    self.model.userPhoto = image;
    [self.delegate photoDidDownload:image forIndexPath:self.indexPath];
}

@end
