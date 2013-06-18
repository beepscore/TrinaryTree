Steve Baker Beepscore LLC 5 Dec 2010

# TrinaryTree
Adds and deletes nodes in a tree.

# Specification
Implement insert and delete in a tri-nary tree.  
Much like a binary tree but with 3 child nodes for each parent instead of two -- with the left node being values < parent, the right node values > parent, and the middle node values == parent.  For example, if I added the following nodes to the tree in this

order:  5, 4, 9, 5, 7, 2, 2 --  the tree would look like this:

            5
          / | \
         4  5  9
        /     /
      2      7
      |
      2

---
Write in Objective C, for potential demo on iPhone.

## Node object
5 properties
- content
- parent
- leftChild
- middleChild
- rightChild

Content cant be nil, other props (the 4 nodes) can?
Might run faster to use a dictionary for connection properties, not sure.
For now, don't use dictionary.

### Add Node
##### Always start at top?
Yes, that's why second 2 isn't child of second 5.

##### Is branch empty?
###### Yes
Add node and set node content = number.
###### No
Compare number to node content to choose correct 1 of 3 branches, step down.

Repeat until find empty branch and fill it.

### Delete Node
Delete any node.  Keep references to kids before delete!

Now we have 0-1 parent tree and 0-3 orphan trees.

Attach like add?

Before coding, draw a tree with more levels to see how this works.

Orphan will move straight up 1 level?

Does order of reattaching affect outcome? I think not.

Helpful to make a drawTree method. Can call starting at any node so can call on orphans.
