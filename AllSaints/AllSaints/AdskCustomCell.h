//
//  AdskCustomCell.h
//  AllSaints
//
//  Created by Adam Nagy on 10/05/2014.
//  Copyright (c) 2014 Adam Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdskCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *theImage;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UILabel *theColor;
@property (weak, nonatomic) IBOutlet UILabel *theSize;
@property (weak, nonatomic) IBOutlet UILabel *thePrice;
@end
