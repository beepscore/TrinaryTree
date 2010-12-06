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

@end
