## Backtracking

**1. Subsets / Combinations (include-exclude choice)**
- Subsets — LC 78
```
class Solution {
    public List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        recurse(0, new ArrayList<>(), res, nums);
        return res;
    }
    private void recurse(int i, List<Integer> curr, List<List<Integer>> res, int[] nums){
        if(i == nums.length){
            res.add(new ArrayList<>(curr));
            return;
        }
        curr.add(nums[i]);
        recurse(i + 1, curr, res, nums);
        curr.remove(curr.size() - 1);
        recurse(i + 1, curr, res, nums);
    }
}
```
- Subsets II (with duplicates) — LC 90
```
class Solution {
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> res = new ArrayList<>();
        recurse(0, new ArrayList<>(), nums, res);
        return res;
    }
    private void recurse(int start, List<Integer> curr, int[] nums, List<List<Integer>> res){
        res.add(new ArrayList<>(curr));
        for(int j = start; j < nums.length; j++){
            //⚠️not duplicate number but duplicate choice at same level
            //is the second choice also on same start level?
            if(j > start && nums[j] == nums[j - 1]) continue;
            curr.add(nums[j]);
            recurse(j + 1, curr, nums, res);
            curr.remove(curr.size() - 1);
        }
    }
}
```
- Combinations — LC 77
```
class Solution {
    public List<List<Integer>> combine(int n, int k) {
        int[] nums = new int[n];
        List<List<Integer>> res = new ArrayList<>();
        for(int i = 0 ; i < n ; i++){
            nums[i] = i + 1;
        }
        recurse(0, k, nums, new ArrayList<>(), res);
        return res;
    }
    private void recurse(int start, int k, int[] nums, List<Integer> curr,List<List<Integer>> res){
        if(curr.size() == k){
            res.add(new ArrayList<>(curr));
            return;
        }
        for(int j = start ; j < nums.length ; j++){
            curr.add(nums[j]);
            recurse(j + 1, k, nums, curr, res);
            curr.remove(curr.size() - 1);
        }
    }
}
```

**2. Permutations (order matters, swap/visited-based)**
- Permutations — LC 46
```
class Solution {
    public List<List<Integer>> permute(int[] nums) {
        int n = nums.length;
        boolean[] visited = new boolean[n];
        Arrays.fill(visited, false);
        List<List<Integer>> res = new ArrayList<>();
        recurse(0, nums, new ArrayList<>(), visited, res);
        return res;
    }
    private void recurse(int start, int[] nums, List<Integer> curr, boolean[] visited, List<List<Integer>> res){
        if(start == nums.length){
            res.add(new ArrayList<>(curr));
            return;
        }
        for(int j = 0 ; j < nums.length ; j++){
            if(visited[j] == true) continue;
            visited[j] = true;
            curr.add(nums[j]);
            recurse(start + 1, nums, curr, visited, res);
            visited[j] = false;
            curr.remove(curr.size() - 1);
        }
    }
}
```
- Permutations II (with duplicates) — LC 47
```
class Solution {
    public List<List<Integer>> permuteUnique(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> res = new ArrayList<>();
        boolean[] visited = new boolean[nums.length];
        recurse(0, nums, new ArrayList<>(), res, visited);
        return res;
    }
    private void recurse(int i, int[] nums, List<Integer> curr, List<List<Integer>> res, boolean[] visited){
        if(i == nums.length){
            res.add(new ArrayList<>(curr));
            return;
        }
        for(int j = 0 ; j < nums.length ; j++){
            //only pick second copy when first copy is picked at same level
            if(j > 0 && nums[j] == nums[j - 1] && !visited[j - 1]) continue;
            if(visited[j] == true) continue;
            visited[j] = true;
            curr.add(nums[j]);
            recurse(i + 1, nums, curr, res, visited);
            visited[j] = false;
            curr.remove(curr.size() - 1);
        }
    }
}
```

**3. Target sum / combination search (choose repeatedly until target)**
- Combination Sum — LC 39
```
```
- Combination Sum II — LC 40
```
```
- Combination Sum III — LC 216
```
```

**4. Partitioning (split input into valid pieces)**
- Palindrome Partitioning — LC 131
```
```
- Restore IP Addresses — LC 93
```
```

**5. Constraint satisfaction on a grid/board (place, check, undo)**
- N-Queens — LC 51
```
```
- Sudoku Solver — LC 37
```
```

**6. Word search on grid (DFS + backtrack with visited marking)**
- Word Search — LC 79
```
```
- Word Search II (Trie + backtracking) — LC 212
```
```

**7. String construction / matching with backtracking**
- Letter Combinations of a Phone Number — LC 17
```
```
- Generate Parentheses — LC 22
```
```


## Dynamic Programming

**1. 1D DP — linear sequence decisions**
- Climbing Stairs — LC 70
```
```
- House Robber — LC 198
```
```
- House Robber II (circular) — LC 213
```
```

**2. Kadane's / subarray DP**
- Maximum Subarray — LC 53
```
```
- Maximum Product Subarray — LC 152
```
```

**3. 0/1 Knapsack pattern**
- Partition Equal Subset Sum — LC 416
```
```
- Target Sum — LC 494
```
```
- Coin Change (min coins, unbounded knapsack variant) — LC 322
```
```
- Coin Change II (count ways, unbounded) — LC 518
```
```

**4. Longest Common Subsequence family (2D grid DP over two strings)**
- Longest Common Subsequence — LC 1143
```
```
- Edit Distance — LC 72
```
```
- Distinct Subsequences — LC 115
```
```

**5. Longest Increasing Subsequence pattern**
- Longest Increasing Subsequence (O(n log n) variant important) — LC 300
```
```
- Russian Doll Envelopes (LIS in 2D) — LC 354
```
```

**6. Palindromic DP**
- Longest Palindromic Substring — LC 5
```
```
- Longest Palindromic Subsequence — LC 516
```
```
- Palindrome Partitioning II (min cuts) — LC 132
```
```

**7. Grid/path DP**
- Unique Paths — LC 62
```
```
- Minimum Path Sum — LC 64
```
```
- Dungeon Game (reverse DP) — LC 174
```
```

**8. Interval DP (decisions over subranges, merge point)**
- Burst Balloons — LC 312
```
```
- Matrix Chain Multiplication style — Minimum Cost to Merge Stones — LC 1000
```
```

**9. DP on stocks (state machine DP)**
- Best Time to Buy and Sell Stock II — LC 122
```
```
- Best Time to Buy and Sell Stock with Cooldown — LC 309
```
```
- Best Time to Buy and Sell Stock III (k=2 transactions) — LC 123
```
```

**10. Bitmask DP**
- Partition to K Equal Sum Subsets — LC 698
```
```
- Shortest Path Visiting All Nodes — LC 847
```
```

**11. DP on trees**
- House Robber III — LC 337
```
```
- Binary Tree Maximum Path Sum (DP-flavored, not classic but good practice) — LC 124
```
```

**12. Digit DP / counting DP (less common in Indian product interviews but shows up occasionally)**
- Count Numbers with Unique Digits — LC 357
```
```

## Graphs

**1. Basic Traversal (BFS/DFS foundations)**
- Number of Islands — LC 200
```
```
- Flood Fill — LC 733
```
```
- Max Area of Island — LC 695
```
```

**2. Connected Components / Union-Find**
- Number of Provinces — LC 547
```
```
- Graph Valid Tree — LC 261 (premium, but pattern is common — Redundant Connection LC 684 is the free equivalent)
```
```
- Accounts Merge — LC 721
```
```

**3. Topological Sort (dependency ordering — very common in interviews)**
- Course Schedule — LC 207
```
```
- Course Schedule II — LC 210
```
```
- Alien Dictionary — LC 269 (premium equivalent pattern very popular at product companies — practice via "Foreign Dictionary" on GfG/Coding Ninjas if LC is locked)
```
```

**4. Shortest Path — Unweighted (BFS)**
- Rotting Oranges — LC 994
```
```
- 01 Matrix — LC 542
```
```
- Word Ladder — LC 127
```
```

**5. Shortest Path — Weighted (Dijkstra)**
- Network Delay Time — LC 743
```
```
- Path with Minimum Effort — LC 1631
```
```
- Cheapest Flights Within K Stops (Bellman-Ford variant) — LC 787
```
```

**6. Minimum Spanning Tree**
- Min Cost to Connect All Points — LC 1584
```
```

**7. Bipartite / Graph Coloring**
- Is Graph Bipartite — LC 785
```
```
- Possible Bipartition — LC 886
```
```

**8. Cycle Detection**
- Course Schedule (directed cycle via DFS) — LC 207
```
```
- Detect Cycle in Undirected Graph (via Union-Find, same idea as LC 684)
```
```

**9. Multi-source BFS**
- Rotting Oranges — LC 994 (also fits here)
```
```
- Walls and Gates — LC 286 (premium equivalent: "01 Matrix" LC 542)
```
```

**10. Grid-as-graph DFS/backtracking hybrid**
- Number of Distinct Islands — LC 694 (premium; good pattern to at least read)
```
```
- Surrounded Regions — LC 130
```
```

**11. Union-Find advanced (used a lot at Flipkart/Amazon LLD-adjacent rounds)**
- Number of Islands II — LC 305 (premium; dynamic connectivity)
```
```
- Satisfiability of Equality Equations — LC 990
```
```

**12. Eulerian Path / Hard graph construction (rare but occasionally asked at strong product companies)**
- Reconstruct Itinerary — LC 332
```
```


## Arrays


**1. Two Pointers (opposite ends)**
- Two Sum II (sorted) — LC 167
```
```
- Container With Most Water — LC 11
```
```
- Trapping Rain Water — LC 42
```
```

**2. Two Pointers (same direction / fast-slow)**
- Remove Duplicates from Sorted Array — LC 26
```
```
- Move Zeroes — LC 283
```
```

**3. Sliding Window (fixed size)**
- Maximum Sum Subarray of Size K (GfG classic; LC equivalent: Maximum Average Subarray I — LC 643)
```
```

**4. Sliding Window (variable size)**
- Longest Substring Without Repeating Characters — LC 3
```
```
- Minimum Size Subarray Sum — LC 209
```
```
- Longest Substring with At Most K Distinct Characters — LC 340 (premium; free equivalent: Fruit Into Baskets — LC 904)
```
```

**5. Prefix Sum**
- Subarray Sum Equals K — LC 560
```
```
- Product of Array Except Self — LC 238
```
```
- Range Sum Query — Immutable — LC 303
```
```

**6. Kadane's Algorithm (subarray optimization)**
- Maximum Subarray — LC 53
```
```
- Maximum Circular Subarray Sum — LC 918
```
```

**7. Sorting-based greedy**
- Merge Intervals — LC 56
```
```
- Non-overlapping Intervals — LC 435
```
```
- Meeting Rooms II — LC 253 (premium; free equivalent: Insert Interval — LC 57 for practice)
```
```

**8. Binary Search on Answer (very common at Razorpay/PhonePe SDE rounds)**
- Koko Eating Bananas — LC 875
```
```
- Capacity to Ship Packages Within D Days — LC 1011
```
```
- Split Array Largest Sum — LC 410
```
```

**9. Binary Search on Rotated/Modified Arrays**
- Search in Rotated Sorted Array — LC 33
```
```
- Find Minimum in Rotated Sorted Array — LC 153
```
```

**10. Cyclic Sort (missing/duplicate number patterns)**
- Find the Duplicate Number — LC 287
```
```
- First Missing Positive — LC 41
```
```

**11. In-place array manipulation**
- Rotate Array — LC 189
```
```
- Next Permutation — LC 31
```
```

**12. Matrix as array (common warm-up round question)**
- Rotate Image — LC 48
```
```
- Spiral Matrix — LC 54
```
```
- Set Matrix Zeroes — LC 73
```
```

**13. Merge/Multi-array**
- Merge Sorted Array — LC 88
```
```
- Merge k Sorted Lists (arrays variant with heap) — LC 23
```
```

**14. Monotonic Stack (often bucketed under arrays, comes up a lot)**
- Next Greater Element I — LC 496
```
```
- Daily Temperatures — LC 739
```
```
- Largest Rectangle in Histogram — LC 84
```
```

**15. Greedy on Arrays**
- Jump Game — LC 55
```
```
- Jump Game II — LC 45
```
```
- Gas Station — LC 134
```
```


## Tree / BST — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Maximum Depth of Binary Tree — LC 104 | Warm-up, but also the base recursion template for everything else |
| Diameter of Binary Tree — LC 543 | Classic "return two things from recursion" pattern, asked everywhere |
| Balanced Binary Tree — LC 110 | Tests bottom-up recursion discipline |
| Binary Tree Level Order Traversal — LC 102 | BFS-on-tree template, extremely common |
| Validate BST — LC 98 | Tests bounds-passing recursion, classic "gotcha" question |
| Lowest Common Ancestor of a Binary Tree — LC 236 | Asked at almost every company, very high recurrence |
| LCA of a BST — LC 235 | Simpler variant, but interviewers expect you to know the BST-specific optimization |
| Binary Tree Right Side View — LC 199 | Common level-order variant, tests view-based thinking |
| Serialize and Deserialize Binary Tree — LC 297 | Google/Amazon favorite, tests full traversal + reconstruction mastery |
| Kth Smallest Element in a BST — LC 230 | Tests inorder-traversal-as-sorted-sequence insight |
| Construct Binary Tree from Preorder and Inorder — LC 105 | Very common, tests deep traversal-index reasoning |
| Path Sum II / Binary Tree Maximum Path Sum — LC 113, 124 | 124 especially — Amazon/Google favorite, tests global-max-during-recursion pattern |

## LinkedList — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Reverse Linked List — LC 206 | THE base template, must be instant/reflexive |
| Merge Two Sorted Lists — LC 21 | Extremely common, also a building block for merge sort on lists |
| Linked List Cycle (I & II) — LC 141, 142 | Floyd's cycle detection, asked constantly, high "gotcha" value |
| Remove Nth Node From End — LC 19 | Classic two-pointer-on-list, common at Amazon/Microsoft |
| Reorder List — LC 143 | Tests combining reverse + merge + find-middle in one problem |
| Add Two Numbers — LC 2 | Very common, tests carry/edge-case handling |
| Copy List with Random Pointer — LC 138 | Frequently asked, tests hashmap-based cloning |
| Merge k Sorted Lists — LC 23 | Heap + linked list combo, common at senior-leaning SDE-1 rounds |
| LRU Cache — LC 146 | Technically a design question but built on doubly linked list + hashmap — asked relentlessly at product companies |

## Heap / Priority Queue — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Kth Largest Element in an Array — LC 215 | The canonical heap-selection problem |
| Top K Frequent Elements — LC 347 | Extremely common, hashmap + heap combo |
| Merge k Sorted Lists — LC 23 | Also belongs here — heap-of-pointers pattern |
| Find Median from Data Stream — LC 295 | Two-heap pattern, very frequently asked at Google/Amazon |
| K Closest Points to Origin — LC 973 | Common, tests custom comparator usage |
| Task Scheduler — LC 621 | Greedy + heap combo, asked at Amazon/Flipkart |

## Intervals — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Merge Intervals — LC 56 | Already flagged, but truly foundational to this category |
| Insert Interval — LC 57 | Common follow-up variant to Merge Intervals |
| Non-overlapping Intervals — LC 435 | Greedy-on-intervals template |
| Meeting Rooms II — LC 253 (premium; practice via Insert Interval + heap logic) | Asked constantly at Amazon/Microsoft in disguised forms (meeting room, resource allocation) |

## Stack — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Valid Parentheses — LC 20 | Absolute baseline, must be reflexive |
| Min Stack — LC 155 | Very common design-with-stack question |
| Daily Temperatures — LC 739 | Monotonic stack template |
| Next Greater Element I — LC 496 | Same pattern, simpler entry point |
| Largest Rectangle in Histogram — LC 84 | Hard but genuinely asked at Google/Amazon, strong signal question |
| Evaluate Reverse Polish Notation — LC 150 | Common, tests stack-based expression evaluation |
| Basic Calculator II — LC 227 | Frequently asked at Amazon/Microsoft, tests operator precedence handling |

## Trie — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Implement Trie (Prefix Tree) — LC 208 | You must be able to build this from scratch without hesitation |
| Word Search II — LC 212 | Trie + backtracking combo, very common at product companies |
| Design Add and Search Words Data Structure — LC 211 | Tests trie with wildcard search, frequently asked |

## Greedy — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Jump Game — LC 55 | Base greedy-reachability template |
| Gas Station — LC 134 | Classic greedy proof-based question, asked often |
| Non-overlapping Intervals — LC 435 | Also core here — greedy-by-sorting template |
| Candy — LC 135 | Common two-pass greedy, tests handling conflicting constraints |
| Partition Labels — LC 763 | Frequent, simple but tests greedy-interval insight |

## Bit Manipulation — Non-negotiable

| Problem | Why it's unavoidable |
|---|---|
| Single Number — LC 136 | XOR trick, extremely common warm-up/filler question |
| Number of 1 Bits — LC 191 | Basic but frequently tested for fundamentals check |
| Counting Bits — LC 338 | DP + bit manipulation combo, common at Amazon |
| Sum of Two Integers (without + or -) — LC 371 | Tests real bitwise arithmetic understanding, asked at Google/Microsoft |
| Missing Number — LC 268 | XOR/math trick, very common |
