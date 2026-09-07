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
```
- [Next Greater Element I — LC 496](https://leetcode.com/problems/next-greater-element-i/)
```
```
- [Largest Rectangle in Histogram — LC 84](https://leetcode.com/problems/largest-rectangle-in-histogram/)
```
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
