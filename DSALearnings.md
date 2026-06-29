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

## Two Pointers


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
CurrentRunningPrefixXOR - OlderPrefixXOR = TargetXOR
so OlderPrefixXOR = CurrentRunningPrefixXOR - target
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
