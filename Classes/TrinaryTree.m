//
//  TrinaryTree.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTree.h"
#import "Node.h"


@implementation TrinaryTree

#pragma mark - Methods to manage tree
- (void)listTreeBranchStartingAtNode:(Node *)aNode
{
    if (aNode)
    {
        NSLog(@"%i, ", aNode.nodeContent.intValue);
        {
            if (aNode.leftNode)
            {
                [self listTreeBranchStartingAtNode:aNode.leftNode];
            }
            if (aNode.middleNode)
            {
                [self listTreeBranchStartingAtNode:aNode.middleNode];
            }
            if (aNode.rightNode)
            {
                [self listTreeBranchStartingAtNode:aNode.rightNode];        
            }
        }
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
        // trinaryTree doesn't have a rootNode, put aNode at root
        self.rootNode = aNode;
        
        // defensive programming - aNode.parentNode should always arrive nil
        // If a delete creates an orphan, TrinaryTree sets orphan parent nil before calling insert node
        self.rootNode.parentNode = nil;        
        
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
    
    if (!aNode)
    {
        NSLog(@"TrinaryTree can't delete an empty node");
        return;
    }
    
    // Keep a reference to any soon-to-be orphan nodes so we don't lose them when we delete aNode.
    // Note right hand side references may be nil.
    Node *leftOrphanNode = aNode.leftNode;
    Node *middleOrphanNode = aNode.middleNode;
    Node *rightOrphanNode = aNode.rightNode;
    
    // If aNode has a parent, remove parent's reference to aNode.
    // This will reduce aNode's retain count
    if (aNode.parentNode)
    {
        // Is aNode the leftChild of it's parent?
        if (aNode == aNode.parentNode.leftNode)
        {
            // Disconnect aNode parent's link to aNode
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
    }
    
    // If aNode is the root of the tree, remove tree's reference to aNode.
    if (aNode == self.rootNode)
    {
        self.rootNode = nil;
    } 
    
    // NOTE:  I think this statement caused a crash when positioned earlier in the method.
    // send delegate message with reference to node before delete node
    [self.delegate trinaryTreeWillDeleteNode:aNode];
    
    // make sure we don't try to use a bad reference
    aNode = nil;
    
    // For any children of aNode, remove the child's reference to it's ex-parent aNode.
    // Then re-connect orphans to tree.
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
    NSLog(@"end TrinaryTree deleteNode:");
}

@end
