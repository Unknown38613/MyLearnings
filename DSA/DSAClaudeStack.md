## Stack — Non-negotiable

- [Valid Parentheses — LC 20](https://leetcode.com/problems/valid-parentheses/)
```java
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
```java
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
```java
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
```java
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
```java
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
```java
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
```java
class Solution {
    public int evalRPN(String[] tokens) {
        Deque<Integer> stack = new ArrayDeque<>();
        for(String s : tokens){
            //⚠️ for string it equals too only
            if(s.equals("+") || s.equals("-") || s.equals("*") || s.equals("/")){
                int b = stack.pop();
                int a = stack.pop();
                //⚠️ Order matters for - and /
                int ans = switch(s) {
                   case "+" -> a + b;
                   case "-" -> a - b;
                   case "*" -> a * b;
                   case "/" -> a / b;
                   //⚠️ default is required for switch
                   default -> 0;
                };
                stack.push(ans);
            }
            else{
                stack.push(Integer.parseInt(s));
            }
        }
        return stack.pop();
    }
}
```
- [Basic Calculator II — LC 227](https://leetcode.com/problems/basic-calculator-ii/)
```java
class Solution {
    public int calculate(String s) {
        Deque<Integer> stack = new ArrayDeque<>();
        int currNum = 0;
        char lastOp = '+';
        int n = s.length();

        for(int i = 0 ; i < n ; i++){
            char c = s.charAt(i);
            //⚠️ handle multiple digits
            if(Character.isDigit(c)){
                currNum = currNum * 10 + (c - '0');
            }

            if((!Character.isDigit(c) && c != ' ') || i == n - 1){
                if(lastOp == '+'){
                    stack.push(currNum);
                }
                else if(lastOp == '-'){
                    stack.push(-currNum);
                }
                //perform operation for * and / (BODMAS)
                else if(lastOp == '*'){
                    stack.push(stack.pop() * currNum);
                }
                else if(lastOp == '/'){
                    stack.push(stack.pop() / currNum);
                }
                //form new number
                currNum = 0;
                lastOp = c;
            }
        }

        int res = 0;
        while(!stack.isEmpty()){
            res += stack.pop();
        }

        return res;
    }
}
```
- [Implement Queue using Stacks — LC 232](https://leetcode.com/problems/implement-queue-using-stacks/)
```java
class MyQueue {

    Deque<Integer> stack1;
    Deque<Integer> stack2;

    public MyQueue() {
        stack1 = new ArrayDeque<>();
        stack2 = new ArrayDeque<>();
    }
    
    public void push(int x) {
        stack1.push(x);
    }
    
    public int pop() {
        //amortized operation, do expensive operation once for O(N)
        //rest all operations O(1)
        moveWhenEmpty();
        return stack2.pop();
    }
    
    public int peek() {
        moveWhenEmpty();
        return stack2.peek();
    }
    
    public boolean empty() {
        return stack1.isEmpty() && stack2.isEmpty();
    }

    private void moveWhenEmpty(){
        if(stack2.isEmpty()){
            while(!stack1.isEmpty()) stack2.push(stack1.pop());
        }
    }
}
```
- [Decode String — LC 394](https://leetcode.com/problems/decode-string/)
```java
class Solution {
    public String decodeString(String s) {
        Deque<Integer> kstack = new ArrayDeque<>();
        Deque<StringBuilder> sstack = new ArrayDeque<>();
        int currNum = 0;
        StringBuilder currString = new StringBuilder();

        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            
            if (Character.isDigit(c)) {
                currNum = currNum * 10 + (c - '0');
            } 
            else if (c == '[') {
                kstack.push(currNum);
                sstack.push(currString);
                currNum = 0;
                currString = new StringBuilder();
            } 
            else if (c == ']') {
                int count = kstack.pop();
                StringBuilder prevStr = sstack.pop();
                
                // Append currString 'count' times to prevStr
                for (int j = 0; j < count; j++) {
                    prevStr.append(currString);
                }
                
                // Update currString to hold the combined string
                currString = prevStr;
            } 
            else {
                currString.append(c);
            }
        }

        return currString.toString();
    }
}
```
- [Online Stock Span — LC 901](https://leetcode.com/problems/online-stock-span/description/)
```java
```
