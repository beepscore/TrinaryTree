//
//  TrinaryTreeViewController.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTreeViewController.h"
#import "Node.h"
#import "AddNodeViewController.h"
#import <math.h>

const double kVerticalOffset = 50.0f;

@interface TrinaryTreeViewController ()
{
    NSInteger buttonTagIndex;
}
@property (nonatomic, strong) TrinaryTree *trinaryTree;
@property (nonatomic, strong) NSMutableDictionary *buttonNodeDictionary;
@end


@implementation TrinaryTreeViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trinaryTree = [[TrinaryTree alloc] init];
    self.trinaryTree.delegate = self;
    
    self.title = NSLocalizedString(@"Trinary Tree", @"");
    
    self.buttonNodeDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    buttonTagIndex = 0;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addVCSegue"])
    {
        AddNodeViewController *addNodeViewController = [segue destinationViewController];
        addNodeViewController.trinaryTree = self.trinaryTree;
    }
}

#pragma mark - IBActions
- (void)nodeButtonTapped:(id)sender
{
    NSLog(@"in TrinaryTreeViewController nodeButtonTapped:");
    
    // Handle nodeButton tapped
    // ref http://stackoverflow.com/questions/450222/passing-a-parameter-in-setaction
    NSInteger senderIDTag = [sender tag];
    NSNumber *senderTagNumber = @(senderIDTag);
    Node *nodeForButton = (self.buttonNodeDictionary)[senderTagNumber];
    
    // condition should always be true - defensive programming
    if (nodeForButton)
    {
        // delete buttonNodeDictionary entry for nodeForButton
        
        // Use the dictionary node value to find all keys that match.
        // keyArray should have only one element at index 0
        NSArray *keyArray = [self.buttonNodeDictionary allKeysForObject:nodeForButton];
        NSNumber *keyForANode = keyArray[0];
        
        // delete key-value pair
        [self.buttonNodeDictionary removeObjectForKey:keyForANode];        
        
        NSLog(@"Deleting node %i", nodeForButton.nodeContent.intValue);
        [self.trinaryTree deleteNode:nodeForButton]; 
    }
}

#pragma mark - TrinaryTreeDelegate methods
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

#pragma mark - View methods
- (void)cleanViewAndShowTree
{    
    NSLog(@"in TrinaryTreeViewController cleanViewAndShowTree");
    NSLog(@"Root node = %i", self.trinaryTree.rootNode.nodeContent.intValue);
    [self.trinaryTree listTreeBranchStartingAtNode:self.trinaryTree.rootNode];
    
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
        NSNumber *aNodeButtonTagNumber = @(aNodeButton.tag);
        // Associate the button tag with the node, so the selector can get the node
        // Note this will throw an exception if object or key are nil
        (self.buttonNodeDictionary)[aNodeButtonTagNumber] = aNode;
        
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
