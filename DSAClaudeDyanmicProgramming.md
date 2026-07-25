## Dynamic Programming

**1. 1D DP — linear sequence decisions**
- [Climbing Stairs — LC 70](https://leetcode.com/problems/climbing-stairs/)
```
class Solution {
    private int[] memo;
    public int climbStairs(int n) {
        if(n == 1) return 1;
        memo = new int[n + 1];
        return climb(n);
    }
    private int climb(int n){
        if(n < 0) return 0;
        if(n == 0) return 1;
        if(memo[n] != 0) return memo[n];
        return memo[n] = climb(n - 1) + climb(n - 2);
    }
}
```
```
class Solution {
    public int climbStairs(int n) {
        int[] dp = new int[n + 1];
        dp[0] = 1;
        dp[1] = 1;
        if(n < 2) return dp[n];
        for(int i = 2 ; i <= n ; i++){
            dp[i] = dp[i - 1] + dp[i - 2];
        }
        return dp[n];
    }
}
```
- [House Robber — LC 198](https://leetcode.com/problems/house-robber/)
```
class Solution {
    private int[] memo;
    private int robber(int i, int[] nums){
        if(i >= nums.length) return 0;
        if(memo[i] != -1) return memo[i];
        int pick = nums[i] + robber(i + 2, nums);
        int skip = robber(i + 1, nums);
        return memo[i] = Math.max(pick, skip);
    }
    public int rob(int[] nums) {
        memo = new int[nums.length + 1];
        Arrays.fill(memo, -1);
        return robber(0, nums);
    }
}
```
```
class Solution {
    public int rob(int[] nums) {
        int n = nums.length;
        int[] dp = new int[n + 1];
        dp[0] = nums[0];
        //⚠️ if only one house
        if(n == 1) return dp[0];
        dp[1] = Math.max(nums[0], nums[1]);
        for(int i = 2 ; i < n ; i++){
            dp[i] = Math.max(nums[i] + dp[i - 2], dp[i - 1]);
        }
        return dp[n - 1];
    }
}
```
- [House Robber II (circular) — LC 213](https://leetcode.com/problems/house-robber-ii/)
```
```

**2. Kadane's / subarray DP**
- [Maximum Subarray — LC 53](https://leetcode.com/problems/maximum-subarray/)
```
```
- [Maximum Product Subarray — LC 152](https://leetcode.com/problems/maximum-product-subarray/)
```
```

**3. 0/1 Knapsack pattern**
- [Partition Equal Subset Sum — LC 416](https://leetcode.com/problems/partition-equal-subset-sum/)
```
```
- [Target Sum — LC 494](https://leetcode.com/problems/target-sum/)
```
```
- [Coin Change (min coins, unbounded knapsack variant) — LC 322](https://leetcode.com/problems/coin-change/)
```
```
- [Coin Change II (count ways, unbounded) — LC 518](https://leetcode.com/problems/coin-change-ii/)
```
```

**4. Longest Common Subsequence family (2D grid DP over two strings)**
- [Longest Common Subsequence — LC 1143](https://leetcode.com/problems/longest-common-subsequence/)
```
```
- [Edit Distance — LC 72](https://leetcode.com/problems/edit-distance/)
```
```
- [Distinct Subsequences — LC 115](https://leetcode.com/problems/distinct-subsequences/)
```
```

**5. Longest Increasing Subsequence pattern**
- [Longest Increasing Subsequence (O(n log n) variant important) — LC 300](https://leetcode.com/problems/longest-increasing-subsequence/)
```
```
- [Russian Doll Envelopes (LIS in 2D) — LC 354](https://leetcode.com/problems/russian-doll-envelopes/)
```
```

**6. Palindromic DP**
- [Longest Palindromic Substring — LC 5](https://leetcode.com/problems/longest-palindromic-substring/)
```
```
- [Longest Palindromic Subsequence — LC 516](https://leetcode.com/problems/longest-palindromic-subsequence/)
```
```
- [Palindrome Partitioning II (min cuts) — LC 132](https://leetcode.com/problems/palindrome-partitioning-ii/)
```
```

**7. Grid/path DP**
- [Unique Paths — LC 62](https://leetcode.com/problems/unique-paths/)
```
```
- [Minimum Path Sum — LC 64](https://leetcode.com/problems/minimum-path-sum/)
```
```
- [Dungeon Game (reverse DP) — LC 174](https://leetcode.com/problems/dungeon-game/)
```
```

**8. Interval DP (decisions over subranges, merge point)**
- [Burst Balloons — LC 312](https://leetcode.com/problems/burst-balloons/)
```
```
- [Matrix Chain Multiplication style — Minimum Cost to Merge Stones — LC 1000](https://leetcode.com/problems/minimum-cost-to-merge-stones/)
```
```

**9. DP on stocks (state machine DP)**
- [Best Time to Buy and Sell Stock II — LC 122](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-ii/)
```
```
- [Best Time to Buy and Sell Stock with Cooldown — LC 309](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)
```
```
- [Best Time to Buy and Sell Stock III (k=2 transactions) — LC 123](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iii/)
```
```

**10. Bitmask DP**
- [Partition to K Equal Sum Subsets — LC 698](https://leetcode.com/problems/partition-to-k-equal-sum-subsets/)
```
```
- [Shortest Path Visiting All Nodes — LC 847](https://leetcode.com/problems/shortest-path-visiting-all-nodes/)
```
```

**11. DP on trees**
- [House Robber III — LC 337](https://leetcode.com/problems/house-robber-iii/)
```
```
- [Binary Tree Maximum Path Sum (DP-flavored, not classic but good practice) — LC 124](https://leetcode.com/problems/binary-tree-maximum-path-sum/)
```
```

**12. Digit DP / counting DP (less common in Indian product interviews but shows up occasionally)**
- [Count Numbers with Unique Digits — LC 357](https://leetcode.com/problems/count-numbers-with-unique-digits/)
```
```
