# DSA Pattern Recognition Cheat Sheet

## Arrays

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| **Contiguous subarray sum**, negatives allowed (⚠️ not for other sums)| Max/min subarray sum (value or indices) | N up to 10^5–10^6, negatives allowed | Check all subarrays (O(N²)) | Kadane's Algorithm | O(N) |
| Sort array of **N objects into K groups** in-place, O(N) (⚠️ not for generic sorting) | In-place partitioned/sorted array | K=3 typical, O(N) time, O(1) space | Comparison sort (O(N log N)) or counting sort with extra array (O(N) space) | Dutch National Flag | O(N) time, O(1) space |
| Element appears more than **N/2 times** (⚠️ not for most frequent) | The majority element | O(1) space, O(N) time, majority guaranteed | HashMap frequency count (O(N) space) | Moore's Voting Algorithm | O(N) time, O(1) space |
| Subarray/substring with a condition, contract/expand window | Max/min length, count, or the window itself | Contiguous segment, N up to 10^5 | Check all subarrays/substrings (O(N²)–O(N³)) | Sliding Window | O(N) |
| Sorted array, find pair/triplet with target sum | Pair/triplet (values or indices) | Array sorted (or sortable), N up to 10^5 | Nested loops (O(N²) for pair, O(N³) for triplet) | Two Pointers | O(N) for pair (post-sort O(N log N)), O(N²) for triplet |
| Multiple range sum queries | Sum for each query range | Q queries, static array, N,Q up to 10^5 | Recompute sum per query (O(N·Q)) | Prefix Sum | O(N) preprocess + O(1)/query |
| Multiple range update queries | Final array or queried values after updates | Range updates, point read at end | Update every element per range (O(N·Q)) | Difference Array | O(1)/update + O(N) rebuild |
| Search in rotated/sorted array, "find minimum X such that condition holds" | Index of target, or min/max value satisfying condition | Array sorted or rotated-sorted, O(log N) required | Linear scan (O(N)) | Binary Search (incl. Binary Search on Answer) | O(log N) |
| Overlapping intervals — merge, insert, count conflicts | Merged/inserted interval list, or conflict count | Intervals as [start,end], N up to 10^5 | Compare every pair of intervals (O(N²)) | Merge Intervals (sort by start) | O(N log N) |
| Numbers in range [1, N], find missing/duplicate, no extra space | Missing/duplicate number(s) | Values in [1,N], O(1) extra space | HashSet to track seen (O(N) space) or sort (O(N log N)) | Cyclic Sort | O(N) time, O(1) space |
| Matrix traversal in spiral/rotate in place/zero out rows & cols | Spiral-order list, rotated matrix, or modified matrix | In-place required for rotate, O(1) extra space sometimes | Build result in a new matrix (O(N²) space) | Matrix Patterns (boundary tracking, transpose+reverse) | O(N·M) |
| 3 or 4 elements summing to target | List of unique triplets/quadruplets | Need duplicate-free combinations, N up to ~10^4 | Triple/quadruple nested loops (O(N³)/O(N⁴)) | Two Pointers extended (3Sum/4Sum: fix one, two-pointer the rest) | O(N²) for 3Sum, O(N³) for 4Sum |
| Product/sum of array except self, or running min/max from both sides | Array of products/sums excluding self, or running min/max arrays | No division allowed (typical), O(N) time | For each index, loop over rest (O(N²)) | Prefix + Suffix Arrays | O(N) |

## Strings

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Longest palindromic substring | The substring (or its length) | N up to 10^3–10^4 | Check every substring for palindrome (O(N³)) | Expand Around Center (or DP) | O(N²) |
| Pattern matching in text efficiently | Index/indices of occurrence | Text length N, pattern length M | Naive matching (O(N·M)) | KMP / Rabin-Karp | O(N+M) |
| Anagram grouping/checking | Grouped lists of anagrams, or boolean | Lowercase strings, N strings of length K | Compare every pair via sort (O(N²·K log K)) | Hashing (sorted string or frequency map as key) | O(N·K) |
| Substring with all/no repeating characters, smallest window containing X | Length of longest/shortest valid substring | N up to 10^5 | Check all substrings (O(N²)–O(N³)) | Sliding Window + HashMap | O(N) |
| Word search in grid of words, autocomplete, longest common prefix | Boolean found, list of completions, or common prefix string | Many words, repeated prefix queries | Linear scan over all words per query (O(N·K)) | Trie | O(K) per insert/search |

## Stack

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Next greater/smaller element | Array of next greater/smaller values (or indices) | N up to 10^5, need sub-O(N²) | For each element scan the rest (O(N²)) | Monotonic Stack | O(N) |
| Valid parentheses, matching pairs | Boolean valid/invalid | String of bracket characters only | Repeatedly remove adjacent matching pairs (O(N²)) | Stack (push open, pop on close, check match) | O(N) |
| Undo, history tracking | Previous state after undo | Operations applied/undone in LIFO order | Store full history, recompute state (O(N)/undo) | Stack | O(1)/operation |
| Min/Max in O(1) | Current min/max value | O(1) time per getMin/getMax | Scan entire stack per query (O(N)) | Min/Max Stack (pair each element with running min/max) | O(1)/operation |
| Largest rectangle in histogram, max area in matrix of 1s | Max area value | N bars/cells | Expand left/right for each bar (O(N²)) | Monotonic Stack (extended) | O(N) |
| Evaluate expression, basic calculator, decode nested string | Evaluated number or decoded string | Expression with parentheses/operators/precedence | Recursive re-parsing of substrings (O(N²) or worse) | Two-Stack / Single-Stack with precedence handling | O(N) |

## Queue / Heap

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| BFS / level order traversal | Traversal order / level-wise list | Unweighted graph/tree | DFS + manual level tracking (O(N²) naive) | Queue | O(V+E) |
| Sliding window min/max | Array of min/max per window | Window size K, N up to 10^5 | Scan all K elements per window (O(N·K)) | Deque (Monotonic Queue) | O(N) |
| FIFO tracker | Elements in processed order | — | Array with shifting on dequeue (O(N)/op) | Queue | O(1)/operation |
| Top K elements, Kth largest, merge K sorted lists | Top-K list, Kth value, or merged list | N elements, K ≪ N | Sort entire input then pick (O(N log N)) | Heap / Priority Queue | O(N log K) |
| Running median | Median after each insertion | Online stream, queries interleaved with inserts | Sort array after every insertion (O(N log N)/insert) | Two Heaps (max-heap lower half, min-heap upper half) | O(log N)/insertion |
| Task scheduling with cooldown, reorganize string, meeting rooms II | Min time/slots, reorganized string, or min rooms needed | Frequency/cooldown constraints | Try all orderings/simulate (O(N²) or exponential) | Heap + Greedy | O(N log K) |
| Multi-source shortest distance on grid (rotting oranges, walls and gates) | Distance grid / time to cover all cells | Multiple sources, unweighted grid | BFS from each source separately (O(V·(V+E))) | Multi-Source BFS | O(V+E) |

## Linked List

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Detect cycle, find middle, find Kth from end | Boolean cycle / middle node / Kth node | O(1) extra space required | HashSet of visited nodes (O(N) space) | Fast & Slow Pointers | O(N) time, O(1) space |
| Reverse a list or sublist | Head of reversed list/sublist | O(1) extra space | Copy values to array, reverse, rebuild (O(N) space) | In-Place Reversal | O(N) time, O(1) space |
| Operations near head that might change it | New head of list | Head may change (insert/delete at head) | Special-case conditionals for head (error-prone) | Dummy Node | O(N) (simplifies edge cases, no T.C. gain) |
| Find intersection point of two lists | Intersection node (or null) | O(1) space, no modifying lists | Compare every node pair across both lists (O(N·M)) | Intersection Trick (realign after reaching null) | O(N+M) |
| Recently used cache with O(1) get/put | Value on get; cache updated on put | O(1) time for get and put | Array/list scan to find/evict (O(N)/op) | LRU Cache (Doubly Linked List + HashMap) | O(1)/operation |
| Merge K sorted lists | Head of merged sorted list | K lists, total N nodes | Collect all values, sort (O(N log N)) | Heap or Divide & Conquer merge | O(N log K) |
| Reverse in groups of K | Head of modified list | O(1) extra space | Convert to array, reverse chunks, rebuild (O(N) space) | In-Place Reversal, repeated per group | O(N) time, O(1) space |
| Clone a list with random pointers | Head of cloned list | Deep copy incl. random pointers | For each node, search for random target (O(N²)) | HashMap (old→new) or interleaving trick | O(N) |

## Trees

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Explore depth-first, path-based problems | Path, depth, or boolean condition | Tree/graph traversal needed | Repeated traversal per query (O(N²) naive) | DFS | O(N) |
| Level-by-level / depth-based problems | List of levels / depth value | — | DFS + depth recompute (O(N²) naive) | BFS | O(N) |
| Parent decision depends on children's results | Aggregated value (diameter, balanced bool, max path sum) | Need children's info before parent decision | Recompute subtree info from scratch per node (O(N²)) | Post-Order (Bottom-Up) Recursion | O(N) |
| Sorted-order property, left < node < right | Boolean / node found / Kth smallest | Tree is a BST | Inorder traversal then linear search (O(N)) | BST property (binary-search the tree) | O(H) ≈ O(log N) avg |
| Build tree from traversal arrays, or serialize/deserialize | Root of tree / serialized string / deserialized tree | Traversal arrays given (e.g., preorder+inorder) | Linear search for split index each recursion (O(N²)) | Tree Construction patterns | O(N) |
| Prefix-based word storage/lookup | Boolean exists / list of words with prefix | Many words, repeated prefix queries | Scan all words per query (O(N·K)) | Trie | O(K)/operation |

## Graph

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Shortest path, unweighted | Shortest distance/path | Unweighted edges | Try all paths via DFS (exponential) | BFS | O(V+E) |
| Deep exploration, cycle detection (directed) | Boolean cycle exists / traversal order | Directed graph | Check all paths for revisits (exponential) | DFS (recursion stack / 3-color marking) | O(V+E) |
| Valid ordering of dependent tasks (DAG) | Ordered list of nodes / boolean valid order exists | DAG (no cycles), dependency edges | Try all node permutations (O(V!)) | Topological Sort (Kahn's or DFS-based) | O(V+E) |
| Shortest path, weighted, no negative edges | Shortest distance to each node | Non-negative weights | Try all paths / relax all edges repeatedly (O(V·E)) | Dijkstra's Algorithm | O((V+E) log V) |
| Shortest path, negative edges allowed | Shortest distance to each node, or negative-cycle flag | Negative weights allowed | Try all paths (O(V!)) | Bellman-Ford | O(V·E) |
| Minimum cost to connect all nodes | Total cost / list of MST edges | Connected, weighted graph | Try all spanning trees (O(2^E)) | MST — Prim's or Kruskal's | O(E log V) |
| Cycle detection (undirected), grouping connected components, "redundant connection" | Boolean cycle exists / component count / redundant edge | Undirected graph | DFS/BFS from each node (O(V·(V+E))) | Union-Find (Disjoint Set Union) | ~O(E) amortized (path compression + union by rank) |
| Flood-fill style grid problems (number of islands) | Count of connected regions / region size | Grid of 0s/1s | Compare every cell against every other (O((R·C)²)) | DFS/BFS on grid as implicit graph | O(R·C) |
| Can the graph be 2-colored? | Boolean bipartite or not | Graph possibly disconnected | Try all 2-colorings (O(2^V)) | Bipartite Check (graph coloring via BFS/DFS) | O(V+E) |

## Dynamic Programming

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Choices at each step, optimal of overlapping subproblems, 1D state | Optimal value (min/max/ways) | N steps, overlapping subproblems | Plain recursion without memo (O(2^N)) | 1D DP (climbing stairs, house robber) | O(N) |
| Grid traversal with min/max cost or path counting | Min/max cost or number of paths | Grid of size R×C | Try all paths recursively (O(2^(R+C))) | 2D Grid DP | O(R·C) |
| Pick/skip items under a capacity constraint | Max value / min cost / boolean subset exists | N items, capacity W | Try all subsets (O(2^N)) | Knapsack (0/1, unbounded, subset-sum) | O(N·W) |
| Comparing two sequences | Length of LCS / min edit operations | Two strings of length M, N | Try all subsequences/operations (O(2^(M+N))) | LCS / Edit Distance family | O(M·N) |
| Find longest increasing/valid subsequence | Length (or contents) of LIS | N up to 10^5 | Check all subsequences (O(2^N)) or plain DP (O(N²)) | LIS (and O(N log N) variant via binary search) | O(N log N) |
| Ways to make a target value with given denominations | Min coins / number of ways | Coins array, target amount | Try all combinations recursively (exponential) | Coin Change (combinations vs permutations) | O(N·Amount) |
| Divide array/string into valid parts minimizing/maximizing something | Min cuts/cost or max partition value | N elements, partition constraint | Try all partition points recursively (O(2^N)) | Partition DP | O(N²) |
| Counting distinct subsequences, palindromic substrings/subsequences | Count of subsequences/substrings, or LPS length | String of length N | Generate all subsequences/substrings (O(2^N)/O(N²) check) | DP on Subsequences/Substrings (interval DP) | O(N²) |
| State + decision at each index, with a "skip with cooldown" type constraint | Max profit / optimal value | N elements, multiple states (buy/sell/cooldown) | Try all buy/sell sequences recursively (O(2^N)) | State Machine DP (stock buy/sell variants) | O(N) |

## Backtracking

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Generate all permutations/combinations/subsets | List of all permutations/combinations/subsets | N small (≤15–20), output itself exponential | Exhaustive generation without pruning (same order) | Backtracking with choose-explore-unchoose | O(N·2^N) for subsets, O(N·N!) for permutations |
| Place items under constraints (N-Queens, Sudoku) | Valid placement(s) / count of solutions | Board size N, row/col/diagonal constraints | Try every placement without pruning (O(N^N)) | Constraint-based Backtracking with pruning | Exponential, pruned (e.g. much better than O(N^N) for N-Queens) |
| Generate all valid sequences (parentheses, IP addresses) | List of all valid sequences | Length N, per-step validity rule | Generate all sequences then filter (O(2^N·N)) | Backtracking with validity check at each step | ~O(4^N / N^1.5) for parentheses (Catalan growth) |
| Find all paths/words in a grid | List of all paths / boolean word exists | Grid R×C, word length L | Try every path with no pruning (O(4^(R·C))) | Backtracking + visited-marking (often combined with DFS) | O(R·C·4^L) typical |

## Bit Manipulation

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Find the single/unique number among duplicates | The unique element | O(1) space, O(N) time, others appear even number of times | HashMap frequency count (O(N) space) | XOR trick | O(N) time, O(1) space |
| Count set bits, power-of-two checks | Count of set bits / boolean power-of-two | Need fast bit-level check | Convert to binary string and count (O(log N)) | Bit tricks (n & (n-1), Brian Kernighan) | O(number of set bits) or O(1) |
| Generate all subsets | List of all subsets | N ≤ 20 (2^N grows fast) | Recursive subset generation (same complexity) | Bitmask iteration (0 to 2^N - 1) | O(N·2^N) |

## Hashing

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Need O(1) lookup/frequency count instead of brute force | Boolean exists / count / value | — | Linear search per lookup (O(N²) overall) | HashMap/HashSet as default first optimization | O(1) avg/operation |
| Two-sum style "does complement exist" | Pair of indices/values | N elements, single pass desired | Nested loop over all pairs (O(N²)) | HashMap of seen values | O(N) |

## Greedy

| Signal | What to Return | Constraint | Brute Force Approach (T.C.) | Technique | Technique's T.C. |
|---|---|---|---|---|---|
| Local optimal choice provably leads to global optimal | Optimal value/sequence of choices | Greedy-choice property must hold (exchange argument) | Try all combinations of choices (O(2^N)/O(N!)) | Greedy (activity selection, jump game, gas station) | O(N) or O(N log N) |
| Interval scheduling to maximize count / minimize resources | Max non-overlapping intervals / min resources needed | Intervals with start/end times | Try all subsets of intervals (O(2^N)) | Greedy + sort by start/end | O(N log N) |
