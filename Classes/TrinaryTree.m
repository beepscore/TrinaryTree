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
        // rootNode is empty, set it to aNode
        self.rootNode = aNode;
        // don't set aNode.parentNode
        // add aNode to the set of nodes
        [self.nodes addObject:aNode];        
        
    } else {
        
        // start traversing tree at the root
        Node *currentNode = self.rootNode;
        
        // keep walking down the tree until we find an empty spot
        while (YES)
        {                    
            // currentNode occupies this spot, and we will move farther along tree
            // set aNode.parentNode to currentNode before we change currentNode
            aNode.parentNode = currentNode;
            
            // choose branch direction
            if (aNode.nodeContent.intValue < currentNode.nodeContent.intValue)
            {
                // go left
                if (!currentNode.leftNode)
                {
                    // node is empty
                    // aNode.parentNode is already set
                    // add aNode to the set of nodes
                    currentNode.leftNode = aNode;
                    [self.nodes addObject:aNode];
                    NSLog(@"added %@ as leftNode of %@", 
                          aNode.nodeContent, aNode.parentNode.nodeContent);
                    return;
                } else {
                    currentNode = currentNode.leftNode;
                }
                
            } else if (aNode.nodeContent.intValue > currentNode.nodeContent.intValue)
            {                
                // go right
                if (!currentNode.rightNode)
                {
                    // node is empty
                    // aNode.parentNode is already set
                    // add aNode to the set of nodes
                    currentNode.rightNode = aNode;
                    [self.nodes addObject:aNode];
                    NSLog(@"added %@ as rightNode of %@", 
                          aNode.nodeContent, aNode.parentNode.nodeContent);
                } else {
                    currentNode = currentNode.rightNode;
                }                
                
            } else {
                // (aNode.nodeContent.intValue == currentNode.nodeContent.intValue)
                // go down
                if (!currentNode.middleNode)
                {
                    // node is empty
                    // aNode.parentNode is already set
                    // add aNode to the set of nodes
                    currentNode.middleNode = aNode;
                    [self.nodes addObject:aNode];
                    NSLog(@"added %@ as middleNode of %@", 
                          aNode.nodeContent, aNode.parentNode.nodeContent);
                    return;
                } else {
                    currentNode = currentNode.middleNode;
                }
            }
        }
    }
}

- (void)listNodes
{
    for (Node *aNode in self.nodes)
    {
        //NSLog(Node
    }
}


@end
