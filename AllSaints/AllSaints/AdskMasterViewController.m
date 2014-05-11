//
//  AdskMasterViewController.m
//  AllSaints
//
//  Created by Adam Nagy on 10/05/2014.
//  Copyright (c) 2014 Adam Nagy. All rights reserved.
//

#import "AdskMasterViewController.h"

#import "AdskDetailViewController.h"

#import "AdskCustomCell.h"



@interface AdskData () {
  NSString * ean;
  NSString * color;
  NSString * name;
  NSString * descr;
  UIImage * image;
    UIImage * extraImage;
}
@end

@implementation AdskData

@synthesize ean;
@synthesize color;
@synthesize name;
@synthesize descr;
@synthesize price;
@synthesize size;
@synthesize image;
@synthesize extraImage;

@end

@interface AdskMasterViewController () {
    NSMutableArray *_objects;
    BOOL _editingFromEditButton;
}
@end

@implementation AdskMasterViewController

@synthesize resultText;
@synthesize resultImage ;

- (void)scanButtonTapped {
	// present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader =[[ZBarReaderViewController alloc] init] ;
    reader.readerDelegate = self ;
    reader.supportedOrientationsMask =ZBarOrientationMaskAll ;
	
	UIImage *scanImage =[UIImage imageNamed:@"scantarget.png"] ;
	UIImageView *myControlView =[[UIImageView alloc] initWithImage:scanImage] ;
	myControlView.contentMode =UIViewContentModeScaleAspectFit ;
	reader.cameraOverlayView =myControlView ;
	
    ZBarImageScanner *scanner =reader.scanner ;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0] ;
	
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil] ;
}


- (void)scanPickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // get the decode results
    id<NSFastEnumeration> results =[info objectForKey:ZBarReaderControllerResults] ;
    ZBarSymbol *symbol =nil ;
    for( symbol in results )
        // just grab the first barcode
        break ;
	
    // do something useful with the barcode data
    //resultText.text =symbol.data ;
	[_objects insertObject:[AdskMasterViewController getData:symbol.data] atIndex:0];
	[self.tableView reloadData] ;
	// do something useful with the barcode image
    //resultImage.image =[info objectForKey:UIImagePickerControllerOriginalImage] ;
	
    [reader dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self scanPickerController:picker didFinishPickingMediaWithInfo:info] ;
}

- (void)awakeFromNib
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      self.clearsSelectionOnViewWillAppear = NO;
      self.preferredContentSize = CGSizeMake(320.0, 600.0);
  }
    [super awakeFromNib];
}

+ (NSString*)getProperty:(NSString*)ean name:(NSString*)name
{
  NSMutableURLRequest * req = [[NSMutableURLRequest alloc]
    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.allsaints.com/v1/product/?ean=%@", ean]]];
  
      [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
  NSURLResponse * response;
  NSError * error = nil;
  NSData * result = [NSURLConnection
                     sendSynchronousRequest:req
                     returningResponse:&response
                     error:&error];
  
  if (error)
    return nil;
  
  NSDictionary * json = [NSJSONSerialization
                         JSONObjectWithData:result
                         options:kNilOptions
                         error:&error];




 return [[[[[json objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"products"] objectForKey:@"product"] objectForKey:name];
}

+ (NSString*)getPrice:(NSString*)url
{
  NSMutableURLRequest * req = [[NSMutableURLRequest alloc]
    initWithURL:[NSURL URLWithString:url]];
  
  //[req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
  NSURLResponse * response;
  NSError * error = nil;
  NSData * result = [NSURLConnection
                     sendSynchronousRequest:req
                     returningResponse:&response
                     error:&error];
  
  if (error)
    return nil;
  
  NSString * str = [[NSString alloc]
                  initWithData:result
                  encoding:NSUTF8StringEncoding];
  
  NSInteger loc1 = [str rangeOfString:@"<meta itemprop=\"price\" content=\""].location;
  NSInteger loc2 = [str rangeOfString:@"\"/>" options:NSCaseInsensitiveSearch range:NSMakeRange(loc1, str.length - loc1)].location;
  
  return [str substringWithRange:NSMakeRange(loc1 + 32, loc2 - loc1 - 32)];
}

+ (AdskData*)getData:(NSString*)ean
{
  // Request data
  
  AdskData * data = [AdskData alloc];
  
  data.ean = ean;
  
  NSMutableURLRequest * req = [[NSMutableURLRequest alloc]
    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.allsaints.com/v1/product/?ean=%@", ean]]];
  
      [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
  NSURLResponse * response;
  NSError * error = nil;
  NSData * result = [NSURLConnection
                     sendSynchronousRequest:req
                     returningResponse:&response
                     error:&error];
  
  if (error)
    return nil;
  
  NSDictionary * json = [NSJSONSerialization
                         JSONObjectWithData:result
                         options:kNilOptions
                         error:&error];



 /*NSString * s = [[NSString alloc]
                  initWithData:result
                  encoding:NSUTF8StringEncoding];
*/
 data.name = [[[[[json objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"products"] objectForKey:@"product"] objectForKey:@"style_name"];
 

 data.size = [[[[[json objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"products"] objectForKey:@"product"] objectForKey:@"size"];
 
 
 NSString * priceUrl = [[[[[json objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"products"] objectForKey:@"product"] objectForKey:@"url"];
 
 data.price = [AdskMasterViewController getPrice:priceUrl];
 
 data.color = [[[[[json objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"products"] objectForKey:@"product"] objectForKey:@"colour_name"];


NSString * imageUrl = [[[[[[json objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"products"] objectForKey:@"product"] objectForKey:@"image"] objectForKey:@"href"];

data.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]]];

return data;
}

- (void)viewDidLoad
{
// Some sample items ean's 5051214316987, 5051214452487, 5051214539133
if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[AdskMasterViewController getData:@"5051214316987"] atIndex:0];
    [_objects insertObject:[AdskMasterViewController getData:@"5051214452487"] atIndex:0];
    [_objects insertObject:[AdskMasterViewController getData:@"5051214539133"] atIndex:0];
  
  
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   //UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editObject:)];
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.detailViewController = (AdskDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
  
  self.navigationController.toolbarHidden = false;

// Profile
  UIBarButtonItem *profileButton = [[UIBarButtonItem alloc]
   //initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
   initWithImage:[UIImage imageNamed:@"Profile.png"]
   style:UIBarButtonItemStylePlain
   target:self
   action:@selector(email_clicked:)];
  
   UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
// Scan
  UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]
   //initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
   initWithImage:[UIImage imageNamed:@"ScanButton.png"]
   style:UIBarButtonItemStylePlain
   target:self
   action:@selector(email_clicked:)];

// Wishlist
  UIBarButtonItem *wishButton = [[UIBarButtonItem alloc]
   //initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
   initWithImage:[UIImage imageNamed:@"WishListIcon.png"]
   style:UIBarButtonItemStylePlain
   target:self
   action:@selector(email_clicked:)];


  NSArray *buttonArray = [NSArray arrayWithObjects: profileButton, flexibleSpace, scanButton, flexibleSpace, wishButton, nil];
  self.toolbarItems = buttonArray;
}

- (void)email_clicked:(id)sender
{
  [self scanButtonTapped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editObject:(id)sender
{

}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdskCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

  AdskData *object = _objects[indexPath.row];
  //cell.theLabel.text = [object description];



 cell.theLabel.text = [object.name uppercaseString];
 
 cell.theColor.text = [object.color uppercaseString];

cell.theSize.text = [object.size uppercaseString];

cell.thePrice.text = [object.price uppercaseString];

cell.theImage.contentMode = UIViewContentModeScaleAspectFit;
cell.theImage.image = object.image;




UIView *editingCategoryAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 35)];

    UIButton *addCategoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addCategoryButton setTitle:@"Add" forState:UIControlStateNormal];
    [addCategoryButton setFrame:CGRectMake(0, 0, 50, 35)];
    [addCategoryButton addTarget:self action:@selector(addCategoryClicked:withEvent:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *removeCategoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [removeCategoryButton setTitle:@"Remove" forState:UIControlStateNormal];
    [removeCategoryButton setFrame:CGRectMake(55, 0, 65, 35)];
    [removeCategoryButton addTarget:self action:@selector(removeCategoryClicked:withEvent:) forControlEvents:UIControlEventTouchUpInside];

    [editingCategoryAccessoryView addSubview:addCategoryButton];
    [editingCategoryAccessoryView addSubview:removeCategoryButton];
    //cell.editingAccessoryView = editingCategoryAccessoryView;
  




    return cell;
}

- (void)addCategoryClicked:(id)target withEvent:(UIEvent*)event
{
}

- (void)removeCategoryClicked:(id)target withEvent:(UIEvent*)event
{
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
NSLog(@"(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath");

// Cancel the delete button if we are in swipe to edit mode
  
  /*
      UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.editing && !self.editing)
    {
        [cell setEditing:NO animated:YES];
        return;
    }
*/
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

  NSLog(@"(void)setEditing:(BOOL)editing animated:(BOOL)animated");
    if (editing)
        _editingFromEditButton = YES;
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    _editingFromEditButton = NO;
    // Other code you may want at this point...
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath");

UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (_editingFromEditButton)
        return UITableViewCellEditingStyleInsert;

    // Otherwise, we are at swipe to delete
    [[tableView cellForRowAtIndexPath:indexPath] setEditing:!cell.isEditing animated:YES];
    return UITableViewCellEditingStyleInsert;
}
*/



@end
