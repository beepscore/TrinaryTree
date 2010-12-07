//
//  Node.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "Node.h"


@implementation Node

@synthesize nodeContent;
@synthesize parentNode, leftNode, middleNode, rightNode;


- (void)dealloc
{
    [nodeContent release];
    [parentNode release];
    [leftNode release];
    [middleNode release];
    [rightNode release];
    
    [super dealloc];
}

@end
