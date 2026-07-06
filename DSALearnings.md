## Sliding Window
```
window len = right - left + 1
left start = right - window len + 1
count/num of subarray ending at right = right - left + 1
```
```
Sliding window works perfect for at most conditions (<=)

For at most k, once valid window is formed then every element in window satisfies the
condition hence every left pointer forms a valid boundary but for strict equals k every
element doesn't satisfies the condition because the element that makes window valid might
be removed hence we can't continue with simple sliding window
```
```
so we do Exact k = at most k - at most k - 1
               3 =  0,1,2,3 -  0,1,2
```
```           
For at least k (complement trick) = total subarrays - at most k - 1
same like numbers >= 10 ---> total numbers - number <= 9
```

```
### Shrinking Rule
- while → when invalid can happen multiple times
- if → when window size is fixed / single removal
```

## Two Pointers
```
Use when:
- array is sorted
- need pair/triplet
- need shrinking from both ends


### Sorted Array Pair
sum < target → left++
sum > target → right--


### Remove Duplicates Pattern
Move fast pointer always.
Move slow pointer only when valid new value found.


### Opposite Direction
left = 0
right = n-1

Move pointer that helps reach target.
```


## Prefix Sum
```
CurrentRunningPrefixSum - OlderPrefixSum = target
so OlderPrefixSum = CurrentRunningPrefixSum - target
```
```
for count : {0,1} currentrunningprefixsum, frequency
if hashmap contains olderprefixsum i.e, currentrunningprefixsum - target then count it
```
```
for length : {0,-1} currentrunningprefixsum, index
⚠️ if hashmap contains currentrunningprefixsum, then don't add new one because we want longest
```
```
For XOR:
X ^ X = 0
X ^ 0 = X
X ^ Y = Z, Y ^ Z = X, Z ^ X = Y
CurrentRunningPrefixXOR ^ OlderPrefixXOR = TargetXOR
so OlderPrefixXOR = CurrentRunningPrefixXOR ^ target
```
```
Count equal 0s and 1s
Treat 1 - +1
Treat 0 - -1
then same like length or count
```

```
Group Anagram
Hashmap + Sorted Key - N.KlogK
HashMap + Frequency Patterned Key - N.K
```
## Tree
```
Height = node to deepest leaf, edges 
so if root == null return -1 because leaf has no edge

But for node count return 0 because root == null means no node

Why Postorder for height? Because parent's height depend on child
```

```
BFS - level by level, decrease depth only when level is visited
```

```
Diameter(longest path btw 2 nodes) - edges on longest path between any 2 nodes
(not necessary it passes through root)
        node
       /    \
      L      R
diameter of node = height(L) + height(R)

⚠️ here root == null return 0 because we are using nodes for height and then diameter
uses those height for edge
if we used -1 then leaf will have 0 height
```
Path Sum: 
Root to leaf path sum - just pass the sum target - root.val
> Any path exists - || (will immediately terminate operation if 1 path is found)

> All paths valid - &&

```
Any Path sum - Naive approach to start from every node O(N^2) for skewed tree

Optimized approach - Prefix Sum + DFS + Backtracking
1. Start like normal prefix sum
2. Map {0, 1} runningsum, frequency
3. Now in DFS, check if runningsum - target exists then count it
4. map the runningsum, frequency
5. now do dfs in both side with that runningsum
6. after doing it backtrack by decrementing the freqency 
```

```
LCA of p and q - first node that has both descendant p and q
(a node can be descendant of itself)

⚠️ P and Q are guarnteed present
⚠️ We are not doing value comparison because it relies on Node object, value can repeat
1. If root is null, p, q return root
2. Search left and right for it
3. If both returns non-null then that node is LCA return root
4. Return non-null side (incase of both null return any)
return (left != null) ? left : right;
```
```
Binary Tree from Preorder and Inorder
1. Preorder - root left right, Inorder - left root right
2. First element in preorder is always root
3. Now in inorder, find that preorder element index
left side from that will be left subtree, and right side another
4. Then just continue that with left and right subtree recursively
For Left - 
Prestart - Prestart + 1
Preend - Prestart + (Inorderroot - Instart)
Instart - Instart 
Inend - Inorderroot - 1

For Right -
Prestart - Prestart + (Inorderroot - Instart) + 1
Preend - Preend
Instart - Inorderroot + 1
Inend - Inend
```

## Graph
```
Adjacency list(sparse, few edge) - visit each edge twice and vertex once = O(V + 2E)
(not VxE because we don't loop all edges for each Vertex, we know neighbor of each V)

Adjacency Matrix(many, dense) - we don't know each V neighbor so we scan whole row = O(V^2)
(even if no edges still it check V^2)
But useful in checking if there is edge between 2 vertices
(Adjacency list will go through list, matrix is just mat[A][B])
```

```
DFS on graph
BFS on graph
min dist in unweighted graph - BFS
distance[neighbor] = distance[currentnode] + 1;
positive weight - Dijkstra
Relax distance - (distance[node] + adjweight < distance[adjNode]) 
(minimizing distance from the source)

MST - all vertices, V - 1 edges, no cycle, min total weight
Prim's MST - PQ
Just keep adding all outgoing edges to unvisited neighbours
(minimizing the next connecting edge)

DSU (Union Find) data structure:
Find() - which group element belong
Union() - merge 2 groups

1. maintain parent index array where everyone is their own parent
2. for int find() use path compression
3. void Union() by rank/size

Kruskal's MST - DSU
Topological Sort - Kahn's algo
Undirected cycle detection - DSU
Directed cycle detection - Kahn's algo
```
## Binary Search
```
Target - Return middle element immediately (log N)
```
```
firstPosition in duplicate array - when found the middle, tighten  
boundary on left (high = mid - 1) don't stop
lastPosition in duplicate array - when found the middle, tighten
boundary in right (left = mid + 1) don't stop
```
```
target in rotated sorted array -
1) Find mid, if target return 
2) compare low with mid, if low <= mid left half is sorted
3) Now check if target is between left and mid high = mid - 1
4) else low = mid + 1
5) Else right half is sorted
6) Check if target is between mid and right low = mid + 1
7) else high = mid - 1
8) return -1 if not found
```
## Linked List

```
Reverse LL:
Pointer dance
prev = null
curr = head;
while curr!=null
1) temp = curr.next
2) curr.next = prev;
3) prev = curr;
4) curr = temp;
5) return prev
```
```
Fast and Slow:
odd - middle node
even - 2nd middle
```
```
Detecting Cycle:
slow and fast meet true
```
```
Linked List intersection
start both from head
when reached end, switch heads
p1 = a + c + b
p2 = b + c + a
same dist
even if no intersection, will hit null 
```

```
Linked List Cycle start
x = dist from head to start cycle
y = dist from start cycle to meet
L = length of cycle

for slow = x + y
for fast = 2(x + y) 

2 (x + y) = x + y + kL (it will have to travel some k loop to reach same dist)
x + y = kL
x = kL - y
pointer from head = pointer from meeting point needs same step
regardless of K 
```
```
Merge 2 sorted lists:
dummy -1
current = dummy

now walk both lists
compare if list1.value <= list2.value
current.next = list1
list1 = list1.next
current = current.next

any leftovers list1 != null
current.next = list1

return dummy.next;
```

```
Reverse K Groups:

PGT = -1
dummy = -1
curr = 1
-1->1->2->3->4->5
CGH = 1
prev = null
---------
-1->3->2->1->4->5
PGT.next = prev = 3
CGH.next = curr = 4
PGT = 1
```
## Stack

```
Parentheses
Open push
Close
1.If empty false
2.If mismatch with pop false

If stack empty true
```

```
Next Smaller Element (NSE)
Use index to make calculation easy
if stack is not empty && curr < stack peek
poppedIndex = pop()
res[poppedIndex] = curr

stack.push(i)
```

```
Next Greater Element (NGE)
Use index to make calculation easy
if stack is not empty && curr > stack peek
poppedIndex = pop()
res[poppedIndex] = curr

stack.push(i)
```

```
(NGE) Daily Temperatures - how many days to get warmer temp
if stack is not empty && currTemp > stack peek
poppedIndex = pop()
res[poppedIndex] = i - poppedIndex

stack.push(i)
```
```
removeAdjacentDuplicates
if len > 0 && stack top == curr
then stack pop
else stack push
```

```
Deep String Decoding

3[a2[c]]

3
k = 3
-------------------
[
countstack = 3
stringstack = currentstring = ""
currentstring = ""
k = 0
-------------------
a
currentstring = a
-------------------
2
k = 2
-------------------
[
countstack = 3 2
stringstack = currentstring = "" a
currentstring = ""
k = 0
-------------------
c
currentstring = c
-------------------
]
decodedsegment = c
currentstring = stringstack pop = a
repeat = countstack pop = 2
currentstring = acc
-------------------
]
decodedsegment = acc
currentstring = stringstack pop = ""
repeat = countstack pop = 3
currentstring = accaccacc
-------------------
```

## Heap

```
Find K largest element
PQ - min heap
insert
Evict when size() > k 

3 10 2 8 15 7
k = 3
2 3 10 -> 3 8 10 ->
8 10 15 -> 8 10 15
```

```
Find K smallest element
PQ - max heap
priorityQueue(Collections.reverseOrder())
insert
Evict when size() > k
```

```
Median
smallhalf = max heap
can contain 1 extra element
for odd number
largehalf = min heap

add:
add in smallhalf always
add the max of small half to largehalf
if smallfhalf size < largehalf 
then smallhalf add largehalf min element

findMedian:
for odd:
if smallhalf > largehalf 
return smallhalf max element
for even:
return small + large peek / 2.0
```

## Backtracking

```
1. Subset
list.add(list2) - point just to reference of list 2 
list.add(new ArrayList<>(list2)) - create copy of list 2

2. Combination
pick/skip manually skip - useless branching if looping forwards
for loop - skips naturally avoids useless branches

3. Combination Sum
Objects like list - manually restore them in backtracking
primitives/pass by value - don't restore them

4. Combination Sum II
Always check for success before failure in base condition
In case of sorted array,
detect duplicate early
prune early (if curr > target) then next will also be > targets so break

5. Permutations
loop starts from 0 every time, visited array will keep track whether to continue or not
```
