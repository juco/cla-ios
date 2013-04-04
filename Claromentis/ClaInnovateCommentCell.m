//
//  ClaInnovateCommentCell.m
//  Claromentis
//
//  Created by Julian Cohen on 14/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaInnovateCommentCell.h"
#import "ClaInnovateComment.h"
#import "NSString_stripHtml.h"

#define kProfileImageTag 1
#define kUsernameLabelTag 2
#define kTimestampLabelTag 3
#define kReplyCountLabelTag 5
#define kLikeCoutLabelTag 4
#define kUserPhotoTag 6

@implementation ClaInnovateCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawWithComment:(ClaInnovateComment *)comment forTableView:(UITableView *)tableView {
    // Keep a copy of this
    self.comment = comment;
    
    // Username label
    UILabel *userNameLabel = (UILabel *)[self viewWithTag:kUsernameLabelTag];
    userNameLabel.text = comment.userName;
    
    // Timestamp label
    UILabel *timestampLabel = (UILabel *)[self viewWithTag:kTimestampLabelTag];
    timestampLabel.text = comment.when;
    
    // Comment label
    UILabel *commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + 80.0, self.frame.origin.y + 51.0, 227, 300.0)];
    commentTextLabel.font = [UIFont systemFontOfSize:14.0];
    commentTextLabel.text = [comment.commentText stripHtml];
    commentTextLabel.numberOfLines = 0;
    commentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [commentTextLabel sizeToFit];
    [tableView addSubview:commentTextLabel];
    
    // Reply count label
    UILabel *replyLabel = (UILabel *)[self viewWithTag:kReplyCountLabelTag];
    replyLabel.text = [NSString stringWithFormat:@"%d replies", (int)comment.replyCount];
    
    // Like count label
    UILabel *likeLabel = (UILabel  *)[self viewWithTag:kLikeCoutLabelTag];
    likeLabel.text = [NSString stringWithFormat:@"%d likes", (int)comment.likeCount];
    
    // User photos
    UIImageView *photoView = (UIImageView *)[self viewWithTag:kUserPhotoTag];
    if(!comment.userPhoto) {
        photoView.image = [UIImage imageNamed:@"no_photo.jpg"];
    } else {
        photoView.image = comment.userPhoto;
    }
}

@end
