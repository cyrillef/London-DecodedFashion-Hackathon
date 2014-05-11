//
//  AdskDetailViewController.h
//  AllSaints
//
//  Created by Adam Nagy on 10/05/2014.
//  Copyright (c) 2014 Adam Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdskDetailViewController : UIViewController <UISplitViewControllerDelegate, UIImagePickerControllerDelegate> {
UIImageView *resultImage ;
UITextView *resultText ;
}

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *theDescription;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *theText;
@property (weak, nonatomic) IBOutlet UIImageView *theImage;

@property (nonatomic, retain) IBOutlet UIImageView *resultImage ;
@property (nonatomic, retain) IBOutlet UITextView *resultText ;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
