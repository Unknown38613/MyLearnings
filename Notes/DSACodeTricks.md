Absolutely. These are **small coding/math tricks** that show up everywhere in DSA. You don't need to memorize hundreds, but there is a core set worth having in your toolbox.

I'll give you the **pattern → trick → why → example**.


# 🧠 DSA "Small Tricks" Cheat Sheet

## 1. Ceiling Division ⭐⭐⭐

When you need:

> `ceil(a / b)`

Instead of using floating point:

```java
(a + b - 1) / b
```

Example:

```text
7 / 3 = 2.33
ceil = 3

(7 + 3 - 1) / 3
= 9 / 3
= 3
```

### Common use

"How many groups of size `k` do I need for `n` elements?"

```java
int groups = (n + k - 1) / k;
```

---

# 2. Floor Division

For positive integers, normal integer division already gives floor:

```java
7 / 3 = 2
```

So:

```java
int x = a / b;
```

means:

```text
floor(a / b)
```

This becomes extremely useful with binary search and array partitioning.

---

# 3. Middle of Binary Search ⭐⭐⭐

Old:

```java
int mid = (left + right) / 2;
```

Safer:

```java
int mid = left + (right - left) / 2;
```

Why?

`left + right` can overflow if numbers are huge.

Think:

```text
left -----> mid -----> right

mid = left + half of the distance
```

---

# 4. Avoid `Math.pow()` for Powers of 2

If you need:

```text
2^k
```

use:

```java
1 << k
```

Example:

```java
1 << 3
```

means:

```text
1000 = 8
```

So:

```java
1 << 10 = 1024
```

### Related

```java
x << 1
```

≈ multiply by 2

```java
x >> 1
```

≈ divide by 2

For positive integers.

---

# 5. Check if Number is Power of 2 ⭐⭐⭐

This is a famous bit trick:

```java
n > 0 && (n & (n - 1)) == 0
```

Examples:

```text
8  = 1000
7  = 0111

1000
&
0111
----
0000
```

But:

```text
10 = 1010
 9 = 1001

1010
&
1001
----
1000 ≠ 0
```

Why?

A power of 2 has **exactly one `1` bit**.

---

# 6. Get Lowest Set Bit

```java
n & -n
```

Example:

```text
n = 12

1100
```

```java
12 & -12
```

gives:

```text
0100 = 4
```

This appears in **bit manipulation / Fenwick Tree / subset-related problems**.

Don't worry about mastering it immediately. Just recognize it.

---

# 7. Swap Without Temporary Variable

You may see:

```java
a ^= b;
b ^= a;
a ^= b;
```

But honestly:

**don't prioritize memorizing this.**

Normal:

```java
int temp = a;
a = b;
b = temp;
```

is clearer.

This is a good example of a "trick" that isn't worth forcing into your brain.

---

# 8. Modulo for Keeping Numbers in Range ⭐⭐⭐

Suppose:

```text
index = index + 1
```

and you want it to wrap around:

```text
0 → 1 → 2 → 3 → 0 → 1...
```

Use:

```java
index = (index + 1) % n;
```

Example:

```text
n = 4

0 → 1
1 → 2
2 → 3
3 → 0
```

Used heavily in:

* Circular arrays
* Circular queues
* Ring buffers

---

# 9. Negative Modulo Trap ⚠️

Java can produce negative remainder:

```java
-1 % 5
```

gives:

```text
-1
```

If you want a guaranteed positive modulo:

```java
((x % n) + n) % n
```

Example:

```text
x = -1
n = 5

(-1 % 5 + 5) % 5
= (-1 + 5) % 5
= 4
```

Very useful when dealing with circular indexes.

---

# 10. XOR Trick ⭐⭐⭐

Remember these:

```text
x ^ x = 0
x ^ 0 = x
```

Therefore:

```java
int ans = 0;

for (int x : nums) {
    ans ^= x;
}
```

If every number appears twice except one:

```text
2 ^ 2 = 0
3 ^ 3 = 0

0 ^ 7 = 7
```

So the remaining number survives.

Classic problem:

> Every number appears twice except one. Find the single number.

---

# 11. Swap Two Variables Using XOR

Related to the above:

```java
a ^= b;
b ^= a;
a ^= b;
```

Again: know it exists, but **don't prefer it in normal code**.

---

# 12. Absolute Difference

Instead of:

```java
if (a > b)
    diff = a - b;
else
    diff = b - a;
```

simply:

```java
int diff = Math.abs(a - b);
```

You'll use this constantly in:

* Two pointers
* Coordinates
* Sliding window
* Greedy problems

---

# 13. Min/Max Update Pattern ⭐⭐⭐

You'll write these thousands of times:

```java
min = Math.min(min, value);
max = Math.max(max, value);
```

For example:

```java
int max = Integer.MIN_VALUE;

for (int x : nums) {
    max = Math.max(max, x);
}
```

---

# 14. Initialize Min/Max Correctly

This is a subtle one.

Don't do:

```java
int min = 0;
```

if values can be positive.

Example:

```text
nums = [5, 7, 10]
```

Your `min` stays `0`, which is wrong.

Instead:

```java
int min = Integer.MAX_VALUE;
```

Similarly:

```java
int max = Integer.MIN_VALUE;
```

Or initialize from the first element:

```java
int min = nums[0];
int max = nums[0];
```

---

# 15. Two Numbers → Sum Without Overflow

Sometimes:

```java
int sum = a + b;
```

can overflow.

You may see:

```java
long sum = (long) a + b;
```

The important trick is:

> **Cast before the operation.**

Bad:

```java
long sum = (long)(a + b);
```

Overflow can already happen during `a + b`.

Good:

```java
long sum = (long)a + b;
```

This is especially important in:

* Prefix sums
* Binary search
* Product calculations
* Counting problems

---

# 16. Reverse an Array With Two Pointers ⭐⭐⭐

Instead of creating another array:

```java
int left = 0;
int right = nums.length - 1;

while (left < right) {
    int temp = nums[left];
    nums[left] = nums[right];
    nums[right] = temp;

    left++;
    right--;
}
```

Mental pattern:

```text
<--------->
L         R

swap

 L       R
  \     /
   move inward
```

This same idea appears in:

* Reverse string
* Palindrome
* Two Sum II
* Container With Most Water
* Partitioning

---

# 17. Remove Last Character From String

Instead of manually doing stuff:

```java
s.substring(0, s.length() - 1)
```

But when building strings, prefer:

```java
StringBuilder sb = new StringBuilder();

sb.append(...);

sb.deleteCharAt(sb.length() - 1);
```

Useful in backtracking:

```text
choose
recurse
undo
```

---

# 18. Convert Character Digit → Integer ⭐⭐⭐

Very common:

```java
int digit = c - '0';
```

Example:

```text
c = '7'

'7' - '0' = 7
```

This is extremely useful in:

* Number parsing
* Calculator problems
* String problems

---

# 19. Integer → Character Digit

```java
char c = (char) ('0' + digit);
```

For example:

```java
int digit = 5;

char c = (char)('0' + digit);
```

gives:

```text
'5'
```

---

# 20. Character Case Conversion

You can use:

```java
Character.toLowerCase(c);
Character.toUpperCase(c);
```

Rather than remembering ASCII values.

---

# 21. Count Set Bits ⭐⭐⭐

Java already gives you:

```java
Integer.bitCount(n);
```

Example:

```java
Integer.bitCount(13);
```

13:

```text
1101
```

has 3 ones.

Answer:

```text
3
```

Don't reinvent this during interviews unless specifically asked.

---

# 22. Infinity for DP ⭐⭐⭐

When solving minimum problems, you'll often need:

```java
int INF = Integer.MAX_VALUE;
```

But there's a trap.

Don't do:

```java
INF + something
```

because it can overflow.

Safer:

```java
int INF = 1_000_000_000;
```

For example:

```java
int[] dp = new int[n + 1];
Arrays.fill(dp, 1_000_000_000);
```

Then:

```java
dp[i] = Math.min(dp[i], dp[j] + cost);
```

---

# 23. Array Index From 0

This sounds stupid, but it creates tons of formulas.

If array has `n` elements:

```text
first index = 0
last index = n - 1
```

So:

```java
for (int i = 0; i < n; i++)
```

means:

```text
0 ... n-1
```

And a range:

```text
l ... r
```

has:

```text
r - l + 1
```

elements.

⭐ This formula is **VERY important**.

Example:

```text
[2, 3, 4, 5, 6]

l = 1
r = 3

elements = 3 - 1 + 1
         = 3

3,4,5
```

---

# 24. Exclusive Range Length

If your range is:

```text
[l, r)
```

where `r` is excluded:

```text
length = r - l
```

This is why Java's:

```java
substring(l, r)
```

has length:

```text
r - l
```

Understanding **inclusive vs exclusive** prevents a LOT of off-by-one bugs.

---

# 25. Prefix Sum Range Sum ⭐⭐⭐⭐⭐

This is one of the biggest "formula tricks."

If:

```text
prefix[i] = sum of elements 0...i
```

Then:

```text
sum(l...r)
=
prefix[r] - prefix[l-1]
```

Example:

```text
nums:
[2, 5, 3, 7, 1]

prefix:
[2, 7, 10, 17, 18]
```

Want:

```text
5 + 3 + 7
```

which is index `1...3`.

```text
prefix[3] - prefix[0]
= 17 - 2
= 15
```

Or the cleaner version with prefix array of size `n+1`:

```text
prefix[i+1] = prefix[i] + nums[i]
```

Then:

```text
sum(l...r) = prefix[r+1] - prefix[l]
```

This version is worth remembering.
