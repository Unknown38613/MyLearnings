# DSA Problem-Solving Cheat Sheet

## 1. Constraints

- **Very small** → Exponential, Factorial
- **2 / 3 / 4 zeros** → `O(n²)` / `O(n³)`
- **5 zeros** → `O(n)`, `O(n log n)`
- **6+ zeros** → `O(n)`

## 2. What Does the Problem Ask?

### Boolean

**Question:** Is it possible?

→ DFS / BFS / Greedy / DP / Binary Search

### Count

**Question:** How many?

→ DP / Hashing / Combinatorics

### Ways

**Question:** Number of possibilities?

→ DP

### Min / Max

**Question:** What's optimal?

→ DP / Greedy / Binary Search on Answer

### One Valid Solution

**Question:** Can I construct one?

→ Greedy / DFS / Backtracking

### ALL Solutions

**Question:** Enumerate possibilities

→ Backtracking / DFS

### Index / Position

**Question:** Where is it?

→ HashMap / Binary Search / Two Pointers / Stack

## 3. Properties

### Is the Array Sorted?

→ Two Pointers / Binary Search

### Subarray / Substring

Sliding Window generally requires a **monotonic/non-negative** property and an **at most / at least** framing.

- **Exactly `K`**
  - `atMost(K) - atMost(K - 1)`

- **Exactly `K` with a cumulative condition**
  - Prefix Sum + HashMap
  - Example pattern: `sum - prefixSum + HashMap`

### Count the Ways vs Return All Ways

- **Count the ways** → DP
- **Return all of them** → Backtracking

### Shortest Path in an Unweighted Graph

→ BFS

### Binary Search on the Answer

Use when:

- **MIN / MAX ANSWER**
- Ask: **"Can I achieve X?"**
- The feasibility condition is **monotonic**

Pattern:

> Optimize the answer → Binary Search → Check feasibility

### NGE / NSE

- **NGE** = Next Greater Element
- **NSE** = Next Smaller Element

→ Monotonic Stack

### Fast / Slow Pointers

Fast/slow pointers aren't just for **linked-list cycle detection**.

They can also be useful for:

- Finding the middle
- Detecting cycles
- Comparing relative positions
- Partitioning / rearranging
- Problems involving different traversal speeds
