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
class Solution {
    private int[] memo;
    private int robber(int i, int j, int[] nums, int offset){
        if(i > j) return 0;
        if(memo[offset + i] != -1) return memo[offset + i];
        int pick = nums[i] + robber(i + 2, j, nums, offset);
        int skip = robber(i + 1, j, nums, offset);
        return memo[offset + i] = Math.max(pick, skip);
    }
    public int rob(int[] nums) {
        int n = nums.length;
        if(n == 1) return nums[0];
        //⚠️ offset trick because same memo is used twice
        // or else redeclare memo
        memo = new int[2*n + 1];
        Arrays.fill(memo, -1);
        int rob1 = robber(0, n - 2, nums, 0);
        int rob2 = robber(1, n - 1, nums, n);
        return Math.max(rob1, rob2);
    }
}
```
```
class Solution {
    public int rob(int[] nums) {
        int n = nums.length;

        if (n == 1) return nums[0];

        int rob1 = robRange(nums, 0, n - 2);

        int rob2 = robRange(nums, 1, n - 1);

        return Math.max(rob1, rob2);
    }

    private int robRange(int[] nums, int start, int end) {
        int len = end - start + 1;

        if (len == 1) return nums[start];

        int[] dp = new int[len];

        dp[0] = nums[start];
        dp[1] = Math.max(nums[start], nums[start + 1]);

        for (int i = start + 2; i <= end; i++) {
            //⚠️ array always index from 0
            int dpIdx = i - start;
            dp[dpIdx] = Math.max(dp[dpIdx - 1], nums[i] + dp[dpIdx - 2]);
        }

        return dp[len - 1];
    }
}
```

**2. Kadane's / subarray DP**
- [Maximum Subarray — LC 53](https://leetcode.com/problems/maximum-subarray/)
```
class Solution {
    //⚠️ Negative number so Integer
    private Integer[] memo;
    public int maxSubArray(int[] nums) {
        int n = nums.length;
        int maxSum = nums[0];
        memo = new Integer[n + 1];

        for(int i = 1 ; i < n ; i++){
            maxSum = Math.max(maxSum, solve(nums, i));
        }

        return maxSum;
    }
    // Maximum subarray sum ending at i
    private int solve(int[] nums, int i){
        if(i == 0) return nums[i];
        if(memo[i] != null) return memo[i];
        int currSum = Math.max(nums[i] + solve(nums, i - 1), nums[i]);
        return memo[i] = currSum;
    }
}
```
```
class Solution {
    public int maxSubArray(int[] nums) {
        int n = nums.length;
        int maxSum = nums[0];
        int currSum = nums[0];
        for(int i = 1 ; i < n ; i++){
            currSum = Math.max(currSum + nums[i], nums[i]);
            maxSum = Math.max(maxSum, currSum);
        }
        return maxSum;
    }
}
```
- [Maximum Product Subarray — LC 152](https://leetcode.com/problems/maximum-product-subarray/)

```
class Solution {
    public int maxProduct(int[] nums) {
        int n = nums.length;
        int maxSoFar = nums[0];
       //in sum we can avoid negative number
       //but in product 2 negative number gives large positive number
        int minSoFar = nums[0];
        int maxProd = nums[0];

        for(int i = 1 ; i < n ; i++){
            //⚠️ multiply by negative flips max to min 
            //and min to max number
            if(nums[i] < 0){
                int temp = maxSoFar;
                maxSoFar = minSoFar;
                minSoFar = temp;
            }

            maxSoFar = Math.max(maxSoFar*nums[i], nums[i]);
            minSoFar = Math.min(minSoFar*nums[i], nums[i]);

            maxProd = Math.max(maxProd, maxSoFar);
        }

        return maxProd;
    }
}
```

**3. 0/1 Knapsack pattern**
- [Partition Equal Subset Sum — LC 416](https://leetcode.com/problems/partition-equal-subset-sum/)
```
class Solution {
    //⚠️ avoid confusion between computed false and pre-filled false
    private Boolean[][] memo;
    public boolean canPartition(int[] nums) {
        int n = nums.length;
        int sum = nums[0];
        for(int i = 1 ; i < n ; i++) sum += nums[i];
        //if sum is odd then cannot be divided in 2 halves
        if(sum % 2 != 0) return false;
        int target = sum / 2;
        memo = new Boolean[n][target + 1];
        return recurse(0, target, nums);
    }
    private boolean recurse(int i, int target, int[] nums){
        if(target == 0) return true;
        if(target < 0 || i >= nums.length) return false;
        if(memo[i][target] != null) return memo[i][target];

        boolean pick = recurse(i + 1, target - nums[i], nums);
        boolean skip = recurse(i + 1, target, nums);

        return memo[i][target] = pick || skip;
    }
}
```
```
class Solution {
    
    public boolean canPartition(int[] nums) {
        int n = nums.length;
        int sum = nums[0];
        for(int i = 1 ; i < n ; i++) sum += nums[i];
        //if sum is odd then cannot be divided in 2 halves
        if(sum % 2 != 0) return false;
        int target = sum / 2;

        //memo handles base case but table needs it so n + 1
        boolean[][] dp = new boolean[n + 1][target + 1];
        //Can I make sum 0 using elements from i onward?
        for(int i = 0 ; i <= n ; i++){
            dp[i][0] = true;
        }

        for(int i = n - 1 ; i >= 0 ; i--){
            for(int t = 1 ; t <= target ; t++){
                boolean skip = dp[i + 1][t];
                boolean pick = false;
                //⚠️ avoid negative indexing
                if(t >= nums[i]){
                    pick = dp[i + 1][t - nums[i]];
                }
                dp[i][t] = pick || skip;
            }
        }

        return dp[0][target];
    }
}
```
- [Target Sum — LC 494](https://leetcode.com/problems/target-sum/)
```
class Solution {
    private Integer[][] memo;
    public int findTargetSumWays(int[] nums, int target) {
        int n = nums.length;
        int sum = nums[0];
        for(int i = 1 ; i < n ; i++) sum += nums[i];
        if(Math.abs(target) > sum) return 0;
        //target range = -sum to +sum, so use offset
        memo = new Integer[n][2*sum + 1];
        return recurse(0, nums, target, sum);
    }
    private int recurse(int i, int[] nums, int target, int sum){
        //⚠️ we don't stop at target because we assign operator to each number
        if(i == nums.length) return target == 0 ? 1 : 0;
        if(Math.abs(target) > sum) return 0;
        if(memo[i][target + sum] != null) return memo[i][target + sum];
        int add = recurse(i + 1, nums, target - nums[i], sum);
        int sub = recurse(i + 1, nums, target + nums[i], sum);
        return memo[i][target + sum] = add + sub;
    }
}
```
```
class Solution {
    public int findTargetSumWays(int[] nums, int target) {
        int n = nums.length;
        int sum = nums[0];
        for(int i = 1 ; i < n ; i++) sum += nums[i];
        if(Math.abs(target) > sum) return 0;
        //target range = -sum to +sum, so use offset
        int[][] dp = new int[n + 1][2*sum + 1];
        int offset = sum;
        
        //base case: if (i == n) return target == 0 ? 1 : 0;
        dp[n][0 + offset] = 1;

        for(int i = n - 1 ; i >= 0 ; i--){
            for(int t = -sum ; t <= sum ; t++){

                int add = 0;
                if(t - nums[i] >= -sum){
                    add = dp[i + 1][t - nums[i] + offset];
                }
                int sub = 0;
                if(t + nums[i] <= sum){
                    sub = dp[i + 1][t + nums[i] + offset];
                }
                dp[i][t + offset] = add + sub;
            }
        }

        return dp[0][target + offset];
    }
}
```
- [Coin Change (min coins, unbounded knapsack variant) — LC 322](https://leetcode.com/problems/coin-change/)
```
class Solution {
    private static final int INF = (int) 1e9;
    private Integer[][] memo;
    public int coinChange(int[] coins, int amount) {
        int n = coins.length;
        memo = new Integer[n][amount + 1];
        int ans = recurse(0, coins, amount);
        return ans == INF ? -1 : ans;
    }
    private int recurse(int i, int[] coins, int amount){
        //⚠️ dealing with no. of coins not ways so 0 coins needed
        if(amount == 0) return 0;
        //⚠️ invalid case : return max value so it never becomes answer
        if(amount < 0 || i >= coins.length) return INF;
        if(memo[i][amount] != null) return memo[i][amount];
        //⚠️ pick a coin
        int pick = 1 + recurse(i, coins, amount - coins[i]);
        int skip = recurse(i + 1, coins, amount);

        return memo[i][amount] = Math.min(pick, skip);
    }
}
```
```
class Solution {
    private static final int INF = (int) 1e9;
    public int coinChange(int[] coins, int amount) {
        int n = coins.length;
        int[][] dp = new int[n + 1][amount + 1];
        //⚠️ in min problems initialize with max
        for(int[] row : dp){
            Arrays.fill(row, INF);
        }
        //Amount 0 needs 0 coins of any type
        for(int i = 0 ; i < n ; i++){
            dp[i][0] = 0;
        }
        
        for(int i = n - 1 ; i >= 0 ; i--){
            for(int a = 1 ; a <= amount ; a++){
                //⚠️choose the value based on evaluation condition
                int pick = INF;
                if(a >= coins[i]){
                    pick = 1 + dp[i][a - coins[i]];
                }
                int skip = dp[i + 1][a];
                dp[i][a] = Math.min(pick, skip);
            }
        }

        return dp[0][amount] == INF ? -1 : dp[0][amount];
    }
}
```
- [Coin Change II (count ways, unbounded) — LC 518](https://leetcode.com/problems/coin-change-ii/)
```
class Solution {
    private Integer[][] memo;
    public int change(int amount, int[] coins) {
        int n = coins.length;
        memo = new Integer[n][amount + 1];
        int ans = recurse(0, coins, amount);
        return ans;
    }
    private int recurse(int i, int[] coins, int amount){
        //⚠️ number of ways/combinations that make up amount
        if(amount == 0) return 1;
        if(amount < 0 || i >= coins.length) return 0;
        if(memo[i][amount] != null) return memo[i][amount];
        int pick = recurse(i, coins, amount - coins[i]);
        int skip = recurse(i + 1, coins, amount);
        return memo[i][amount] = pick + skip;
    }
}
```
```
class Solution {
    public int change(int amount, int[] coins) {
        int n = coins.length;
        int[][] dp = new int[n + 1][amount + 1];
        for(int i = 0 ; i < n ; i++){
            dp[i][0] = 1;
        }

        for(int i = n - 1 ; i >= 0 ; i--){
            for(int a = 1 ; a <= amount ; a++){
                int pick = 0;
                if(a >= coins[i]){
                    pick = dp[i][a - coins[i]];
                }
                int skip = dp[i + 1][a];
                dp[i][a] = pick + skip;
            }
        }

        return dp[0][amount];
    }
}
```

**4. Longest Common Subsequence family (2D grid DP over two strings)**
- [Longest Common Subsequence — LC 1143](https://leetcode.com/problems/longest-common-subsequence/)
```
class Solution {
    private Integer[][] memo;
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length();
        int n = text2.length();
        memo = new Integer[m][n];
        int ans = LCS(0, 0, text1, text2);
        return ans;
    }
    private int LCS(int t1, int t2, String text1, String text2){
        if(t1 == text1.length() || t2 == text2.length()){
            return 0;
        }
        if(memo[t1][t2] != null) return memo[t1][t2];
        int ans = -1;
        if(text1.charAt(t1) == text2.charAt(t2)){
            ans = 1 + LCS(t1 + 1, t2 + 1, text1, text2);
        }
        else{
            //⚠️ while skipping we can skip either, not both
            // else we will miss valid combination
            ans = Math.max(
                LCS(t1 + 1, t2, text1, text2),
                LCS(t1, t2 + 1, text1, text2)
            );
        }
        return memo[t1][t2] = ans;
    }
}
```
```
class Solution {
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length();
        int n = text2.length();
        int[][] dp = new int[m + 1][n + 1];
        dp[m][n] = 0;

        for(int i = m - 1 ; i >= 0 ; i--){
            for(int j = n - 1 ; j >= 0 ; j--){
                if(text1.charAt(i) == text2.charAt(j)){
                    dp[i][j] = 1 + dp[i + 1][j + 1];
                }
                else{
                    dp[i][j] = Math.max(dp[i + 1][j], dp[i][j + 1]);
                }
            }
        }

        return dp[0][0]; 
    }
}
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
