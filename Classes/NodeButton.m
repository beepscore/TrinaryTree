//
//  NodeButton.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "NodeButton.h"
#import "Node.h"

@implementation NodeButton;

@synthesize node;

//- (id)initWithFrame:(CGRect)frame {
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code.
//        self.node = [[[Node alloc] init] autorelease];
//    }
//    return self;
//}


- (void)dealloc
{
    [node release];    
    
    [super dealloc];
}


@end
