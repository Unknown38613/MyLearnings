| Main Pattern         | Sub-pattern                   | What to return                          | When to use / Clue                        | Brute Force T.C | Optimized T.C |
| -------------------- | ----------------------------- | --------------------------------------- | ----------------------------------------- | --------------- | ------------- |
| Sliding Window       | Fixed Size Window             | Max/min/count in window                 | "Every k elements", window size given     | O(N*K)          | O(N)          |
| Sliding Window       | Variable Size (Shrink/Expand) | Longest/shortest valid window           | Longest substring/subarray with condition | O(N²)           | O(N)          |
| Sliding Window       | Count of Valid Windows        | Number of subarrays/substrings          | "How many subarrays satisfy..."           | O(N²)           | O(N)          |
| Sliding Window       | Frequency Window              | Longest substring with chars constraint | Character count, anagrams                 | O(N²)           | O(N)          |
| Two Pointer          | Opposite Direction            | Pair sum, triplet                       | Sorted array + target                     | O(N²)           | O(N)          |
| Two Pointer          | Same Direction (Slow/Fast)    | Modify/remove elements                  | Remove duplicates, move zeros             | O(N²)           | O(N)          |
| Two Pointer          | Merge Intervals style         | Combined ranges                         | Overlapping ranges                        | O(N²)           | O(NlogN)      |
| Two Pointer          | 3Sum / 4Sum                   | Triplets/quads                          | Sorted + target combinations              | O(N³/N⁴)        | O(N²/N³)      |
| HashMap + Prefix Sum | Prefix Sum + Frequency Map    | Count subarrays                         | Sum = K, negatives allowed                | O(N²)           | O(N)          |
| HashMap + Prefix Sum | Prefix XOR                    | Count XOR ranges                        | XOR target problems                       | O(N²)           | O(N)          |
| HashMap + Prefix Sum | Prefix Product                | Product constraints                     | Product based subarrays                   | O(N²)           | O(N)          |
| HashMap              | Frequency Counting            | Most frequent/duplicates                | Counting occurrences                      | O(N²)           | O(N)          |
| Tree DFS/BFS         | DFS Traversal                 | Visit/process nodes                     | Pre/In/Post order                         | O(N)            | O(N)          |
| Tree DFS/BFS         | Height / Depth                | Height, balance                         | Need subtree info                         | O(N)            | O(N)          |
| Tree DFS/BFS         | Path Problems                 | Max path, root-to-leaf                  | "Path", "sum", "distance"                 | O(N²)           | O(N)          |
| Tree DFS/BFS         | Lowest Common Ancestor        | Common ancestor                         | Two nodes relationship                    | O(N²)           | O(N)          |
| Tree DFS/BFS         | Tree Diameter                 | Longest path                            | Distance between nodes                    | O(N²)           | O(N)          |
| Tree DFS/BFS         | Level Order BFS               | Level-wise result                       | "Each level", minimum depth               | O(N)            | O(N)          |
| Graph BFS/DFS        | DFS Components                | Number of islands/components            | Connectivity                              | O(V²)           | O(V+E)        |
| Graph BFS/DFS        | BFS Shortest Path             | Minimum steps                           | Unweighted graph                          | O(V²)           | O(V+E)        |
| Graph BFS/DFS        | Cycle Detection               | Cycle exists?                           | Directed/undirected graph                 | O(V²)           | O(V+E)        |
| Graph BFS/DFS        | Topological Sort              | Ordering                                | Dependencies/prerequisites                | O(V²)           | O(V+E)        |
| Graph BFS/DFS        | Flood Fill                    | Modified grid                           | Matrix traversal                          | O(N²)           | O(N²)         |
| Binary Search        | Classic Search                | Index                                   | Sorted array                              | O(N)            | O(logN)       |
| Binary Search        | First/Last Occurrence         | Position                                | Duplicates present                        | O(N)            | O(logN)       |
| Binary Search        | Search Rotated Array          | Index                                   | Rotated sorted array                      | O(N)            | O(logN)       |
| Binary Search        | Binary Search on Answer       | Minimum/maximum possible                | "Minimize maximum", monotonic             | O(N*answer)     | O(NlogAnswer) |
| Binary Search        | Peak Finding                  | Peak index                              | Local maximum                             | O(N)            | O(logN)       |
| Linked List          | Reverse Linked List           | Modified list                           | Reverse nodes                             | O(N)            | O(N)          |
| Linked List          | Fast/Slow Pointer             | Middle/cycle                            | Two speed pointers                        | O(N)            | O(N)          |
| Linked List          | Merge Lists                   | Combined list                           | Sorted lists                              | O(N)            | O(N)          |
| Linked List          | Reverse in K Group            | Modified chunks                         | Reverse every k nodes                     | O(N)            | O(N)          |
| Linked List          | Intersection                  | Common node                             | Two linked lists merge                    | O(N²)           | O(N)          |
| Stack                | Parenthesis Matching          | Valid/invalid                           | Brackets                                  | O(N)            | O(N)          |
| Stack                | Monotonic Increasing          | Next smaller                            | Histogram, stock span                     | O(N²)           | O(N)          |
| Stack                | Monotonic Decreasing          | Next greater                            | NGE, daily temperatures                   | O(N²)           | O(N)          |
| Stack                | Expression Evaluation         | Value                                   | Calculator problems                       | O(N)            | O(N)          |
| Heap                 | Top K Elements                | K largest/smallest                      | Ranking problems                          | O(NlogN)        | O(NlogK)      |
| Heap                 | Kth Element                   | kth value                               | Median/order statistics                   | O(NlogN)        | O(NlogK)      |
| Heap                 | Two Heap Median               | Median                                  | Streaming numbers                         | O(NlogN)        | O(logN)       |
| Backtracking         | Subsets                       | All subsets                             | Pick/not pick                             | O(2^N)          | O(2^N)        |
| Backtracking         | Permutations                  | All arrangements                        | Ordering matters                          | O(N!)           | O(N!)         |
| Backtracking         | Combination Sum               | Valid combinations                      | Target sum                                | O(2^N)          | O(2^N)        |
| Backtracking         | Grid Backtracking             | Paths                                   | Maze/word search                          | O(4^N)          | O(4^N)        |
| DP                   | 1D DP                         | Best answer till i                      | Fibonacci, house robber                   | O(2^N)          | O(N)          |
| DP                   | 2D DP                         | Grid/state answer                       | Matrix, strings                           | O(2^(N+M))      | O(NM)         |
| DP                   | Knapsack DP                   | Max value                               | Pick/not pick items                       | O(2^N)          | O(NW)         |
| DP                   | LIS Pattern                   | Longest sequence                        | Increasing subsequence                    | O(N²)           | O(NlogN)      |
| DP                   | String DP                     | Matching/editing                        | LCS, edit distance                        | O(3^N)          | O(NM)         |
| Greedy               | Sorting + Pick                | Minimum/maximum                         | Interval scheduling                       | O(N²)           | O(NlogN)      |
| Greedy               | Local Choice                  | Best next move                          | Activity/job problems                     | O(N²)           | O(NlogN)      |
| Greedy               | Two Pointer Greedy            | Optimize pairing                        | Boats, containers                         | O(NlogN)        | O(N)          |
| Trie                 | Prefix Trie                   | Search/prefix                           | Dictionary problems                       | O(N*M)          | O(M)          |
| Trie                 | Bit Trie                      | XOR maximum                             | Max XOR pair                              | O(N²)           | O(N*bits)     |
| Bit Manipulation     | XOR Pattern                   | Unique element                          | Appears odd times                         | O(N)            | O(1)          |
| Bit Manipulation     | Bit Counting                  | Count set bits                          | Binary properties                         | O(N*bits)       | O(N)          |
| Bit Manipulation     | Masking                       | Subsets/state                           | Small N combinations                      | O(2^N)          | O(2^N)        |
| Strings              | Frequency Count               | Count/compare characters         | Anagram, ransom note, character frequency | O(N²)           | O(N)          |
| Strings              | HashMap + String              | Longest/count substring          | Repeated chars, unique chars              | O(N²)           | O(N)          |
| Strings              | Sliding Window String         | Longest/shortest substring       | "Substring + condition"                   | O(N²)           | O(N)          |
| Strings              | Two Pointer String           | Modified string/check palindrome | Left-right comparison                     | O(N)            | O(N)          |
| Strings              | Palindrome Check             | Boolean/result string            | Palindrome, almost palindrome             | O(N)            | O(N)          |
| Strings      | Palindrome Expansion         | Longest palindrome               | Center expansion clue                     | O(N²)           | O(N²)         |
| Strings      | String Matching              | Index/occurrence                 | Find pattern in text                      | O(N*M)          | O(N+M) (KMP)  |
| Strings      | Subsequence Pattern          | Boolean/count                    | "Can form", order matters                 | O(N*M)          | O(N)          |
| Strings      | Longest Common Subsequence   | Length/string                    | Two strings comparison                    | O(2^(N+M))      | O(NM)         |
| Strings      | Edit Distance                | Minimum operations               | Insert/delete/replace                     | O(3^(N+M))      | O(NM)         |
| Strings      | String DP                    | Count/optimal answer             | Repeated states in strings                | Exponential     | O(NM)         |
| Strings      | Stack Based                  | Remove/construct string          | Remove duplicates, decode string          | O(N²)           | O(N)          |
| Strings      | Parsing String               | Extract values                   | Numbers, expressions                      | O(N²)           | O(N)          |
| Strings      | Character Replacement Window | Longest valid string             | Replace ≤ K chars                         | O(N²)           | O(N)          |
| Strings      | Grouping Strings             | Bucketing                        | Group anagrams, patterns                  | O(N²)           | O(N*K)        |
| Strings      | Trie String Search           | Prefix/search                    | Dictionary words                          | O(N*M)          | O(M)          |
| Strings      | Rolling Hash                 | Substring search                 | Duplicate substring                       | O(N*M)          | O(N) avg      |
