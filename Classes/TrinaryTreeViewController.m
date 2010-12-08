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
#import "NodeButton.h"

@interface TrinaryTreeViewController ()
- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue;
- (void)showTree:(TrinaryTree *)aTree fromNode:(Node *)startNode atPointValue:(NSValue *)aPointValue;
@end


@implementation TrinaryTreeViewController

@synthesize trinaryTree, nodeButtons;

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
   
    ///////////////////////////////////////////////////
    // NOTE: we will release each nodeButton two times
    // First to balance the retain when instantiated in showNode
    // Second release is implicit.  When we release nodeButtons set, 
    // it will release each nodebutton it was retaining in its collection.
    
    // release nodeButtons instantiated and retained in showNode 
    for (NodeButton *aNodeButton in self.nodeButtons) {
        [aNodeButton release];
    }
    
    // release nodeButtons set and objects in its collection
    [nodeButtons release];
    ///////////////////////////////////////////////////
    
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

#pragma mark -
- (void)showNode:(Node *)aNode atPointValue:(NSValue *)aPointValue
{
    NodeButton *aNodeButton = [[NodeButton alloc] initWithNode:aNode atPointValue:aPointValue];

    [self.view addSubview:aNodeButton.button];

    // NOTE: Clang warns potential leak of aNodeButton.
    // We can't release aNodeButton yet, need it to respond to button tap.
    // Put aNodeButton in nodeButtons set, so we can release it in dealloc
    [self.nodeButtons addObject:aNodeButton];
    // We should release aNodeButton.button, because the view is retaining it as a subview
    [aNodeButton.button release];
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
