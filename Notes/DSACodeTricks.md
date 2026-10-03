# DSA "Small Tricks" Cheat Sheet Summary

Here is a structured breakdown of the essential coding and math tricks commonly used in Data Structures and Algorithms (DSA) problems.



## 1. Arithmetic & Numeric Tricks

* **Ceiling Division:** Avoid floating-point operations when dividing $a$ by $b$.
```java
int groups = (a + b - 1) / b;

```


* **Overflow-Safe Binary Search Midpoint:** Prevents integer overflow when `left + right` exceeds `Integer.MAX_VALUE`.
```java
int mid = left + (right - left) / 2;

```


* **Safe Arithmetic Casting:** Cast to `long` *before* the operation to prevent integer overflow during calculation.
```java
long sum = (long) a + b; // Good

```


* **Safe Infinity for Dynamic Programming:** Avoid `Integer.MAX_VALUE` if you plan to add to it, as it will overflow to negative.
```java
int INF = 1_000_000_000;

```





## 2. Bit Manipulation

* **Power of 2 Check:** A power of two has exactly one set bit.
```java
boolean isPowerOfTwo = n > 0 && (n & (n - 1)) == 0;

```


* **Powers of 2 via Bit Shift:** Compute $2^k$ using left shifts instead of `Math.pow()`.
```java
int pow2 = 1 << k; // 2^k

```


* **Get Lowest Set Bit:** Isolates the rightmost 1-bit in binary representation.
```java
int lowestBit = n & -n;

```


* **XOR Duplicate Cancellation:** Utilizing $x \oplus x = 0$ and $x \oplus 0 = x$ to find unique elements.
```java
int singleNum = 0;
for (int x : nums) {
    singleNum ^= x;
}

```


* **Count Set Bits:** Use Built-in method instead of manual loop.
```java
int count = Integer.bitCount(n);

```





## 3. Arrays, Ranges & Indexing

* **Range Length Calculations:**
* **Inclusive $[l, r]$:** Length is `r - l + 1`
* **Exclusive $[l, r)$:** Length is `r - l`


* **Circular Array Wrapping:**
* **Forward Wrap:** `index = (index + 1) % n`
* **Guaranteed Positive Modulo:** Handles negative remainders in Java (e.g., `-1 % 5 = -1`).
```java
int posIndex = ((x % n) + n) % n;

```




* **Prefix Sum Range Query:** Query sum in $O(1)$ for range $[l, r]$ using 1-indexed prefix array.
```java
// prefix[i + 1] = prefix[i] + nums[i]
int rangeSum = prefix[r + 1] - prefix[l];

```


* **Two-Pointer Array Reversal:** Swap elements in-place while moving inward.
```java
while (left < right) {
    int temp = nums[left];
    nums[left++] = nums[right];
    nums[right--] = temp;
}

```


* **Min/Max Safe Initialization:** Initialize bounds with `Integer.MAX_VALUE` / `Integer.MIN_VALUE` or the first array element `nums[0]`.
```java
int max = Integer.MIN_VALUE;
for (int x : nums) {
    max = Math.max(max, x);
}

```





## 4. String & Character Operations

* **Char-Digit Conversions:**
```java
int digit = c - '0';                 // '7' -> 7
char c = (char) ('0' + digit);       // 5 -> '5'

```


* **Backtracking String Undo:** Efficiently pop the last character from a `StringBuilder`.
```java
sb.deleteCharAt(sb.length() - 1);

```


* **Standard Case Conversion:** Use wrapper methods to avoid hardcoding ASCII offsets.
```java
char lower = Character.toLowerCase(c);

```



## 5. Core Pattern Reference Table

| Goal / Problem Pattern | Associated Trick | Java Syntax |
| --- | --- | --- |
| **Group / Batching Count** | Ceiling Division | `(a + b - 1) / b` |
| **Binary Search Midpoint** | Overflow Prevention | `left + (right - left) / 2` |
| **Range Length $[l, r]$** | Inclusive Count | `r - l + 1` |
| **Range Length $[l, r)$** | Exclusive Count | `r - l` |
| **Digit Parsing** | ASCII Subtraction | `c - '0'` |
| **Power of 2 Check** | Bitwise AND | `n > 0 && (n & (n - 1)) == 0` |
| **Single Unique Number** | XOR Cancellation | `ans ^= x` |
| **Circular Traversal** | Positive Modulo | `((x % n) + n) % n` |
| **Subarray Sum $O(1)$** | Prefix Sum Array | `prefix[r + 1] - prefix[l]` |
| **Bit Count** | Built-in | `Integer.bitCount(n)` |
