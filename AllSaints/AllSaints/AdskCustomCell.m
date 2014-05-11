//
//  AdskCustomCell.m
//  AllSaints
//
//  Created by Adam Nagy on 10/05/2014.
//  Copyright (c) 2014 Adam Nagy. All rights reserved.
//

#import "AdskCustomCell.h"

@implementation AdskCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTransitionToState:(UITableViewCellStateMask)state{
[super didTransitionToState:state];
if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
    for (UIView *subview1 in self.subviews)
    {
    NSLog(@"Class=%@", [[subview1 class] description]);
    for (UIView *subview in subview1.subviews) {
    NSLog(@"Class=%@", [[subview class] description]);
    if ([NSStringFromClass([subview class]) rangeOfString:@"Scroll"].location != NSNotFound) {
      CGRect rect = subview.frame;
      [subview setFrame:CGRectMake(rect.origin.x - 30, rect.origin.y, rect.size.width, rect.size.height)];
    }
if ([NSStringFromClass([subview class]) rangeOfString:@"Delete"].location != NSNotFound) {

/*
UIGraphicsBeginImageContext(subview.frame.size);
[[UIImage imageNamed:@"AppIcon.png"] drawInRect:CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height) ];//]subview.bounds];
UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();

subview.backgroundColor = [UIColor colorWithPatternImage:image];
*/

  
        UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height)];
        deleteBtn.contentMode = UIViewContentModeScaleToFill;
        [deleteBtn setImage:[UIImage imageNamed:@"DeleteIconSkull%402x.png"]];
         UIImageView *deleteBtn2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, subview.frame.size.width, subview.frame.size.height)];
        deleteBtn.contentMode = UIViewContentModeScaleToFill;
        [deleteBtn setImage:[UIImage imageNamed:@"DeleteIconSkull%402x.png"]];
        [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
         [[subview.subviews objectAtIndex:0] addSubview:deleteBtn2];
  
         break;

        
}
}
}
}
}

@end
