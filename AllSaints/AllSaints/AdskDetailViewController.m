//
//  AdskDetailViewController.m
//  AllSaints
//
//  Created by Adam Nagy on 10/05/2014.
//  Copyright (c) 2014 Adam Nagy. All rights reserved.
//

#import "AdskDetailViewController.h"
#import "AdskMasterViewController.h"

@interface AdskDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation AdskDetailViewController

@synthesize resultImage ;
@synthesize resultText ;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem) {
  

AdskData * data = self.detailItem;
data.descr = [AdskMasterViewController getProperty:data.ean name:@"description"];
 [self.theDescription loadHTMLString:data.descr baseURL:nil];
 self.theImage.contentMode = UIViewContentModeScaleAspectFit;
 self.theImage.image = data.image;
 self.theText.text = [NSString stringWithFormat:@"%@, %@, \n%@, \n%@", data.name, data.color, data.size, data.price];
  
  self.navigationController.toolbarHidden = false;

  UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]
   //initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
   initWithImage:[UIImage imageNamed:@"CameraIcon.png"]
   style:UIBarButtonItemStylePlain
   target:self
   action:@selector(email_clicked:)];

  NSArray *buttonArray = [NSArray arrayWithObjects:scanButton, nil];
  self.toolbarItems = buttonArray;

      //self.detailDescriptionLabel.text = [self.detailItem description];
  }
}

- (void)email_clicked:(id)sender
{
  [self takePhotoTapped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}




// Image Picking

- (IBAction)takePhotoTapped {
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init] ;
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera] ;
    else
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary] ;
    [imagePicker setDelegate:self] ;
    [self presentViewController:imagePicker animated:YES completion:nil] ;
}

- (void)photoPickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil] ;
	
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage] ;
	UIImage *allSaints =[UIImage imageNamed:@"allsaints.png"] ;
	CGSize newSize =CGSizeMake (image.size.width, image.size.height) ;
	//UIFont *font =[UIFont boldSystemFontOfSize:182] ;
	UIFont *font =[UIFont fontWithName:@"Times New Roman" size:96] ;
	double f =image.size.width / allSaints.size.width ;
	CGSize allsaintsSize =CGSizeMake (image.size.width, allSaints.size.height * f) ;

	UIGraphicsBeginImageContext (newSize) ;
	
	[image drawInRect:CGRectMake (0, 0, newSize.width, newSize.height)] ;

	//[[UIColor whiteColor] set] ;
	CGContextRef context =UIGraphicsGetCurrentContext () ;
	CGContextSetRGBStrokeColor (context, 1.0, 1.0, 1.0, 0.8) ;
	CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, 0.8) ;
	CGContextFillRect (context, CGRectMake (0.0, newSize.height - 2 * allsaintsSize.height, newSize.width, 2 * allsaintsSize.height)) ;

	[allSaints drawInRect:CGRectMake (0, newSize.height - allsaintsSize.height, newSize.width, allsaintsSize.height) blendMode:kCGBlendModeNormal alpha:0.8] ;

	NSMutableParagraphStyle *style =[[NSParagraphStyle defaultParagraphStyle] mutableCopy] ;
	[style setAlignment:NSTextAlignmentRight] ; // NSRightTextAlignment
	NSMutableDictionary *attributesRight = [NSMutableDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName] ;
	[attributesRight removeObjectForKey:NSStrokeWidthAttributeName] ;
	[attributesRight removeObjectForKey:NSStrokeColorAttributeName] ;
	[attributesRight setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName] ;

	NSMutableDictionary *attributes =[[NSMutableDictionary alloc] init] ;
	[attributes setObject:font forKey:NSFontAttributeName] ;
	//[attributes setObject:[NSNumber numberWithFloat:4] forKey:NSStrokeWidthAttributeName] ;
	//[attributes setObject:[UIColor blackColor] forKey:NSStrokeColorAttributeName] ;
	[attributes removeObjectForKey:NSStrokeWidthAttributeName] ;
	[attributes removeObjectForKey:NSStrokeColorAttributeName] ;
	[attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName] ;

	CGRect rect =CGRectMake (0, newSize.height - 2 * allsaintsSize.height, newSize.width, allsaintsSize.height) ;
	AdskData *data =(AdskData *)_detailItem ;
	[data.name drawInRect:rect withAttributes:attributes] ;
	rect =CGRectMake (newSize.width / 2.0, newSize.height - 2 * allsaintsSize.height, newSize.width / 2.0, allsaintsSize.height) ;
	//[@"Size 6" drawInRect:rect withAttributes:attributesRight] ;
	[data.size drawInRect:rect withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight] ;
	rect =CGRectMake (0, newSize.height - 1.5 * allsaintsSize.height, newSize.width, allsaintsSize.height) ;
	[data.color drawInRect:rect withAttributes:attributes] ;
	rect =CGRectMake (newSize.width / 2.0, newSize.height - 1.5 * allsaintsSize.height, newSize.width / 2.0, allsaintsSize.height) ;
	//[@"Price" drawInRect:rect withAttributes:attributesRight] ;
	[data.price drawInRect:rect withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight] ;

	UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext () ;
	UIGraphicsEndImageContext () ;
	
    //resultImage.image =newImage ;
	data.extraImage =newImage ;
	self.extraImage.image =newImage ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
		[self photoPickerController:picker didFinishPickingMediaWithInfo:info] ;
}


@end
