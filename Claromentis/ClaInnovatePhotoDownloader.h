//
//  ClaInnovatePhotoDownloader.h
//  Claromentis
//
//  Created by Julian Cohen on 11/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClaInnovateObjectModel.h"

@class ClaInnovateComment;
@protocol ClaInnovatePhotoDelegate;

@interface ClaInnovatePhotoDownloader : NSObject

@property (nonatomic, strong) ClaInnovateObjectModel *model;
@property (nonatomic, weak) id<ClaInnovatePhotoDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *connection;

- (void)startDownload;

@end

@protocol ClaInnovatePhotoDelegate

@required
- (void)photoDidDownload:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath;

@end