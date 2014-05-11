//
//  AdskMasterViewController.h
//  AllSaints
//
//  Created by Adam Nagy on 10/05/2014.
//  Copyright (c) 2014 Adam Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface AdskData : NSObject

@property (strong, nonatomic) NSString * ean;
@property (strong, nonatomic) NSString * color;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * descr;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * size;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) UIImage *  extraImage;

@end

@class AdskDetailViewController;

@interface AdskMasterViewController : UITableViewController<ZBarReaderDelegate> {
UITextView *resultText ;
UIImageView *resultImage ;
}

@property (nonatomic, retain) IBOutlet UITextView *resultText ;
@property (nonatomic, retain) IBOutlet UIImageView *resultImage ;
@property (strong, nonatomic) AdskDetailViewController *detailViewController;

+(NSString*)getProperty:(NSString*)ean name:(NSString*)name;
- (void)scanButtonTapped;

@end
