## Arrays
**0. Hashing / Array Fundamentals**
- [Two Sum — LC 1](https://leetcode.com/problems/two-sum/description/) ⭐
```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        int n = nums.length;
        Map<Integer, Integer> map = new HashMap<>();

        for(int i = 0 ; i < n ; i++){
            int complement = target - nums[i];

            if(map.containsKey(complement)){
                return new int[]{map.get(complement), i};
            }
            else{
                map.put(nums[i], i);
            }
        }

        return new int[]{};
    }
}
```
- [Contains Duplicate — LC 217](https://leetcode.com/problems/contains-duplicate/description/)
```java
class Solution {
    public boolean containsDuplicate(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for(int n : nums){
            if(set.contains(n)) return true;
            set.add(n);
        }
        return false;
    }
}
```
- [Best Time to Buy and Sell Stock — LC 121](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/description/) ⭐
```java
class Solution {
    public int maxProfit(int[] prices) {
        int profit = 0;
        int buy = prices[0];
        int n = prices.length;

        for(int i = 1 ; i < n ; i++){
            int sellprice = prices[i];
            if(sellprice < buy) buy = sellprice;
            else profit = Math.max(profit, sellprice - buy);
        }

        return profit;
    }
}
```
- [Longest Consecutive Sequence — LC 128](https://leetcode.com/problems/longest-consecutive-sequence/description/) ⭐
```java
class Solution {
    public int longestConsecutive(int[] nums) {
        int n = nums.length;
        Set<Integer> set = new HashSet<>();
        int maxlength = 0;
        for(int i = 0 ; i < n ; i++){
            set.add(nums[i]);
        }
        //⚠️ iterating over nums means duplicate items being considered again
        for (int current : set) {
            if (!set.contains(current - 1)) {
                int currlength = 1;

                while (set.contains(current + 1)) {
                    current++;
                    currlength++;
                }

                maxlength = Math.max(maxlength, currlength);
            }
        }

        return maxlength;
    }
}
```
- [Majority Element — LC 169](https://leetcode.com/problems/majority-element/description/)
```java
class Solution {
    public int majorityElement(int[] nums) {
        int n = nums.length;
        int vote = 1;
        int candidate = nums[0];
        
        //Boyer-Moore Majority Vote 
        for(int i = 1 ; i < n ; i++){
            int next = nums[i];
            if(next == candidate) vote += 1;
            else vote -= 1;

            if(vote == 0){
                candidate = next;
                vote = 1;
            }
        }

        return candidate;
    }
}
```
- [Group Anagrams — LC 49](https://leetcode.com/problems/group-anagrams/description/) ⭐
```java
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        List<List<String>> ansList = new ArrayList<>();
        Map<String, List<String>> map = new HashMap<>();
        for(String s : strs){
            char[] sarr = s.toCharArray();
            Arrays.sort(sarr);
            String sorted = new String(sarr);
            map.computeIfAbsent(sorted, k -> new ArrayList<>()).add(s);
        }

        for(List<String> value : map.values()){
            ansList.add(value);
        }

        return ansList;
    }
}
```

**1. Two Pointers (opposite ends)**
- [Two Sum II (sorted) — LC 167](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/) ⭐
```java
```
- [Container With Most Water — LC 11](https://leetcode.com/problems/container-with-most-water/) ⭐
```java
```
- [Trapping Rain Water — LC 42](https://leetcode.com/problems/trapping-rain-water/) ⭐
```java
```
- [3Sum — LC 15](https://leetcode.com/problems/3sum/description/) ⭐
```java
```
- [Valid Palindrome — LC 125](https://leetcode.com/problems/valid-palindrome/description/)
```java
```

**2. Two Pointers (same direction / fast-slow)**
- [Remove Duplicates from Sorted Array — LC 26](https://leetcode.com/problems/remove-duplicates-from-sorted-array/)
```java
```
- [Move Zeroes — LC 283](https://leetcode.com/problems/move-zeroes/)
```java
```

**3. Sliding Window (fixed size)**
- [Maximum Average Subarray I — LC 643](https://leetcode.com/problems/maximum-average-subarray-i/)
```java
```

**4. Sliding Window (variable size)**
- [Longest Substring Without Repeating Characters — LC 3](https://leetcode.com/problems/longest-substring-without-repeating-characters/) ⭐
```java
```
- [Minimum Size Subarray Sum — LC 209](https://leetcode.com/problems/minimum-size-subarray-sum/) ⭐
```java
```
- [Longest Substring with At Most K Distinct Characters — LC 340 (Premium)](https://leetcode.com/problems/longest-substring-with-at-most-k-distinct-characters/)
```java
```
- [Longest Repeating Character Replacement — LC 424](https://leetcode.com/problems/longest-repeating-character-replacement/) ⭐
```java
```
- [Permutation in String — LC 567](https://leetcode.com/problems/permutation-in-string/) ⭐
```java
```
- [Minimum Window Substring — LC 76](https://leetcode.com/problems/minimum-window-substring/) ⭐
```java
```
- [Max Consecutive Ones III — LC 1004](https://leetcode.com/problems/max-consecutive-ones-iii/)
```java
```
- [Sliding Window Maximum — LC 239](https://leetcode.com/problems/sliding-window-maximum/) ⭐
```java
```

**5. Prefix Sum**
- [Subarray Sum Equals K — LC 560](https://leetcode.com/problems/subarray-sum-equals-k/) ⭐
```java
```
- [Product of Array Except Self — LC 238](https://leetcode.com/problems/product-of-array-except-self/) ⭐
```java
```
- [Range Sum Query - Immutable — LC 303](https://leetcode.com/problems/range-sum-query-immutable/)
```java
```
- [Continuous Subarray Sum — LC 523](https://leetcode.com/problems/continuous-subarray-sum/)
```java
```
- [Subarray Sums Divisible by K — LC 974](https://leetcode.com/problems/subarray-sums-divisible-by-k/)
```java
```

**6. Kadane's Algorithm (subarray optimization)**
- [Maximum Subarray — LC 53](https://leetcode.com/problems/maximum-subarray/) ⭐
```java
```
- [Maximum Circular Subarray Sum — LC 918](https://leetcode.com/problems/maximum-sum-circular-subarray/)
```java
```
- [Maximum Product Subarray — LC 152](https://leetcode.com/problems/maximum-product-subarray/) ⭐
```java
```

**8. Binary Search on Answer**
- [Koko Eating Bananas — LC 875](https://leetcode.com/problems/koko-eating-bananas/) ⭐
```java
```
- [Capacity to Ship Packages Within D Days — LC 1011](https://leetcode.com/problems/capacity-to-ship-packages-within-d-days/) ⭐
```java
```
- [Split Array Largest Sum — LC 410](https://leetcode.com/problems/split-array-largest-sum/)
```java
```

**9. Binary Search on Rotated/Modified Arrays**
- [Search in Rotated Sorted Array — LC 33](https://leetcode.com/problems/search-in-rotated-sorted-array/) ⭐
```java
```
- [Find Minimum in Rotated Sorted Array — LC 153](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/) ⭐
```java
```
- [Median of Two Sorted Arrays — LC 4](https://leetcode.com/problems/median-of-two-sorted-arrays/)
```java
```


**10. Cyclic Sort (missing/duplicate number patterns)**
- [Find the Duplicate Number — LC 287](https://leetcode.com/problems/find-the-duplicate-number/) ⭐
```java
```
- [First Missing Positive — LC 41](https://leetcode.com/problems/first-missing-positive/) ⭐
```java
```
- [Missing Number — LC 268](https://leetcode.com/problems/missing-number/)
```java
```
- [Find All Numbers Disappeared in an Array — LC 448](https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/)
```java
```
- [Find All Duplicates in an Array — LC 442](https://leetcode.com/problems/find-all-duplicates-in-an-array/)
```java
```

**11. In-place array manipulation**
- [Rotate Array — LC 189](https://leetcode.com/problems/rotate-array/) ⭐
```java
```
- [Next Permutation — LC 31](https://leetcode.com/problems/next-permutation/) ⭐
```java
```
- [Sort Colors — LC 75](https://leetcode.com/problems/sort-colors/) ⭐
```java
```

**12. Matrix as array (common warm-up round question)**
- [Rotate Image — LC 48](https://leetcode.com/problems/rotate-image/) ⭐
```java
```
- [Spiral Matrix — LC 54](https://leetcode.com/problems/spiral-matrix/) ⭐
```java
```
- [Set Matrix Zeroes — LC 73](https://leetcode.com/problems/set-matrix-zeroes/) ⭐
```java
```
- [Word Search — LC 79](https://leetcode.com/problems/word-search/)
```java
```
- [Search a 2D Matrix — LC 74](https://leetcode.com/problems/search-a-2d-matrix/) ⭐
```java
```

**13. Merge/Multi-array**
- [Merge Sorted Array — LC 88](https://leetcode.com/problems/merge-sorted-array/) ⭐
```java
```
- [Merge k Sorted Lists — LC 23](https://leetcode.com/problems/merge-k-sorted-lists/)
```java
```

**15. Greedy on Arrays**
- [Jump Game — LC 55](https://leetcode.com/problems/jump-game/) ⭐
```java
```
- [Jump Game II — LC 45](https://leetcode.com/problems/jump-game-ii/) ⭐
```java
```
- [Gas Station — LC 134](https://leetcode.com/problems/gas-station/) ⭐
```java
```
