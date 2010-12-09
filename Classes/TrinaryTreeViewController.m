//
//  TrinaryTreeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTreeViewController.h"
#import "Node.h"
#import <math.h>

const double kVerticalOffset = 50.0f;

@interface TrinaryTreeViewController ()
- (void)nodeButtonTapped:(id)sender;
- (void)cleanViewAndShowTree;
- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue;
- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue;
- (double)horizontalOffsetForY:(float)yCoordinate;
@end


@implementation TrinaryTreeViewController

@synthesize trinaryTree, buttonNodeDictionary;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trinaryTree = [[[TrinaryTree alloc] init] autorelease];
    self.trinaryTree.delegate = self;
    self.trinaryTree.nodes = [[[NSMutableSet alloc] initWithCapacity:1] autorelease];
    
    self.title = NSLocalizedString(@"Trinary Tree", @"");
    
    // Set up the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(presentAddNodeViewController)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    self.buttonNodeDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    buttonTagIndex = 0;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [trinaryTree release];
    [buttonNodeDictionary release];
    
    [super dealloc];
}

#pragma mark -
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return ( (interfaceOrientation == UIInterfaceOrientationPortrait)
            || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
            || (interfaceOrientation == UIInterfaceOrientationLandscapeRight) );
}


#pragma mark -
#pragma mark Add a new node
- (void)presentAddNodeViewController
{    
    // Create the modal view controller
    // Reference http://useyourloaf.com/blog/2010/5/3/ipad-modal-view-controllers.html
    AddNodeViewController *addNodeViewController = [[AddNodeViewController alloc] initWithNibName:nil bundle:nil];
    
    // We are responsible for dismissing the modal view.
    // Set ourselves as delegate, to get callback.    
    addNodeViewController.delegate = self;
    
    addNodeViewController.trinaryTree = self.trinaryTree;
    
    // Create a Navigation controller to get a navigation bar to hold the done button  
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:addNodeViewController];
    
    // show the navigation controller modally    
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
    
    [addNodeViewController release];
}

#pragma mark -
#pragma mark AddNodeViewControllerDelegate method
- (void)addNodeViewControllerDidRequestDismissView
{
    // Dismiss the modal view controller    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)nodeButtonTapped:(id)sender
{
    NSLog(@"in TrinaryTreeViewController nodeButtonTapped:");
    
    // Handle nodeButton tapped
    // ref http://stackoverflow.com/questions/450222/passing-a-parameter-in-setaction
    NSInteger senderIDTag = [sender tag];
    NSNumber *senderTagNumber = [NSNumber numberWithInt:senderIDTag];
    Node *nodeForButton = [self.buttonNodeDictionary objectForKey:senderTagNumber];
    
    // condition should always be true - defensive programming
    if (nodeForButton)
    {
        // delete buttonNodeDictionary entry for nodeForButton
        
        // Use the dictionary node value to find all keys that match.
        // keyArray should have only one element at index 0
        NSArray *keyArray = [self.buttonNodeDictionary allKeysForObject:nodeForButton];
        NSNumber *keyForANode = [keyArray objectAtIndex:0];
        
        // delete key-value pair
        [self.buttonNodeDictionary removeObjectForKey:keyForANode];        
        
        NSLog(@"Deleting node %i", nodeForButton.nodeContent.intValue);
        [self.trinaryTree deleteNode:nodeForButton]; 
    }
}


#pragma mark -
#pragma mark TrinaryTreeDelegate methods
- (void)trinaryTreeDidInsertNode:(Node *)aNode
{         
    [self cleanViewAndShowTree];
}


- (void)trinaryTreeWillDeleteNode:(Node *)aNode
{
    NSLog(@"in TrinaryTreeViewController trinaryTreeWillDeleteNode:");
    // cleanViewAndShowTree empties the entire buttonNodeDictionary
    [self cleanViewAndShowTree];
}


#pragma mark -
#pragma mark View methods
- (void)cleanViewAndShowTree
{
    
    NSLog(@"in TrinaryTreeViewController cleanViewAndShowTree");
    [self.trinaryTree listNodes];
    
    // empty buttonNodeDictionary, we will be adding new labels 
    [self.buttonNodeDictionary removeAllObjects];
    
    // remove all subviews
    // ref http://stackoverflow.com/questions/2156015/iphone-remove-all-subviews
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *aView in viewsToRemove)
    {
        [aView removeFromSuperview];
    }
    
    // call showTree starting from rootNode
    CGPoint currentPoint = CGPointMake((self.view.bounds.size.width / 2.0f), kVerticalOffset);
    NSValue *currentPointValue = [NSValue valueWithCGPoint:currentPoint];
    
    [self showTree:self.trinaryTree
          fromNode:self.trinaryTree.rootNode 
      atPointValue:currentPointValue];    
}


- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue
{
    if (aNode)
    {
        UIButton *aNodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // Tag the button to identify it to selector
        aNodeButton.tag = buttonTagIndex;
        NSNumber *aNodeButtonTagNumber = [NSNumber numberWithInt:aNodeButton.tag];
        // Associate the button tag with the node, so the selector can get the node
        // Note this will throw an exception if object or key are nil
        [self.buttonNodeDictionary setObject:aNode forKey:aNodeButtonTagNumber];
        
        buttonTagIndex ++;
        
        [aNodeButton addTarget:self 
                        action:@selector(nodeButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
        
        aNodeButton.titleLabel.font = [UIFont systemFontOfSize:20];
        NSString *aNodeButtonTitle = [NSString stringWithFormat:@"%i", aNode.nodeContent.intValue];
        [aNodeButton setTitle:aNodeButtonTitle forState:UIControlStateNormal];
        
        float buttonHeight = 40.0;
        float buttonWidth = 40.0;    
        
        aNodeButton.frame = CGRectMake(aPointValue.CGPointValue.x - (buttonWidth / 2.0),
                                       aPointValue.CGPointValue.y - (buttonHeight / 2.0),
                                       buttonWidth,
                                       buttonHeight);
        [self.view addSubview:aNodeButton]; 
    }
}


- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue
{
    NSLog(@"in TrinaryTreeViewController showTree:...");
    if (!startNode)
    {
        return;
    }
    
    // Start traversing tree at startNode.
    // currentNode keeps track of our position
    Node *currentNode = startNode;
    [self showNode:currentNode atPointValue:aPointValue];
    
    // if the currentNode has children, keep walking down the tree
    if (currentNode.leftNode || currentNode.middleNode || currentNode.rightNode)
    {    
        double childY = aPointValue.CGPointValue.y + kVerticalOffset;
        
        // choose branch direction        
        if (currentNode.leftNode)
        {            
            double leftChildX = (aPointValue.CGPointValue.x - [self horizontalOffsetForY:childY]);            
            CGPoint leftChildPoint = CGPointMake(leftChildX, childY);
            NSValue *leftChildPointValue = [NSValue valueWithCGPoint:leftChildPoint];
            
            // recursive call
            [self showTree:self.trinaryTree
                  fromNode:currentNode.leftNode 
              atPointValue:leftChildPointValue];            
        }
        
        // use "if", not "else if", we want to look at all 3 branches!
        if (currentNode.middleNode)
        {            
            double middleChildX = aPointValue.CGPointValue.x;
            CGPoint middleChildPoint = CGPointMake(middleChildX, childY);
            NSValue *middleChildPointValue = [NSValue valueWithCGPoint:middleChildPoint];
            
            // recursive call
            [self showTree:self.trinaryTree
                  fromNode:currentNode.middleNode 
              atPointValue:middleChildPointValue];            
        } 
        
        if (currentNode.rightNode)
        {
            double rightChildX = (aPointValue.CGPointValue.x + [self horizontalOffsetForY:childY]);            
            CGPoint rightChildPoint = CGPointMake(rightChildX, childY);
            NSValue *rightChildPointValue = [NSValue valueWithCGPoint:rightChildPoint];
            
            // recursive call
            [self showTree:self.trinaryTree
                  fromNode:currentNode.rightNode 
              atPointValue:rightChildPointValue];            
        }
    }
}

// horizontally space node buttons.  Decrease spacing as we move farther down tree
- (double)horizontalOffsetForY:(float)yCoordinate
{
    // use exponential decay type function = amplitude * exp(-t/tau)
    // tau = "time constant", scales base e exponent
    double tau = 100.0;
    double amplitude = (self.view.bounds.size.width / 5.0);
    
    // start amplitude at first level below root node, y = 2*kVerticalOffset
    double horizontalOffset = ( amplitude * exp( -(yCoordinate - (2*kVerticalOffset)) / tau ));
    return horizontalOffset;
}


@end
