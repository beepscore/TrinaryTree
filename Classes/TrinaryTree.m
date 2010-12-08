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
@synthesize nodes, rootNode;


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
    NSLog(@"Nodes: ");
    
    for (Node* aNode in [self nodes]) {
        NSLog(@"%i, ", aNode.nodeContent.intValue);
    }
    NSLog(@"Root node = %i, ", self.rootNode.nodeContent.intValue);
}


- (void)insertNode:(Node *)aNode
{
    if (!self.rootNode)
    {
        // rootNode is empty, put aNode at root
        self.rootNode = aNode;
        // don't set aNode.parentNode
        [[self nodes] addObject:aNode];
        NSLog(@"added %@ as rootNode", aNode.nodeContent);
        [self.delegate trinaryTreeDidInsertNode:aNode];
        
    } else {
        // trinaryTree has a rootNode. Start traversing tree at the rootNode.
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
    // disconnect aNode parent's link to aNode
    if (aNode == aNode.parentNode.leftNode)
    {
        aNode.parentNode.leftNode = nil;
    }
    else if (aNode == aNode.parentNode.middleNode)
    {
        aNode.parentNode.middleNode = nil;
    }
    else if (aNode == aNode.parentNode.rightNode)
    {
        aNode.parentNode.rightNode = nil;
    }

    // Keep references so we don't lose them when we delete aNode
    // Note they may be nil. in Objective C, ok to send a message to nil
    Node *leftOrphanNode = aNode.leftNode;
    Node *middleOrphanNode = aNode.middleNode;
    Node *rightOrphanNode = aNode.rightNode;
    
    // disconnect aNode children's link to their ex-parent aNode
    leftOrphanNode.parentNode = nil;
    middleOrphanNode.parentNode = nil;
    rightOrphanNode.parentNode = nil;
    
    // make sure rootNode is not retaining aNode
    if (aNode == self.rootNode)
    {
        self.rootNode = nil;
    }    
    
    // if we want to send delegate message with node, need to do it before delete
    [self.delegate trinaryTreeWillDeleteNode:aNode];
    
    // free memory
    [aNode release];
    // make sure we don't try to use a bad reference
    aNode = nil;
    
    // Re-connect orphans to tree
    // The order of re-connection may affect the result, and the order is arbitrary
    if (leftOrphanNode)
    {
        [self insertNode:leftOrphanNode];
    }
    if (middleOrphanNode)
    {
        [self insertNode:middleOrphanNode];
    }
    if (rightOrphanNode)
    {
        [self insertNode:rightOrphanNode];
    }
}


@end
