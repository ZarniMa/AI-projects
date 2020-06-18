//
//  main.cpp
// 
//
//  Created by Zar Ni Pyae Zone on 9/24/19.
//  Copyright © 2019 Zar Ni Pyae Zone. All rights reserved.
//

#include <iostream>
#include <vector>
#include <deque>
#include <queue>
using namespace std;

struct TreeNode{
    string state;
    string action;
    bool wolf, goat, cabbage;
    TreeNode* parent;
    vector <TreeNode*> children;
};



// makie a new node that have 2 strings(state,action), 3 boolean(wolf,goat,cabbage) and pointer(parent)
TreeNode *makeNode(string mState, string mAction, bool mWolf, bool mGoat, bool mCabbage, TreeNode* mParent){
    TreeNode *temp = new TreeNode;
    temp->state = mState;
    temp->action = mAction;
    temp->wolf = mWolf;
    temp->goat = mGoat;
    temp->cabbage = mCabbage;
    temp->parent = mParent;
    return temp;
}

deque<TreeNode*> deq; // using dequeue to remember the path
queue<TreeNode*> froTiQ;

void goThroTree(TreeNode*r){
    froTiQ.push(r);
}

// this function print the solution path that keep in deque
void printSolution(deque<TreeNode*> deq){
    while (!deq.empty()){
        cout << endl << deq.back()->state << endl;
        cout << deq.back()->action << endl;
        deq.pop_back();
    }
}

// this function will find the parent node
// until reach to the root
// and also remember the path(from goal to root)
void findParent(TreeNode *r){
    if (r == NULL){
        printSolution(deq);
        return;
    }
    else {
        deq.push_back(r);
        findParent(r->parent);
    }
}

// this function will go through every node in the tree
// and find the goal
// when it found the goal, call "findParent" function!
void findSol(){
    while( !froTiQ.empty() ){
        TreeNode *temp = froTiQ.front();
        froTiQ.pop();
        if ((temp->wolf && temp->goat && temp->cabbage) == true){
            findParent(temp);
            return;
        }
        else {
            for(int i=0; i< temp->children.size(); i++){
                goThroTree(temp->children[i]);
            }
        }
    } // end while
}

// using this loop methond in searching algorithm,
// prove that reach all nodes
void printAllNode(TreeNode *r){     // test case only
    cout << r->state << endl;
    cout << r->action << endl;
    for(int i=0; i < r->children.size();i++){
        printAllNode(r->children[i]);
    }
}

int main() {
    
    // build a tree using makeNode function that have 2 strings(state,action), 3 boolean(wolf,goat,cabbage) and pointer(parent)
    TreeNode *root = makeNode("w,g,c/     /   ", "Initial, all wolf,goat and cabbage at left side, do not move yet.",false,false,false,NULL);
    
    (root->children).push_back(makeNode("w,g  /c    /   ", "cabbage moves from left side but wolf ate goat",false,false,false,root));//0
    (root->children).push_back(makeNode("c,g  /w    /   ", "wolf moves from left side but goat ate cabbage",false,false,false,root));//1
    (root->children).push_back(makeNode("w,c  /g    /   ", "goat moves from left side and wolf and cabbage left on left side",false,false,false,root));//2
    
    (root->children[2]->children).push_back(makeNode("w,c  /     /g","goat moved to right side",false,true,false,root->children[2]));//0
    
    (root->children[2]->children[0]->children).push_back(makeNode("w    /c    /g  ","cabbage moves from left side",false,true,false,root->children[2]->children[0]));//0
    (root->children[2]->children[0]->children).push_back(makeNode("c    /w    /g  ","wolf moves from left side",false,true,false,root->children[2]->children[0]));//1

    (root->children[2]->children[0]->children[0]->children).push_back(makeNode("w    /     /c,g","cabbage and goat on right side but goat ate cabbage",false,true,true,root->children[2]->children[0]->children[0]));//0
    (root->children[2]->children[0]->children[0]->children).push_back(makeNode("w    /g    /c","cabbage left on right side and goat moves from right side to left side",false,false,true,root->children[2]->children[0]->children[0]));//1
    
    (root->children[2]->children[0]->children[1]->children).push_back(makeNode("c    /     /g,w","wolf and goat on right side but wolf ate goat",true,true,false,root->children[2]->children[0]->children[1]));//0
    (root->children[2]->children[0]->children[1]->children).push_back(makeNode("c    /g    /w","wolf left on right side and goat moves from right side to left side",true,false,false,root->children[2]->children[0]->children[1]));//1
    
    (root->children[2]->children[0]->children[0]->children[1]->children).push_back(makeNode("g    /w    /c","goat left on left side and wolf moves from left side to right side",false,false,true,root->children[2]->children[0]->children[0]->children[1]));//0
    
    (root->children[2]->children[0]->children[1]->children[1]->children).push_back(makeNode("g    /c    /w","goat left on left side and cabbage moves from left side to right side",true,false,false,root->children[2]->children[0]->children[1]->children[1]));//0
    
    (root->children[2]->children[0]->children[0]->children[1]->children[0]->children).push_back(makeNode("g    /     /w,c","wolf and cabbage on the right side",true,false,true,root->children[2]->children[0]->children[0]->children[1]->children[0]));//0
    
    (root->children[2]->children[0]->children[1]->children[1]->children[0]->children).push_back(makeNode("g    /     /c,w","cabbage and wolf on the right side",true,false,true,root->children[2]->children[0]->children[1]->children[1]->children[0]));//0
    
    (root->children[2]->children[0]->children[0]->children[1]->children[0]->children[0]->children).push_back(makeNode("     /g    /w,c","goat moves from left to right side",true,false,true,root->children[2]->children[0]->children[0]->children[1]->children[0]->children[0]));//0
    
    (root->children[2]->children[0]->children[1]->children[1]->children[0]->children[0]->children).push_back(makeNode("     /g    /c,w","goat moves from left side to right side",true,false,true,root->children[2]->children[0]->children[1]->children[1]->children[0]->children[0]));//0
    
    (root->children[2]->children[0]->children[0]->children[1]->children[0]->children[0]->children[0]->children).push_back(makeNode("     /     /g,w,c","goat, wolf and cabbage are on the right side now",true,true,true,root->children[2]->children[0]->children[0]->children[1]->children[0]->children[0]->children[0]));//0
    
    (root->children[2]->children[0]->children[1]->children[1]->children[0]->children[0]->children[0]->children).push_back(makeNode("     /     /g,c,w","goat, cabbage and wolf are on the right side now",true,true,true,root->children[2]->children[0]->children[1]->children[1]->children[0]->children[0]->children[0]));//0
    
    goThroTree(root);
    findSol();
    
    return 0;
}
