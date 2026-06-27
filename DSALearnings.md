window len = right - left + 1
left start = right - window len + 1
count/num of subarray ending at right = right - left + 1

Sliding window works perfect for at most conditions (<=)

For at most k, once valid window is formed then every element in window satisfies the condition hence every left pointer forms a valid boundary
but for strict equals k every element doesn't satisfies the condition because the element that makes window valid might be removed hence we can't continue with simple sliding window

so we do Exact k = at most k - at most k - 1
               3 =  0,1,2,3 -  0,1,2 
               
For at least k (complement trick) = total subarrays - at most k - 1
same like numbers >= 10 ---> total numbers - number <= 9
