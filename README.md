# Binary Tree Search Assembly

## Project Overview

This project, developed as part of the Computer Organization course at the German International University, focuses on implementing and documenting tree search algorithms using Assembly language. The goal is to perform depth-first and breadth-first searches on binary trees stored in two different array representations and to provide functions for converting between these representations. The project demonstrates the use of tree search algorithms, binary tree representations, and conversion between depth-first (DFS) and breadth-first (BFS) storage methods.

## Objectives

1. **Depth-First Search (DFS)**: 
   - Implement DFS on trees stored in both depth-first and breadth-first representations.
   - Return the level at which the searched element is found, or -1 if the element is not found.

2. **Breadth-First Search (BFS)**:
   - Implement BFS on trees stored in both representations.
   - Ensure correct traversal of the tree and proper result formatting.

3. **Conversion Between Representations**:
   - Implement functions to convert between the depth-first and breadth-first representations of a binary tree.
   - Allow traversal and search operations to be performed seamlessly on both representations.

## Components

### Data Section
- **rep1**: A list of integers representing the binary tree in a depth-first order.
- **rep2**: A list of integers representing the binary tree in a breadth-first order.
- **rep2_len**: The length of the `rep1` array, representing the total number of elements in the tree.
- **index**: A counter used for indexing during conversions.

### Code Section
- **Main Program**: 
   The program initializes the arrays, checks if `rep1` is empty, and calls helper functions to convert and search the binary tree.
   
- **Helper Functions**:
   - **convertRep1ToRep2Helper**: Recursively converts the depth-first representation (`rep1`) to the breadth-first representation (`rep2`).
   - **convertRep2ToRep1Helper**: Recursively converts the breadth-first representation (`rep2`) to the depth-first representation (`rep1`).
   - **linear_search_rep1**: Searches for a value in the `rep1` array using a linear search and returns the index of the value.
   - **linear_search_rep2**: A linear search on `rep2` that utilizes conversion to `rep1` before performing the search.
   - **log_base_2**: A helper function to compute the logarithm base 2 of a number, used to determine the depth level during tree traversal.

## Instructions

1. **Running the Program**:
   - The program loads `rep1` and `rep2` arrays into memory and calls the respective functions for conversion and search.
   - It then checks whether `rep1` is null or empty. If not, it proceeds with conversion and search operations.
   - The program uses a recursive approach for converting between representations and a linear search algorithm for finding elements.

2. **Tree Representation**:
   - **Depth-First (DFS)**: The tree is stored in an array (`rep1`), where each node's children are stored in the subsequent indices following a depth-first traversal.
   - **Breadth-First (BFS)**: The tree is stored in another array (`rep2`), where each level of the tree is represented consecutively.

3. **Search Functions**:
   - The `linear_search_rep1` function performs a basic linear search on the depth-first representation of the tree (`rep1`).
   - The `linear_search_rep2` function first converts `rep2` to `rep1` and then performs the search on `rep1`.

4. **Conversion Functions**:
   - The `convertRep1ToRep2Helper` and `convertRep2ToRep1Helper` functions handle the conversion between depth-first and breadth-first tree representations recursively. These functions use the current index and perform calculations to map elements between the two arrays.

## Example Usage

### Depth-First Search on `rep1`:
The depth-first search (DFS) will traverse the tree starting from the root and move to the left child recursively before moving to the right child.

### Breadth-First Search on `rep2`:
The breadth-first search (BFS) will traverse the tree level by level from left to right.

### Search in `rep2` with Conversion:
- Perform a linear search on `rep2`, which is converted to `rep1` for the search to be executed.

## Expected Output

1. **Search Results**: The program will output the index or level at which the searched element is found or `-1` if the element is not in the tree.
   
2. **Converted Array**: The converted tree representation (`rep2`) will be printed after conversion from `rep1`.
