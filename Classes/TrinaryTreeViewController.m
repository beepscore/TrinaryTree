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

@interface TrinaryTreeViewController ()
- (void)nodeButtonTapped:(id)sender;
- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue;
- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue;
@end


@implementation TrinaryTreeViewController

@synthesize trinaryTree, buttonNodeDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trinaryTree = [[[TrinaryTree alloc] init] autorelease];
    self.trinaryTree.delegate = self;
    self.trinaryTree.nodes = [[[NSMutableSet alloc] initWithCapacity:1] autorelease];
    
    self.title = NSLocalizedString(@"Nodes", @"");
    
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
    // Handle nodeButton tapped
    // ref http://stackoverflow.com/questions/450222/passing-a-parameter-in-setaction
    NSInteger senderIDTag = [sender tag];
    NSNumber *senderTagNumber = [NSNumber numberWithInt:senderIDTag];
    Node *nodeForButton = [self.buttonNodeDictionary objectForKey:senderTagNumber];
    NSLog(@"Hi from node %i", nodeForButton.nodeContent.intValue);
}


#pragma mark -
#pragma mark TrinaryTreeDelegate method
- (void)trinaryTreeDidInsertNode:(Node *)aNode
{         
    // remove old subviews
    // ref http://stackoverflow.com/questions/2156015/iphone-remove-all-subviews
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *aView in viewsToRemove) {
        [aView removeFromSuperview];
    }
    
    // call showTree
    CGPoint currentPoint = CGPointMake(self.view.bounds.size.width / 2.0f, 25.0);
    NSValue *currentPointValue = [NSValue valueWithCGPoint:currentPoint];
    [self showTree:self.trinaryTree
          fromNode:self.trinaryTree.rootNode 
      atPointValue:currentPointValue];
}


- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue
{
    UIButton *aNodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // Tag the button to identify it to selector
    aNodeButton.tag = buttonTagIndex;
    NSNumber *aNodeButtonTagNumber = [NSNumber numberWithInt:aNodeButton.tag];
    // Associated the button tag with the node, so the selector can get the node
    [self.buttonNodeDictionary setObject:aNode forKey:aNodeButtonTagNumber];
    buttonTagIndex ++;
    
    [aNodeButton addTarget:self 
                    action:@selector(nodeButtonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    
    NSString *aNodeButtonTitle = [NSString stringWithFormat:@"%i", aNode.nodeContent.intValue];
    [aNodeButton setTitle:aNodeButtonTitle forState:UIControlStateNormal];
    
    float buttonHeight = 30.0;
    float buttonWidth = 30.0;    
    
    aNodeButton.frame = CGRectMake(aPointValue.CGPointValue.x - (buttonWidth / 2.0),
                                   aPointValue.CGPointValue.y - (buttonHeight / 2.0),
                                   buttonWidth,
                                   buttonHeight);
    [self.view addSubview:aNodeButton];    
}


- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue
{
    // Start traversing tree at startNode.
    // currentNode keeps track of our position
    Node *currentNode = startNode;
    [self showNode:currentNode atPointValue:aPointValue];
    
    // if the currentNode has children, keep walking down the tree
    if (currentNode.leftNode || currentNode.middleNode || currentNode.rightNode)
    {    
        double verticalOffset = 50.0;
        double childY = aPointValue.CGPointValue.y + verticalOffset;
        
        // choose branch direction        
        if (currentNode.leftNode)
        {            
            double leftChildX = aPointValue.CGPointValue.x - (36000.0/pow(childY,1.4));            
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
            double rightChildX = aPointValue.CGPointValue.x + (36000.0/pow(childY,1.4));            
            CGPoint rightChildPoint = CGPointMake(rightChildX, childY);
            NSValue *rightChildPointValue = [NSValue valueWithCGPoint:rightChildPoint];
            
            // recursive call
            [self showTree:self.trinaryTree
                  fromNode:currentNode.rightNode 
              atPointValue:rightChildPointValue];            
        }
    }
}

@end
