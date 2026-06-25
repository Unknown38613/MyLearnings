| Main Pattern         | Sub-pattern               | What to return          | When to use / Clue             | Brute Force T.C | Optimized T.C |
| -------------------- | ------------------------- | ----------------------- | ------------------------------ | --------------- | ------------- |
| Sliding Window       | Fixed Size Window         | Max/min/count in window | "Size K", fixed window         | O(N*K)          | O(N)          |
| Sliding Window       | Variable Size Window      | Longest/shortest window | Subarray/substring + condition | O(N²)           | O(N)          |
| Sliding Window       | Count Valid Windows       | Number of valid ranges  | Count substrings/subarrays     | O(N²)           | O(N)          |
| Sliding Window       | Frequency Window (String) | Longest substring/count | Character constraints          | O(N²)           | O(N)          |
| Sliding Window       | Character Replacement     | Longest valid substring | Replace ≤ K chars              | O(N²)           | O(N)          |
| Sliding Window       | Anagram Window            | Starting indices/count  | Pattern matching in string     | O(N*M)          | O(N)          |
| Two Pointer          | Opposite Direction        | Pair/triplet/index      | Sorted array + target          | O(N²)           | O(N)          |
| Two Pointer          | Same Direction            | Modify array/string     | Remove duplicates, move zeros  | O(N²)           | O(N)          |
| Two Pointer          | 3Sum                      | Triplets                | Sorted + target                | O(N³)           | O(N²)         |
| Two Pointer          | 4Sum                      | Quadruplets             | Sorted + target                | O(N⁴)           | O(N³)         |
| Two Pointer          | Palindrome Check (String) | True/False              | Compare ends                   | O(N)            | O(N)          |
| Two Pointer          | Merge Intervals           | Combined ranges         | Overlapping intervals          | O(N²)           | O(NlogN)      |
| Prefix Sum + HashMap | Subarray Sum              | Count/length            | Sum K, negatives allowed       | O(N²)           | O(N)          |
| Prefix Sum + HashMap | Prefix XOR                | Count ranges            | XOR target                     | O(N²)           | O(N)          |
| Prefix Sum + HashMap | Frequency Prefix          | Balance/count           | Equal zeros/ones etc           | O(N²)           | O(N)          |
| HashMap              | Frequency Count           | Count occurrences       | Anagram, duplicates            | O(N²)           | O(N)          |
| HashMap              | Grouping Pattern          | Groups                  | Group anagrams                 | O(N²)           | O(N*K)        |
| Tree DFS/BFS         | DFS Traversal             | Nodes/result            | Tree processing                | O(N)            | O(N)          |
| Tree DFS/BFS         | Height/Depth              | Height                  | Subtree info                   | O(N)            | O(N)          |
| Tree DFS/BFS         | Diameter                  | Longest path            | Max distance                   | O(N²)           | O(N)          |
| Tree DFS/BFS         | Path Sum                  | Path/value              | Root-leaf or any path          | O(N²)           | O(N)          |
| Tree DFS/BFS         | Lowest Common Ancestor    | Common node             | Relationship between nodes     | O(N²)           | O(N)          |
| Tree DFS/BFS         | Level Order BFS           | Level result            | Each level/min depth           | O(N)            | O(N)          |
| Graph DFS/BFS        | Components                | Number of groups        | Islands/connectivity           | O(V²)           | O(V+E)        |
| Graph DFS/BFS        | BFS Shortest Path         | Minimum distance        | Unweighted graph               | O(V²)           | O(V+E)        |
| Graph DFS/BFS        | Cycle Detection           | Cycle exists            | Directed/undirected            | O(V²)           | O(V+E)        |
| Graph DFS/BFS        | Topological Sort          | Ordering                | Dependencies                   | O(V+E)          | O(V+E)        |
| Binary Search        | Normal Search             | Index                   | Sorted array                   | O(N)            | O(logN)       |
| Binary Search        | First/Last Position       | Boundary                | Duplicates                     | O(N)            | O(logN)       |
| Binary Search        | Rotated Array             | Index                   | Rotated sorted array           | O(N)            | O(logN)       |
| Binary Search        | Search Answer             | Min/max value           | Monotonic answer               | O(N*Ans)        | O(NlogAns)    |
| Linked List          | Reverse List              | Modified list           | Reverse nodes                  | O(N)            | O(N)          |
| Linked List          | Fast Slow Pointer         | Middle/cycle            | Pointer speed                  | O(N)            | O(N)          |
| Linked List          | Intersection              | Common node             | Merge point                    | O(N²)           | O(N)          |
| Linked List          | Merge Lists               | Sorted list             | Combine lists                  | O(N)            | O(N)          |
| Linked List          | Reverse K Group           | Modified chunks         | Reverse batches                | O(N)            | O(N)          |
| Stack                | Parentheses Validation    | Valid/invalid           | Brackets                       | O(N)            | O(N)          |
| Stack                | Monotonic Increasing      | Next smaller            | Histogram, stock span          | O(N²)           | O(N)          |
| Stack                | Monotonic Decreasing      | Next greater            | NGE, temperatures              | O(N²)           | O(N)          |
| Stack                | String Stack              | Construct string        | Remove chars, decode           | O(N²)           | O(N)          |
| Heap                 | Top K                     | K elements              | Ranking                        | O(NlogN)        | O(NlogK)      |
| Heap                 | Kth Element               | kth value               | Order statistics               | O(NlogN)        | O(NlogK)      |
| Heap                 | Two Heap Median           | Median                  | Streaming values               | O(NlogN)        | O(logN)       |
| Backtracking         | Subsets                   | All subsets             | Pick/not pick                  | O(2^N)          | O(2^N)        |
| Backtracking         | Permutations              | All orders              | Arrangement                    | O(N!)           | O(N!)         |
| Backtracking         | Combination Sum           | Valid combos            | Target based                   | O(2^N)          | O(2^N)        |
| Backtracking         | Grid Search               | Paths                   | Maze/word search               | O(4^N)          | O(4^N)        |
| Dynamic Programming  | 1D DP                     | Best till i             | Fibonacci, robber              | O(2^N)          | O(N)          |
| Dynamic Programming  | 2D DP                     | Matrix states           | Grid/string                    | Exponential     | O(NM)         |
| Dynamic Programming  | Knapsack                  | Max value               | Pick/not pick                  | O(2^N)          | O(NW)         |
| Dynamic Programming  | LIS                       | Longest sequence        | Increasing order               | O(N²)           | O(NlogN)      |
| Dynamic Programming  | LCS                       | Common sequence         | Two strings                    | O(2^N)          | O(NM)         |
| Dynamic Programming  | Edit Distance             | Operations              | Convert string                 | O(3^N)          | O(NM)         |
| Greedy               | Sorting + Selection       | Best choice             | Local optimum                  | O(N²)           | O(NlogN)      |
| Greedy               | Interval Greedy           | Maximum activities      | Scheduling                     | O(N²)           | O(NlogN)      |
| Trie                 | Prefix Search             | Word/prefix             | Dictionary                     | O(N*M)          | O(M)          |
| Trie                 | Bit Trie                  | Max XOR                 | Binary representation          | O(N²)           | O(N*bits)     |
| String               | Pattern Matching (KMP)    | Match index             | Find substring                 | O(NM)           | O(N+M)        |
| String               | Rolling Hash              | Duplicate substring     | Hash comparison                | O(NM)           | O(N) avg      |
| String               | Parsing                   | Extract/compute         | Numbers/operators              | O(N)            | O(N)          |
| Bit Manipulation     | XOR Pattern               | Unique element          | Odd occurrence                 | O(N)            | O(1)          |
| Bit Manipulation     | Bit Counting              | Set bits                | Binary properties              | O(N*bits)       | O(N)          |
| Bit Manipulation     | Bit Masking               | States/subsets          | Small N                        | O(2^N)          | O(2^N)        |
