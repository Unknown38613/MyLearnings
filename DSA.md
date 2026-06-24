# DSA Pattern Recognition Cheat Sheet

## Arrays

| Signal | Technique |
|---|---|
| Contiguous subarray sum, negatives allowed | Kadane's Algorithm |
| Sort array of N objects into K groups in-place, O(N) | Dutch National Flag |
| Element appears more than N/2 times | Moore's Voting Algorithm |
| Subarray/substring with a condition, contract/expand window | Sliding Window |
| Sorted array, find pair/triplet with target sum | Two Pointers |
| Multiple range sum queries | Prefix Sum |
| Multiple range update queries | Difference Array |
| Search in rotated/sorted array, "find minimum X such that condition holds" | Binary Search (incl. Binary Search on Answer) |
| Overlapping intervals — merge, insert, count conflicts | Merge Intervals (sort by start) |
| Numbers in range [1, N], find missing/duplicate, no extra space | Cyclic Sort |
| Matrix traversal in spiral/rotate in place/zero out rows & cols | Matrix Patterns (boundary tracking, transpose+reverse) |
| 3 or 4 elements summing to target | Two Pointers extended (3Sum/4Sum: fix one, two-pointer the rest) |
| Product/sum of array except self, or running min/max from both sides | Prefix + Suffix Arrays |

## Strings

| Signal | Technique |
|---|---|
| Longest palindromic substring | Expand Around Center (or DP) |
| Pattern matching in text efficiently | KMP / Rabin-Karp |
| Anagram grouping/checking | Hashing (sorted string or frequency map as key) |
| Substring with all/no repeating characters, smallest window containing X | Sliding Window + HashMap |
| Word search in grid of words, autocomplete, longest common prefix | Trie |

## Stack

| Signal | Technique |
|---|---|
| Next greater/smaller element | Monotonic Stack |
| Valid parentheses, matching pairs | Stack (push open, pop on close, check match) |
| Undo, history tracking | Stack |
| Min/Max in O(1) | Min/Max Stack (pair each element with running min/max) |
| Largest rectangle in histogram, max area in matrix of 1s | Monotonic Stack (extended) |
| Evaluate expression, basic calculator, decode nested string | Two-Stack / Single-Stack with precedence handling |

## Queue / Heap

| Signal | Technique |
|---|---|
| BFS / level order traversal | Queue |
| Sliding window min/max | Deque (Monotonic Queue) |
| FIFO tracker | Queue |
| Top K elements, Kth largest, merge K sorted lists | Heap / Priority Queue |
| Running median | Two Heaps (max-heap for lower half, min-heap for upper half) |
| Task scheduling with cooldown, reorganize string, meeting rooms II | Heap + Greedy |
| Multi-source shortest distance on grid (rotting oranges, walls and gates) | Multi-Source BFS |

## Linked List

| Signal | Technique |
|---|---|
| Detect cycle, find middle, find Kth from end | Fast & Slow Pointers |
| Reverse a list or sublist | In-Place Reversal |
| Operations near head that might change it | Dummy Node |
| Find intersection point of two lists | Intersection Trick (realign after reaching null) |
| Recently used cache with O(1) get/put | LRU Cache (Doubly Linked List + HashMap) |
| Merge K sorted lists | Heap or Divide & Conquer merge |
| Reverse in groups of K | In-Place Reversal, repeated per group |
| Clone a list with random pointers | HashMap (old→new) or interleaving trick |

## Trees

| Signal | Technique |
|---|---|
| Explore depth-first, path-based problems | DFS |
| Level-by-level / depth-based problems | BFS |
| Parent decision depends on children's results | Post-Order (Bottom-Up) Recursion — also generalizes to diameter, balanced-check, max path sum, not just LCA |
| Sorted-order property, left < node < right | BST property (binary-search the tree) |
| Build tree from traversal arrays, or serialize/deserialize | Tree Construction patterns |
| Prefix-based word storage/lookup | Trie |

## Graph

| Signal | Technique |
|---|---|
| Shortest path, unweighted | BFS |
| Deep exploration, cycle detection (directed) | DFS |
| Valid ordering of dependent tasks (DAG) | Topological Sort |
| Shortest path, weighted, no negative edges | Dijkstra's Algorithm |
| Shortest path, negative edges allowed | Bellman-Ford |
| Minimum cost to connect all nodes | MST — Prim's or Kruskal's |
| Cycle detection (undirected), grouping connected components, "redundant connection" | Union-Find (Disjoint Set Union) |
| Flood-fill style grid problems (number of islands) | DFS/BFS on grid as implicit graph |
| Can the graph be 2-colored? | Bipartite Check (graph coloring via BFS/DFS) |


## Dynamic Programming

| Signal | Technique |
|---|---|
| Choices at each step, optimal of overlapping subproblems, 1D state | 1D DP (climbing stairs, house robber) |
| Grid traversal with min/max cost or path counting | 2D Grid DP |
| Pick/skip items under a capacity constraint | Knapsack (0/1, unbounded, subset-sum) |
| Comparing two sequences | LCS / Edit Distance family |
| Find longest increasing/valid subsequence | LIS (and its O(N log N) variant via binary search) |
| Ways to make a target value with given denominations | Coin Change (combinations vs permutations) |
| Divide array/string into valid parts minimizing/maximizing something | Partition DP |
| Counting distinct subsequences, palindromic substrings/subsequences | DP on Subsequences/Substrings (interval DP) |
| State + decision at each index, with a "skip with cooldown" type constraint | State Machine DP (stock buy/sell variants) |

## Backtracking

| Signal | Technique |
|---|---|
| Generate all permutations/combinations/subsets | Backtracking with choose-explore-unchoose |
| Place items under constraints (N-Queens, Sudoku) | Constraint-based Backtracking with pruning |
| Generate all valid sequences (parentheses, IP addresses) | Backtracking with validity check at each step |
| Find all paths/words in a grid | Backtracking + visited-marking (often combined with DFS) |

## Bit Manipulation

| Signal | Technique |
|---|---|
| Find the single/unique number among duplicates | XOR trick |
| Count set bits, power-of-two checks | Bit tricks (n & (n-1), Brian Kernighan) |
| Generate all subsets | Bitmask iteration (0 to 2^N - 1) |

## Hashing

| Signal | Technique |
|---|---|
| Need O(1) lookup/frequency count instead of brute force | HashMap/HashSet as default first optimization |
| Two-sum style "does complement exist" | HashMap of seen values |

## Greedy

| Signal | Technique |
|---|---|
| Local optimal choice provably leads to global optimal | Greedy (activity selection, jump game, gas station) |
| Interval scheduling to maximize count / minimize resources | Greedy + sort by start/end |


## Notes
- This list prioritizes **pattern recognition** — matching a problem's shape to a technique — over rote memorization of solutions.
- DP and Backtracking deserve dedicated practice sets; they're the two biggest gaps when a DSA prep plan is structured purely around data structures.
- Union-Find and Trie are small in scope but show up disproportionately often relative to how rarely they're taught alongside "graph" and "tree" basics.
