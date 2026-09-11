## Stack — Non-negotiable

- [Valid Parentheses — LC 20](https://leetcode.com/problems/valid-parentheses/)
```
class Solution {
    public boolean isValid(String s) {
        if(s.length() % 2 != 0) return false;
        Deque<Character> stack = new ArrayDeque<>();
        for(char c : s.toCharArray()){
            if(c == '(' || c == '[' || c == '{'){
                stack.push(c);
            }
            else{
                if(stack.isEmpty()) return false;
                //⚠️ pop it
                char top = stack.pop();
                if((c == ')' && top != '(')
                || (c == ']' && top != '[')
                || (c == '}' && top != '{')) return false;
            }
        }
        return stack.isEmpty();
    }
}
```
- [Min Stack — LC 155](https://leetcode.com/problems/min-stack/)
```
class MinStack {

    Deque<Integer> stack;
    Deque<Integer> minStack;

    public MinStack() {
        stack = new ArrayDeque<>();
        minStack = new ArrayDeque<>();
    }
    
    public void push(int value) {
        stack.push(value);
        if(minStack.isEmpty()) minStack.push(value);
        //⚠️ just maintain the minimum of all values we have seen
        else minStack.push(Math.min(minStack.peek(), value));
    }
    
    public void pop() {
        stack.pop();
        minStack.pop();
    }
    
    public int top() {
        return stack.peek();
    }
    
    public int getMin() {
        return minStack.peek();
    }
}
```
- [Daily Temperatures — LC 739](https://leetcode.com/problems/daily-temperatures/)
```
class Solution {
    public int[] dailyTemperatures(int[] temperatures) {
        int n = temperatures.length;
        int[] ans = new int[n];
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(n - 1);
        //NGE
        for(int i = n - 2 ; i >= 0 ; i--){
            //Not Strict, if current temp is greater than equal to peek then
            //we found greatest one, so pop all below
            while(!stack.isEmpty() && temperatures[stack.peek()] <= temperatures[i]){
                stack.pop();
            }
            if(!stack.isEmpty()){
                ans[i] = stack.peek() - i;
            }
            stack.push(i);
        }
        return ans;
    }
}
```
- [Next Greater Element I — LC 496](https://leetcode.com/problems/next-greater-element-i/)
```
class Solution {
    public int[] nextGreaterElement(int[] nums1, int[] nums2) {
        Map<Integer, Integer> map = new HashMap<>();
        Stack<Integer> stack = new Stack<>();
        for(int n : nums2){
            //if current is greater than peek, found nge
            while(!stack.isEmpty() && stack.peek() < n){
                map.put(stack.pop(), n);
            }
            stack.push(n);
        }
        while(!stack.isEmpty()) map.put(stack.pop(), -1);
        int[] ans = new int[nums1.length];
        int k = 0;
        for(int n : nums1){
            ans[k++] = map.get(n);
        }
        return ans;
    }
}
```
- [Largest Rectangle in Histogram — LC 84](https://leetcode.com/problems/largest-rectangle-in-histogram/)
```
//NSE & PSE
class Solution {
    public int largestRectangleArea(int[] heights) {
        Deque<Integer> stack = new ArrayDeque<>();
        int n = heights.length;
        int maxArea = 0;

        for (int i = 0; i <= n; i++) {
            //⚠️ in last keep 0 to pop all out of stack
            // else if heights are in increasing order area will never be calculated
            int currHeight = (i == n ? 0 : heights[i]);

            while (!stack.isEmpty() && currHeight < heights[stack.peek()]) {

                int top = stack.pop();
                int height = heights[top];

                int right = i;
                //⚠️ handle when left/PSE doesn't exist
                int left = stack.isEmpty() ? -1 : stack.peek();
                //both inclusive : r - l + 1
                //one inclusive, one exclusive : r - l
                //both exclusive : r - l - 1
                int width = right - left - 1;
                maxArea = Math.max(maxArea, height * width);
            }

            stack.push(i);
        }

        return maxArea;
    }
}
```
- [Trapping Rain Water — LC 42](https://leetcode.com/problems/trapping-rain-water/description/)
```
//NGE & PGE
class Solution {
    public int trap(int[] height) {
        int n = height.length;
        Deque<Integer> stack = new ArrayDeque<>();
        int water = 0;

        for(int i = 0 ; i < n ; i++){
            //⚠️ increasing/decreasing heights cannot trap water
            // so no need to handle them
            int currHeight = height[i];

            while(!stack.isEmpty() && currHeight > height[stack.peek()]){
                //floor on which water will stand
                int floorHeight = stack.pop();
                
                //⚠️ if no left boundary/PGE present, water will leak
                if(stack.isEmpty()) break;

                //exclusive boundaries on both side
                int right = i;
                int left = stack.peek();

                int width = right - left - 1;
                
                //bucket logic : min height of bucket - floor height gives water depth
                int valleyHeight = Math.min(height[left], height[right]) - height[floorHeight];

                water += valleyHeight * width;
            }

            stack.push(i);
        }

        return water;
    }
}
```
- [Evaluate Reverse Polish Notation — LC 150](https://leetcode.com/problems/evaluate-reverse-polish-notation/)
```
```
- [Basic Calculator II — LC 227](https://leetcode.com/problems/basic-calculator-ii/)
```
```
- [Implement Queue using Stacks — LC 232](https://leetcode.com/problems/implement-queue-using-stacks/)
```
```
- [Decode String — LC 394](https://leetcode.com/problems/decode-string/)
```
```
