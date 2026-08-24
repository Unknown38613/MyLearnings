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

## Level 5 — Advanced

1. [Construct Binary Tree from Preorder and Inorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

```java
```

2. [Construct Binary Tree from Inorder and Postorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/)

```java
```

3. [Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/)

```java
```

4. [All Nodes Distance K in Binary Tree](https://leetcode.com/problems/all-nodes-distance-k-in-binary-tree/)

```java
```

5. [Burn Binary Tree](https://leetcode.com/problems/burning-tree/)

```java
```

6. [Morris Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)

```java
```
