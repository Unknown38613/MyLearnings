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
