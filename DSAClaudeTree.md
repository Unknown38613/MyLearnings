# Binary Tree — LeetCode Problem List

## Level 1 — Fundamentals

1. [Maximum Depth of Binary Tree](https://leetcode.com/problems/maximum-depth-of-binary-tree/)

```java
//root to farthest leaf
int maxDepth(TreeNode root) {

    if (root == null) {
        return 0;
    }

    int leftHeight = maxDepth(root.left);
    int rightHeight = maxDepth(root.right);

    return 1 + Math.max(leftHeight, rightHeight);
}
```

2. [Same Tree](https://leetcode.com/problems/same-tree/)

```java
boolean isSameTree(TreeNode p, TreeNode q) {

    if (p == null && q == null) {
        return true;
    }

    if (p == null || q == null) {
        return false;
    }

    if (p.val != q.val) {
        return false;
    }

    return isSameTree(p.left, q.left)
        && isSameTree(p.right, q.right);
}
```

3. [Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/)

```java
//mirror the tree, swap left and right
TreeNode invertTree(TreeNode root) {

    if (root == null) {
        return null;
    }

    TreeNode temp = root.left;
    root.left = root.right;
    root.right = temp;

    invertTree(root.left);
    invertTree(root.right);

    return root;
}
```

4. [Symmetric Tree](https://leetcode.com/problems/symmetric-tree/)

```java
//is the tree mirror in itself, pass both left and right node and compare its left and right
boolean isSymmetric(TreeNode root) {

    if (root == null) {
        return true;
    }

    return isMirror(root.left, root.right);
}

boolean isMirror(TreeNode left, TreeNode right) {

    if (left == null && right == null) {
        return true;
    }

    if (left == null || right == null) {
        return false;
    }

    if (left.val != right.val) {
        return false;
    }

    return isMirror(left.left, right.right)
        && isMirror(left.right, right.left);
}
```

5. [Count Complete Tree Nodes](https://leetcode.com/problems/count-complete-tree-nodes/)

```java
class Solution {
    //count nodes in complete binary tree (Every level except possibly the last is completely full)
    //⚠️ Avoid O(n) T.C given in question
    public int countNodes(TreeNode root) {
        if(root == null) return 0;
        
        int leftTreeHeight = getLeftHeight(root);
        int rightTreeHeight = getRightHeight(root);

        //⚠️ Optimization: if perfect binary tree then nodes = 2^height - 1
        if(leftTreeHeight == rightTreeHeight) return (1 << leftTreeHeight) - 1;
        //else count as it is
        return 1 + countNodes(root.left) + countNodes(root.right);
    }

    private int getLeftHeight(TreeNode root){
        if(root == null) return 0;
        return 1 + getLeftHeight(root.left);
    }

    private int getRightHeight(TreeNode root){
        if(root == null) return 0;
        return 1 + getRightHeight(root.right);
    }
}
```

6. [Sum of Left Leaves](https://leetcode.com/problems/sum-of-left-leaves/)

```java
class Solution {
    private int sum = 0;

    public int sumOfLeftLeaves(TreeNode root) {
        if(root == null) return 0;
        calculate(root, false);
        return sum;
    }

    private void calculate(TreeNode node, boolean isLeft){
        if(node == null) return;
        if(node.left == null && node.right == null && isLeft == true) sum += node.val;
        calculate(node.left, true);
        calculate(node.right, false);
    }
}
```

## Level 2 — Recursion Patterns

1. [Path Sum](https://leetcode.com/problems/path-sum/)

```java
class Solution {
    public boolean hasPathSum(TreeNode root, int targetSum) {
        if(root == null) return false;
        if(root.left == null && root.right == null){
            //remaining == leaf.val
            return targetSum == root.val;
        }
        return hasPathSum(root.left, targetSum - root.val) || hasPathSum(root.right, targetSum - root.val);
    }
}
```

2. [Path Sum II](https://leetcode.com/problems/path-sum-ii/)

```java
class Solution {
    public List<List<Integer>> pathSum(TreeNode root, int targetSum) {
        List<List<Integer>> ansList = new ArrayList<>();
        dfs(root, targetSum, new ArrayList<>(), ansList);
        return ansList;
    }
    private void dfs(TreeNode root, int targetSum, List<Integer> path, List<List<Integer>> ansList){
        if(root == null) return;

        path.add(root.val);

        if(root.left == null && root.right == null){
            if(targetSum == root.val){
                //⚠️❗path is modified in backtracking so add a copy
                ansList.add(new ArrayList<>(path));
            }
        }
        dfs(root.left, targetSum - root.val, path, ansList);
        dfs(root.right, targetSum - root.val, path, ansList);

        //backtrack
        path.remove(path.size() - 1);
    }
}
```

3. [Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/)

```java
class Solution {
    //diameter - longest path between any 2 nodes not necessarily root
    //⚠️ maintain diameter outside because we calculate height in function
    private int diameter = 0;
    public int diameterOfBinaryTree(TreeNode root) {
        height(root);
        return diameter;
    }
    private int height(TreeNode root){
        if(root == null) return 0;
        int leftHeight = height(root.left);
        int rightHeight = height(root.right);
        //⚠️ diameter of node n = sum of height of both sides of node n
        diameter = Math.max(diameter, leftHeight + rightHeight);
        return 1 + Math.max(leftHeight, rightHeight);
    }
}
```

4. [Balanced Binary Tree](https://leetcode.com/problems/balanced-binary-tree/)

```java
class Solution {
    //Balanced tree means |height(left) - height(right)| <= 1
    public boolean isBalanced(TreeNode root) {
        return height(root) != -1;
    }
    private int height(TreeNode root){
        if(root == null) return 0;

        int left = height(root.left);
        //⚠️ early return if -1 tree is unbalanced
        if(left == -1) return -1;

        int right = height(root.right);
        if(right == -1) return -1;

        if(Math.abs(left - right) > 1) return -1;

        return 1 + Math.max(left, right);
    }
}
```

5. [Binary Tree Maximum Path Sum](https://leetcode.com/problems/binary-tree-maximum-path-sum/)

```java
class Solution {
    //⚠️ catch: path goes like left + root + right but we cannot return both sides 
    // to its parent node it's invalid calculation
    /*
                    Current node
                         |
             +-----------+-----------+
             |                       |
        final answer             return to parent
             |                       |
       left + root + right     root + max(left,right)
    */
    private int maxSum = (int) -1e9;
    public int maxPathSum(TreeNode root) {
        height(root);
        return maxSum;
    }
    private int height(TreeNode root){
        if(root == null) return 0;
        //avoid picking negative nodes
        int leftGain = Math.max(0, height(root.left));
        int rightGain = Math.max(0, height(root.right));

        int path = leftGain + root.val + rightGain;

        maxSum = Math.max(maxSum, path);

        return root.val + Math.max(leftGain, rightGain);
    }
}
```

6. [Lowest Common Ancestor of a Binary Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/)

```java
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        //if root is p or q return that root
        if(root == null || root == p || root == q) return root;

        //2 sides trying to find p and q
        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);
        
        //found both p & q, root is LCA
        if(left != null && right != null) return root;

        //found either p or q, pass up, or found neither return null
        return left != null ? left : right;
    }
}
```

## Level 3 — BFS

1. [Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/)

```java
class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> ansList = new ArrayList<>();
        if(root == null) return ansList;

        Queue<TreeNode> queue = new ArrayDeque<>();
        queue.offer(root);          
        while(!queue.isEmpty()){
            int size = queue.size();
            List<Integer> path = new ArrayList<>();
            for(int i = 0 ; i < size ; i++){
                TreeNode curr = queue.poll();
                path.add(curr.val);
                if(curr.left != null) queue.offer(curr.left);
                if(curr.right != null) queue.offer(curr.right);
            }
            ansList.add(new ArrayList<>(path)); 
        }
        return ansList;
    }
}
```

2. [Binary Tree Zigzag Level Order Traversal](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/)

```java
class Solution {
    public List<List<Integer>> zigzagLevelOrder(TreeNode root) {
        List<List<Integer>> ansList = new ArrayList<>();
        if(root == null) return ansList;
        //❗
        boolean toggle = true;
        Queue<TreeNode> queue = new ArrayDeque<>();
        queue.offer(root);
        while(!queue.isEmpty()){
            int size = queue.size();
            
            List<Integer> path = new LinkedList<>();
            for(int i = 0 ; i < size ; i++){
                TreeNode curr = queue.poll();
                if(toggle) path.add(curr.val);
                else path.addFirst(curr.val);
                if(curr.left != null) queue.offer(curr.left);
                if(curr.right != null) queue.offer(curr.right);
            }
            
            toggle = !toggle;
            ansList.add(new ArrayList<>(path));
        }
        return ansList;
    }
}
```

3. [Binary Tree Right Side View](https://leetcode.com/problems/binary-tree-right-side-view/)

```java
class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> path = new ArrayList<>();
        if(root == null) return path;
        Queue<TreeNode> queue = new ArrayDeque<>();
        queue.offer(root);
        while(!queue.isEmpty()){
            int size = queue.size();
            for(int i = 0 ; i < size ; i++){
                TreeNode curr = queue.poll();
                //❗
                if(i == size - 1) path.add(curr.val);
                if(curr.left != null) queue.offer(curr.left);
                if(curr.right != null) queue.offer(curr.right);
            }
        }
        return path;
    }
}
```

4. [Binary Tree Left Side View](https://leetcode.com/problems/binary-tree-left-side-view/)

```java
class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> path = new ArrayList<>();
        if(root == null) return path;
        Queue<TreeNode> queue = new ArrayDeque<>();
        queue.offer(root);
        while(!queue.isEmpty()){
            int size = queue.size();
            for(int i = 0 ; i < size ; i++){
                TreeNode curr = queue.poll();
                //❗
                if(i == 0) path.add(curr.val);
                if(curr.left != null) queue.offer(curr.left);
                if(curr.right != null) queue.offer(curr.right);
            }
        }
        return path;
    }
}
```

5. [Average of Levels in Binary Tree](https://leetcode.com/problems/average-of-levels-in-binary-tree/)

```java
//average of each level
class Solution {
    public List<Double> averageOfLevels(TreeNode root) {
        List<Double> path = new ArrayList<>();
        if(root == null) return path;
        Queue<TreeNode> queue = new ArrayDeque<>();
        queue.offer(root);
        while(!queue.isEmpty()){
            //⚠️ constraints -2^31 <= Node.val <= 2^31 - 1
            long sum = 0;
            int size = queue.size();
            for(int i = 0 ; i < size ; i++){
                TreeNode curr = queue.poll();
                sum += curr.val;
                if(i == size - 1){
                    double avg = (double) sum / size;
                    path.add(avg);
                }
                if(curr.left != null) queue.offer(curr.left);
                if(curr.right != null) queue.offer(curr.right);
            }
        }
        return path;
    }
}
```

## Level 4 — BST

1. [Search in a Binary Search Tree](https://leetcode.com/problems/search-in-a-binary-search-tree/)

```java
class Solution {
    public TreeNode searchBST(TreeNode root, int val) {
        if(root == null) return null;

        if(root.val == val) return root;

        if(val < root.val) return searchBST(root.left, val);

        return searchBST(root.right, val);
    }
}
```

2. [Insert into a Binary Search Tree](https://leetcode.com/problems/insert-into-a-binary-search-tree/)

```java
class Solution {
    public TreeNode insertIntoBST(TreeNode root, int val) {
        if(root == null) return new TreeNode(val);
        //⚠️ traverse left till we find null position to attach node
        if(val < root.val){
            root.left = insertIntoBST(root.left, val);
        }
        //⚠️ traverse right till we find null position to attach node
        if(val > root.val){
            root.right = insertIntoBST(root.right, val);
        }
        return root;
    }
}
```

3. [Validate Binary Search Tree](https://leetcode.com/problems/validate-binary-search-tree/)

```java
class Solution {
    // ⚠️❗checking immediate children will not work for whole BST
    // inorder traversal visits every node in ascending order
    // check if inorder property is violated
    private Integer prev = null;
    public boolean isValidBST(TreeNode root) {
        return inorder(root);
    }
    private boolean inorder(TreeNode node){
        if(node == null) return true;
        //early termination
        if(!inorder(node.left)) return false;
        
        if(prev != null && prev >= node.val) return false;

        prev = node.val;

        return inorder(node.right);
    }
}
```

4. [Kth Smallest Element in a BST](https://leetcode.com/problems/kth-smallest-element-in-a-bst/)

```java
class Solution {
    //inorder gives sorted order
    private int count = 0;
    private int answer = 0;
    public int kthSmallest(TreeNode root, int k) {
        inorder(root, k);
        return answer;
    }
    private void inorder(TreeNode root, int k){
        if(root == null) return;

        inorder(root.left, k);

        count++;
        if(count == k){
            answer = root.val;
            return;
        }

        inorder(root.right, k);
    }
}
```

5. [Lowest Common Ancestor of a Binary Search Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-search-tree/)

```java
class Solution {
    //⚠️ differs from BT implementation because we know BST ordering so we know which
    //side will have p and q
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        //both on left side
        if(p.val < root.val && q.val < root.val){
            return lowestCommonAncestor(root.left, p, q);
        }
        //both on right side
        if(p.val > root.val && q.val > root.val){
            return lowestCommonAncestor(root.right, p, q);
        }
        //splitting point
        return root;
    }
}
```

6. [Delete Node in a BST](https://leetcode.com/problems/delete-node-in-a-bst/)

```java
class Solution {
    public TreeNode deleteNode(TreeNode root, int key) {
        if(root == null) return null;

        if(key < root.val) root.left = deleteNode(root.left, key);

        else if(key > root.val) root.right = deleteNode(root.right, key);

        else{
            //For 0 or 1 children
            //⚠️❗ if left is null return right, if right is null return left, if both are null then also it will work

            if(root.left == null) return root.right;
            if(root.right == null) return root.left;
         
            //For 2 children, Find Inorder Successor (smallest node in the right subtree)
            TreeNode minNode = findMin(root.right);
            //replace the value
            root.val = minNode.val;
            //delete the original successor node
            root.right = deleteNode(root.right, root.val);
        }

        return root;
    }

    private TreeNode findMin(TreeNode root){
        while(root.left != null) root = root.left;
        return root;
    }
}
```

### Structural Mutation Operations

Structural mutation operations like **insert, delete, invert, flip** tree require parent pointer updates.

Directly re-assigning a node to a value or null will not work in Java.

Example: Delete Leaf
```
if (node.left == null && node.right == null) {
    node = null; // ❌ DOES NOT WORK!
                 // Only sets local variable 'node' to null.
                 // Parent still points to the old node in memory!
}
```
Correct Approach

The parent must update its pointer:
```
parent.left = null;
```

Or:
```
node.left = deleteNode(node.left, key);
```
## Level 5 — Advanced

1. [Construct Binary Tree from Preorder and Inorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

```java
/*
Preorder → Who is the root?
Inorder → What is on the left and right of that root?
Repeat the same process recursively for left and right.
*/
//❗❗ Since we are building the tree in preorder format, root -> left -> right, so preIndex++ will always give next root
// ⚠️ it will not work if we build right tree first or run in parallel threads
class Solution {
    //For quick search of inorder element position so we know the left and right side
    private Map<Integer,Integer> map;
    //Preorder always gives root element
    private int preIndex = 0;

    public TreeNode buildTree(int[] preorder, int[] inorder) {
        map = new HashMap<>();
        for(int i = 0 ; i < inorder.length ; i++){
            map.put(inorder[i], i);
        }
        return build(preorder, 0, inorder.length - 1);
    }

    private TreeNode build(int[] preorder, int start, int end){
        if(start > end) return null;
        //Gives root
        int rootVal = preorder[preIndex++];
        //Makes root
        TreeNode root = new TreeNode(rootVal);
        //Finds root in inorder
        int inPos = map.get(rootVal);
        //Builds tree
        root.left = build(preorder, start, inPos - 1);

        root.right = build(preorder, inPos + 1, end);

        return root;
    }
}
```

2. [Construct Binary Tree from Inorder and Postorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/)

```java
// postorder is left -> right -> root so construct from backwards
// because root will be last element
class Solution {
    private Map<Integer, Integer> map;
    private int postIndex;
    
    public TreeNode buildTree(int[] inorder, int[] postorder) {
        map = new HashMap<>();
        postIndex = postorder.length - 1;
        for(int i = 0 ; i < inorder.length ; i++){
            map.put(inorder[i], i);
        }
        return build(postorder, 0, inorder.length - 1);
    }

    private TreeNode build(int[] postorder, int start, int end){
        if(start > end) return null;

        int rootVal = postorder[postIndex--];

        TreeNode root = new TreeNode(rootVal);

        int inPos = map.get(rootVal);
        //⚠️ root -> right -> left
        root.right = build(postorder, inPos + 1, end);

        root.left = build(postorder, start, inPos - 1);

        return root;
    }
}
```

3. [Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/)

```java
public class Codec {
 
    // Doing using preorder dfs traversal
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        serializeHelper(root, sb);
        return sb.toString();
    }

    private void serializeHelper(TreeNode root, StringBuilder sb){
        if(root == null){
            sb.append("null,");
            return;
        }
        sb.append(root.val).append(",");
        serializeHelper(root.left, sb);
        serializeHelper(root.right, sb);
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        String[] values = data.split(",");
        // ⚠️❗Java passes by value, so changes made in recursive call
        // won't persist after call return for primitives
        // In normal recursion child branches are independent but 
        // here right subtree needs to know how many indexes are utilized by 
        // left subtree
        // 1) Pass a object: array is object, java passes reference by value
        // each recursive call points to same heap memory location
        // 2) Instance variable : private int index = 0; Shared state across
        // the class instance
        /* Primitive : pass copy of data, Object: pass copy of address*/
        int[] index = {0};
        return deserializeHelper(values, index);
    }

    private TreeNode deserializeHelper(String[] values, int[] index){
        if(values[index[0]].equals("null")){
            index[0]++;
            return null;
        }
        
        TreeNode root = new TreeNode(Integer.parseInt(values[index[0]]));

        index[0]++;

        root.left = deserializeHelper(values, index);

        root.right = deserializeHelper(values, index);

        return root;
    }
}
```

4. [All Nodes Distance K in Binary Tree](https://leetcode.com/problems/all-nodes-distance-k-in-binary-tree/)

```java
//Graph like traversal problem inside a tree, along with left, right, we need root also
class Solution {
    public List<Integer> distanceK(TreeNode root, TreeNode target, int k) {
        List<Integer> ansList = new ArrayList<>();
        //❗Helps in preventing duplicate node values
        Map<TreeNode, TreeNode> parentMap = new HashMap<>();
        dfs(root, parentMap, null);
        distanceHelper(target, null, 0, k, parentMap, ansList);
        return ansList;
    }
    //get all parents of each node
    private void dfs(TreeNode node, Map<TreeNode, TreeNode> parentMap, TreeNode parentNode){
        if(node == null) return;
        dfs(node.left, parentMap, node);
        parentMap.put(node, parentNode);
        dfs(node.right, parentMap, node);
    }

    private void distanceHelper(TreeNode target, TreeNode previous, int dist, int k, Map<TreeNode, TreeNode> parentMap,
 List<Integer> ansList){
        if(target == null) return;
        if(dist == k){
           ansList.add(target.val);
           return;
        }
        dist = dist + 1;
        //⚠️ don't visit the previous parent node again, 
        // 5 -> 3 (root), 3(left) -> 5
        if(target.left != previous) distanceHelper(target.left, target, dist, k, parentMap, ansList);
        if(target.right != previous) distanceHelper(target.right, target, dist, k, parentMap, ansList);
        if(parentMap.get(target) != previous) distanceHelper(parentMap.get(target), target, dist, k, parentMap, ansList);
    }
}
```

5. [Burn Binary Tree](https://leetcode.com/problems/burning-tree/)

```java
```

6. [Morris Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)

```java
```
