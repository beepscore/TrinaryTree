//
//  TrinaryTreeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTreeViewController.h"
#import "Node.h"

@interface TrinaryTreeViewController ()
- (void)nodeButtonTapped;
- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue;
- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue;
@end


@implementation TrinaryTreeViewController

@synthesize trinaryTree;

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
    
    [super dealloc];
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


- (void)nodeButtonTapped
{
    // Handle nodeButton tapped    
}


#pragma mark -
#pragma mark TrinaryTreeDelegate method
- (void)trinaryTreeDidInsertNode:(Node *)aNode
{         
    CGPoint currentPoint = CGPointMake(self.view.bounds.size.width / 2.0f, 10.0);
    NSValue *currentPointValue = [NSValue valueWithCGPoint:currentPoint];
    [self showTree:self.trinaryTree
          fromNode:self.trinaryTree.rootNode 
      atPointValue:currentPointValue];
}


- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue
{
    UIButton *aNodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [aNodeButton addTarget:self 
                    action:@selector(nodeButtonTapped)
          forControlEvents:UIControlEventTouchDown];
    
    NSString *aNodeButtonTitle = [NSString stringWithFormat:@"%i", aNode.nodeContent.intValue];
    [aNodeButton setTitle:aNodeButtonTitle forState:UIControlStateNormal];
    
    float buttonHeight = 30.0;
    float buttonWidth = 30.0;
    
    aNodeButton.frame = CGRectMake(aPointValue.CGPointValue.x,
                                   aPointValue.CGPointValue.y,
                                   buttonWidth,
                                   buttonHeight);
    [self.view addSubview:aNodeButton];    
}


- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue
{
    float horizontalOffset = 40.0;
    float verticalOffset = 50.0;
    
    // Start traversing tree at startNode.
    // currentNode keeps track of our position
    Node *currentNode = startNode;
    [self showNode:currentNode atPointValue:aPointValue];

    
    // if the currentNode has children, keep walking down the tree
    if (currentNode.leftNode || currentNode.middleNode || currentNode.rightNode)
    {                    
        // choose branch direction        
        if (currentNode.leftNode)
        {
            // show left
            CGPoint leftChildPoint = CGPointMake(aPointValue.CGPointValue.x - horizontalOffset,
                                                 aPointValue.CGPointValue.y + verticalOffset);
            NSValue *leftChildPointValue = [NSValue valueWithCGPoint:leftChildPoint];
            [self showTree:self.trinaryTree
                  fromNode:currentNode.leftNode 
              atPointValue:leftChildPointValue];            
        }
        
        if (currentNode.middleNode)
        {
            // show middle
            CGPoint middleChildPoint = CGPointMake(aPointValue.CGPointValue.x,
                                                 aPointValue.CGPointValue.y + verticalOffset);
            NSValue *middleChildPointValue = [NSValue valueWithCGPoint:middleChildPoint];
            [self showTree:self.trinaryTree
                  fromNode:currentNode.middleNode 
              atPointValue:middleChildPointValue];            
        }                         
        
        if (currentNode.rightNode)
        {
            // show right
            CGPoint rightChildPoint = CGPointMake(aPointValue.CGPointValue.x + horizontalOffset,
                                                 aPointValue.CGPointValue.y + verticalOffset);
            NSValue *rightChildPointValue = [NSValue valueWithCGPoint:rightChildPoint];
            [self showTree:self.trinaryTree
                  fromNode:currentNode.rightNode 
              atPointValue:rightChildPointValue];            
        }                 
    }
}

@end
