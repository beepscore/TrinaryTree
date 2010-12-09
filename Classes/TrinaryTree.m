//
//  TrinaryTree.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTree.h"
#import "Node.h";


@implementation TrinaryTree

@synthesize delegate;
@synthesize rootNode;
@synthesize nodes;


- (void)dealloc
{
    [nodes release];
    [rootNode release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Methods to manage tree
- (void)listNodes
{
    if (!self.rootNode)
    {
        NSLog(@"Root node is nil");
    } else {
        NSLog(@"Root node = %i, ", self.rootNode.nodeContent.intValue);
    }
    
    NSLog(@"Nodes: ");
    
    for (Node* aNode in [self nodes]) {
        NSLog(@"%i, ", aNode.nodeContent.intValue);
    }
}


- (void)insertNode:(Node *)aNode
{
    NSLog(@"in TrinaryTree insertNode:");

    if (!aNode)
    {
        return;
    }
    
    if (!self.rootNode)
    {
        // rootNode is empty, put aNode at root
        self.rootNode = aNode;
        
        // defensive programming - aNode.parentNode should always arrive nil
        // If a delete creates an orphan, TrinaryTree sets orphan parent nil before calling insert node
        self.rootNode.parentNode = nil;        
        
        [[self nodes] addObject:aNode];
        NSLog(@"added %@ as rootNode", aNode.nodeContent);
        [self.delegate trinaryTreeDidInsertNode:aNode];
        
    } else {
        // trinaryTree has a rootNode
        self.rootNode.parentNode = nil;
        
        // Start traversing tree at the rootNode.
        // currentNode keeps track of our position
        Node *currentNode = self.rootNode;
        
        // keep walking down the tree until we find an empty spot
        while (YES)
        {                    
            // we are at currentNode, and we will place aNode farther along the tree
            
            // set aNode.parentNode to currentNode before we change currentNode
            aNode.parentNode = currentNode;
            
            // choose branch direction
            
            if (aNode.nodeContent.intValue < currentNode.nodeContent.intValue)
            {
                // go left
                if (currentNode.leftNode)
                {
                    // left branch already has a node, can't put aNode there.
                    // Move current node to left node.
                    currentNode = currentNode.leftNode;
                } else {
                    // left branch is empty, put aNode there
                    // aNode.parentNode is already set
                    currentNode.leftNode = aNode;
                    [[self nodes] addObject:aNode];
                    NSLog(@"added %@ as leftNode of %@", 
                          aNode.nodeContent, aNode.parentNode.nodeContent);
                    [self.delegate trinaryTreeDidInsertNode:aNode];
                    // exit loop
                    return;                        
                }                 
            }
            
            else if (aNode.nodeContent.intValue > currentNode.nodeContent.intValue)
            {
                // go right
                if (currentNode.rightNode)
                {
                    currentNode = currentNode.rightNode;
                } else {
                    // right branch is empty, put aNode there
                    currentNode.rightNode = aNode;
                    [[self nodes] addObject:aNode];
                    NSLog(@"added %@ as rightNode of %@", 
                          aNode.nodeContent, aNode.parentNode.nodeContent);
                    [self.delegate trinaryTreeDidInsertNode:aNode];
                    return;
                }                
            }
            
            else // (aNode.nodeContent.intValue == currentNode.nodeContent.intValue)
            {
                // go middle
                if (currentNode.middleNode)
                {
                    currentNode = currentNode.middleNode;
                } else {
                    // middle branch is empty, put aNode there
                    currentNode.middleNode = aNode;
                    [[self nodes] addObject:aNode];
                    NSLog(@"added %@ as middleNode of %@", 
                          aNode.nodeContent, aNode.parentNode.nodeContent);
                    [self.delegate trinaryTreeDidInsertNode:aNode];
                    return;                        
                }                    
            }            
        }
    }
}


- (void)deleteNode:(Node *)aNode
{
    NSLog(@"start TrinaryTree deleteNode:");
    [self listNodes];
    
    if (!aNode)
    {
        NSLog(@"TrinaryTree deleteNode: !aNode return");
        return;
    }
    
    if (aNode.parentNode)
    {
        // disconnect aNode parent's link to aNode
        if (aNode.parentNode.leftNode == aNode)
        {
            aNode.parentNode.leftNode = nil;
        }
        else if (aNode.parentNode.middleNode == aNode)
        {
            aNode.parentNode.middleNode = nil;
        }
        else if (aNode.parentNode.rightNode == aNode)
        {
            aNode.parentNode.rightNode = nil;
        }
    }
    
    // Keep references so we don't lose them when we delete aNode
    // Note they may be nil. in Objective C, ok to send a message to nil
    Node *leftOrphanNode = aNode.leftNode;
    Node *middleOrphanNode = aNode.middleNode;
    Node *rightOrphanNode = aNode.rightNode;

    // make sure rootNode is not retaining aNode
    if (self.rootNode == aNode)
    {
        self.rootNode = nil;
    } 
    
    // NOTE:  I think this statement caused a crash when positioned earlier in the method.
    // send delegate message with reference to node before delete node
    [self.delegate trinaryTreeWillDeleteNode:aNode];

    // make sure nodes is not retaining aNode
    [[self nodes] removeObject:aNode];
    
    // free memory
    //[aNode release];
    
    // make sure we don't try to use a bad reference
    aNode = nil;
    
    // Disconnect aNode children's link to their ex-parent aNode 
    // and re-connect orphans to tree
    // The order of re-connection can affect the result, and the order is arbitrary
    // If middle node exists, reconnect it first to minimize changes to tree appearance.
    if (middleOrphanNode)
    {
        middleOrphanNode.parentNode = nil;
        [self insertNode:middleOrphanNode];
    }
    if (leftOrphanNode)
    {
        leftOrphanNode.parentNode = nil;
        [self insertNode:leftOrphanNode];
    }
    if (rightOrphanNode)
    {
        rightOrphanNode.parentNode = nil;
    [self insertNode:rightOrphanNode];
    }
    [self listNodes];
    NSLog(@"end TrinaryTree deleteNode:");

}


@end
