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


- (void)listNodes
{
    NSLog(@"Nodes: ");
    
    for (Node* aNode in [self nodes]) {
        NSLog(@"%i, ", aNode.nodeContent.intValue);
    }
    NSLog(@"Root node = %i, ", self.rootNode.nodeContent.intValue);
}

@end
