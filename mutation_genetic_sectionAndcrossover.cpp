//
//  main.cpp
//  HW4_B
//
//  Created by Zar Ni Pyae Zone on 10/5/19.
//  Copyright © 2019 Zar Ni Pyae Zone. All rights reserved.
//

#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <deque>
using namespace std;

int graph[8][8]; // since there are 8 cities from 1-8, index[0][0] is NULL

void add_edge(int x,int y,int z){
    graph[x][y] = z;
    graph[y][x] = z;
}

void displayMatrix(int v) { // test case only(print the matrix)
   int i, j;
   for(i = 0; i < v; i++) {
      for(j = 0; j < v; j++) {
         cout << graph[i][j] << " ";
      }
      cout << endl;
   }
}

//helper function to generate random integer without duplicate
bool isContain(vector<int> m, int n){
    for(int i=0; i<m.size(); i++){
        if(m[i] == n){
            return true;
        }
    }
    return false;
}

// initialize population randomly
vector<int> initPopulation(){
    vector<int> nRand;
    for(int i=0; i<8; i++){
        int temp = (rand() % 8) + 1;
        while(isContain(nRand, temp)){
            temp = (rand() % 8) + 1;
        }
        nRand.push_back(temp);
    }
    return nRand;
}

// calculate the total distance base on the difference order of cities
// also known as fitness function
int evalPopulation(vector<int> vect){
    int totalDist = 0;
    for(int i=0; i<vect.size()-1; i++){
        totalDist = totalDist + ( graph[vect[i]][vect[i+1]] );
        
        //cout << endl << "loop index: " << i+1 << endl;
        //cout << "find dist btw this two cities: " << vect[i] << " " << vect[i+1] << "-> ";
        //cout << graph[vect[i]][vect[i+1]] << endl;
        
        //cout << "current total distance: " << totalDist << endl;
    }
    return totalDist;
}

// mutation
vector<int> mutation(vector<int> vect){
    vector<int> mutated = vect;
    int temp,x,y,z; // swap index
    // generate two difference index and swap them
    x = (rand() % 7) + 0;
    z = (rand() % 7) + 0;
    while(x == z){
        z = (rand() % 7) + 0;
    }
    y = z;
    temp = mutated[x];
    mutated[x] = mutated[y];
    mutated[y] = temp;
    return mutated;
}

//section and crossover
vector<int> crossover(vector<int> parent1, vector<int> parent2){
    vector<int> newChild;
    // making section that initial index and end index
//    int x = (rand() % 6) + 1;
    int x = 3;
    for(int i=0; i<x; i++){
        newChild.push_back(parent1[i]);
    }
    while(newChild.size()<8){
        for(int j=0; j<parent2.size(); j++){
            if(!isContain(newChild, parent2[j])){
                newChild.push_back(parent2[j]);
            }
        }
    }
    return newChild;
}

// this function finds the shortest distance and return the path
vector<int> findSolution(deque<vector<int>> dQ){
    vector<int> temp = dQ[0];
    int x,y;
    for(int i=0; i<dQ.size(); i++){
        x = evalPopulation(temp);
        y = evalPopulation(dQ[i]);
        if( x > y ) {
            temp = dQ[i];
        }
    }
    return temp;
}

// this function sorts the deque in order
deque<vector<int>> sortDq(deque<vector<int>> dQ){
    for(int i=0; i<dQ.size(); i++){
        for(int j=i+1; j<dQ.size(); j++){
            if(evalPopulation(dQ[i]) > evalPopulation(dQ[j])){
                dQ[i].swap(dQ[j]);
            }
        }
    }
    return dQ;
}

// print function to print the path and the distance
void printPath(vector<int> vect){
    for(int i=0; i< vect.size(); i++){
        if(i == 0){
            cout << endl << vect[i] << " -> " ;
        }
        else if( i+1 == vect.size() ){
            cout << vect[i] << ". Total Distance: "<< evalPopulation(vect) << endl ;
        }
        else {
            cout << vect[i] << " -> " ;
        }
    }
}


int main() {
    // build distance matrix
    //x=1
    add_edge(1,1,0);
    add_edge(1,2,1);
    add_edge(1,3,10);
    add_edge(1,4,2);
    add_edge(1,5,17);
    add_edge(1,6,13);
    add_edge(1,7,19);
    add_edge(1,8,11);
    //x=2
    add_edge(2,2,0);
    add_edge(2,3,12);
    add_edge(2,4,9);
    add_edge(2,5,4);
    add_edge(2,6,2);
    add_edge(2,7,7);
    add_edge(2,8,19);
    //x=3
    add_edge(3,3,0);
    add_edge(3,4,4);
    add_edge(3,5,18);
    add_edge(3,6,20);
    add_edge(3,7,1);
    add_edge(3,8,4);
    //x=4
    add_edge(4,4,0);
    add_edge(4,5,5);
    add_edge(4,6,3);
    add_edge(4,7,11);
    add_edge(4,8,14);
    //x=5
    add_edge(5,5,0);
    add_edge(5,6,11);
    add_edge(5,7,5);
    add_edge(5,8,8);
    //x=6
    add_edge(6,6,0);
    add_edge(6,7,18);
    add_edge(6,8,6);
    //x=7
    add_edge(7,7,0);
    add_edge(7,8,20);
    //x=8
    add_edge(8,8,0);
    
    vector<int> parent1,parent2,crossed,mutated,solution;
    deque<vector<int>> solutions;
    srand(time(0));
    
    deque<vector<int>> population;
    deque<vector<int>> newPopulation;
    int populationSize = 1000; // change the population size here!
    for(int i=0; i<populationSize; i++){
        population.push_back(initPopulation());
    }
   cout << "initialization done! current population: " << population.size() << endl;
    cout << "." << endl << "." << endl << "." << endl;
    
    int loopCount = 0;
    int generationCount = 10;   // change generation time here!
    while( loopCount < generationCount){
        for(int i=0; i<population.size(); i++){
            if(i == population.size()-1){ // special case for the last parent pair with first parent
                parent1 = population[i];
                parent2 = population[0];
                crossed = crossover(parent1, parent2);
                mutated = mutation(crossed);
//                printPath(mutated); // test case only
                newPopulation.push_back(mutated);
            }
            else{
                parent1 = population[i];
                parent2 = population[i+1];
                crossed = crossover(parent1, parent2);
                mutated = mutation(crossed);
//                printPath(mutated);   // test case only
                newPopulation.push_back(mutated);
            }
        }
        population.clear();
        population = sortDq(newPopulation); // sortDq will sort the dequq
        newPopulation.clear();
        loopCount ++;
    }
    cout << "after " << loopCount << " generation." << endl;
    solution = findSolution(population);
    cout << endl << "the shortest distance solution from the last generation: ";
    printPath(solution);
    
    return 0;
}
