//
//  TrinaryTreeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTreeViewController.h"
#import "Node.h"
#import "NodeView.h"

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

#pragma mark -
#pragma mark TrinaryTreeDelegate method
- (void)trinaryTreeDidInsertNode:(Node *)aNode
{
//    CGRect nodeFrame = CGRectMake(self.view.bounds.size.width / 2.0f, 10, 30, 30);
//    NodeView *tempNodeView = [[NodeView alloc] initWithFrame:nodeFrame];
//    [self.view addSubview:tempNodeView];
//    [tempNodeView release];
    
    
    NodeView *tempNodeView = [NodeView buttonWithType:UIButtonTypeRoundedRect];
    [tempNodeView addTarget:self 
               action:nil //@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    
    NSString *nodeButtonTitle = [NSString stringWithFormat:@"%i", aNode.nodeContent.intValue];
    [tempNodeView setTitle:nodeButtonTitle forState:UIControlStateNormal];
    tempNodeView.frame = CGRectMake(self.view.bounds.size.width / 2.0f, 10.0, 30.0, 30.0);
    [self.view addSubview:tempNodeView];

    
}


@end
