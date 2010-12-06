//
//  Node.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Node : NSObject {

}
@property (nonatomic, retain) NSNumber *nodeContent;
@property (nonatomic, retain) Node *parentNode;
@property (nonatomic, retain) Node *leftNode;
@property (nonatomic, retain) Node *middleNode;
@property (nonatomic, retain) Node *rightNode;

@end
