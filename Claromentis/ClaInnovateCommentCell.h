//
//  ClaInnovateCommentCell.h
//  Claromentis
//
//  Created by Julian Cohen on 14/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClaInnovateComment;

@interface ClaInnovateCommentCell : UITableViewCell

@property (strong, nonatomic)ClaInnovateComment *comment;

- (void)drawWithComment:(ClaInnovateComment *)comment forTableView:(UITableView *)tableView;

@end
