//
//  TrinaryTreeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTreeViewController.h"
#import "Node.h"
#import "NodeButton.h"

@interface TrinaryTreeViewController ()
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
    // must use UIButtonTypeCustom in order to get access to sublclass NodeButton properties
    //    NodeButton *aNodeButton = [NodeButton buttonWithType:UIButtonTypeRoundedRect];
    // ref http://stackoverflow.com/questions/2920045/subclassing-uibutton-but-cant-access-my-properties
    NodeButton *aNodeButton = [NodeButton buttonWithType:UIButtonTypeCustom];

    [aNodeButton addTarget:self 
                    action:@selector(nodeButtonTapped)
          forControlEvents:UIControlEventTouchDown];
    
    aNodeButton.node = aNode;
    
    NSString *aNodeButtonTitle = [NSString stringWithFormat:@"%i", aNode.nodeContent.intValue];
    [aNodeButton setTitle:aNodeButtonTitle forState:UIControlStateNormal];
    
    float buttonHeight = 30.0;
    float buttonWidth = 30.0;
    float horizontalOffset = 40;
    float verticalOffset = 50.0;
    
    if (!aNodeButton.node.parentNode)
    {
        // node has no parent, so put aNodeButton at root
        //        aNodeButton.frame = CGRectMake(self.view.bounds.size.width / 2.0f, 10.0, buttonWidth, buttonHeight);
        aNodeButton.frame = CGRectMake(self.view.bounds.size.width / 2.0f, 10.0, 30.0, 30.0);
        [self.view addSubview:aNodeButton];
    } else {
        // add aNodeButton as subview of parent NodeButton on correct branch
        // don't have a simple way to get a reference to the parent NodeButton??
        // for now, add aNodeButton as subview of self.view
        
        if (aNode == aNode.parentNode.leftNode) 
        {
            horizontalOffset *= -1;
        } else if (aNode == aNode.parentNode.middleNode)
        {
            horizontalOffset = 0;
        }
        
        aNodeButton.frame = CGRectMake((self.view.bounds.size.width / 2.0f) + horizontalOffset,
                                       verticalOffset, buttonWidth, buttonHeight);

        //[aNodeButton.node.parentNode.view addSubview:aNodeButton];
        [self.view addSubview:aNodeButton];
    }
    
}


@end
