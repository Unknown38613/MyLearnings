## Trie — Non-negotiable

* [Implement Trie (Prefix Tree) — LC 208](https://leetcode.com/problems/implement-trie-prefix-tree/)

```java
class Trie {
    //creates 26 null references 
    Trie[] children = new Trie[26];
    boolean isWord = false;

    public Trie() {}
    
    public void insert(String word) {
        //Trie object itself is root
        Trie curr = this;
        for(char c : word.toCharArray()){
            int i = c - 'a';
            if(curr.children[i] == null){
                //Create a new Trie node and store its reference in the ith child
                curr.children[i] = new Trie();
            }
            curr = curr.children[i];
        }
        curr.isWord = true;
    }
    
    public boolean search(String word) {
        Trie curr = this;
        for(char c : word.toCharArray()){
            int i = c - 'a';
            if(curr.children[i] == null) return false;
            curr = curr.children[i];
        }
        return curr.isWord;
    }
    
    public boolean startsWith(String prefix) {
        Trie curr = this;
        for(char c : prefix.toCharArray()){
            int i = c - 'a';
            if(curr.children[i] == null) return false;
            curr = curr.children[i];
        }
        return true;
    }
}

/**
 * Your Trie object will be instantiated and called as such:
 * Trie obj = new Trie();
 * obj.insert(word);
 * boolean param_2 = obj.search(word);
 * boolean param_3 = obj.startsWith(prefix);
 */
```

* [Design Add and Search Words Data Structure — LC 211](https://leetcode.com/problems/design-add-and-search-words-data-structure/)

```java
class WordDictionary {

    static class TrieNode{
        TrieNode[] children = new TrieNode[26];
        boolean isWord = false;
    }

    TrieNode root;

    public WordDictionary() {
        root = new TrieNode();
    }
    
    public void addWord(String word) {
        TrieNode curr = root;
        for(char c : word.toCharArray()){
            int i = c - 'a';
            if(curr.children[i] == null){
                curr.children[i] = new TrieNode();
            }
            curr = curr.children[i];
        }
        curr.isWord = true;
    }
    
    //wildcard dfs search with backtracking
    public boolean search(String word) {
        return dfs(root, word, 0);
    }

    public boolean dfs(TrieNode curr, String word, int idx){
        if(idx == word.length()) return curr.isWord;

        char c = word.charAt(idx);

        if(c != '.'){
            int i = c - 'a';
            if(curr.children[i] == null) return false;
            curr = curr.children[i];
            return dfs(curr, word, idx + 1);
        }
        else{
            for(TrieNode child : curr.children){
                if(child != null){
                    if(dfs(child, word, idx + 1)) return true;
                }
            }
        }
        return false;
    }
}

/**
 * Your WordDictionary object will be instantiated and called as such:
 * WordDictionary obj = new WordDictionary();
 * obj.addWord(word);
 * boolean param_2 = obj.search(word);
 */
```

* [Word Search II — LC 212](https://leetcode.com/problems/word-search-ii/)

```java
class Solution {

    static class TrieNode{
        TrieNode[] children = new TrieNode[26];
        String word = null; //⚠️ store entire word 
    }

    TrieNode root = new TrieNode();

    public List<String> findWords(char[][] board, String[] words) {
        constructTrie(words);
        List<String> res = new ArrayList<>();
        int r = board.length;
        int c = board[0].length;

        for(int i = 0 ; i < r ; i++){
            for(int j = 0 ; j < c ; j++){
                dfs(i, j, board, root, res);
            }
        }
        return res;
    }

    private void constructTrie(String[] words){
        for(String word : words){
            TrieNode curr = root;
            for(char c : word.toCharArray()){
                int i = c - 'a';
                if(curr.children[i] == null){
                    curr.children[i] = new TrieNode();
                }
                curr = curr.children[i];
            }
            curr.word = word;
        }
    }

    private void dfs(int i, int j, char[][] board, TrieNode parent, List<String> res){

        char temp = board[i][j];
        //Don't use this board cell again in the current path.
        if(temp == '#') return;

        int idx = temp - 'a';
        // is ther any word starting with current char?
        TrieNode curr = parent.children[idx];
        //pruning: if no such thing exists in trie return
        if(curr == null) return;

        //is word? 
        if(curr.word != null){
            res.add(curr.word);
            //avoid two different paths that can form same word
            curr.word = null;
        }

        board[i][j] = '#';
        if(i < board.length - 1) dfs(i + 1, j, board, curr, res);
        if(i > 0) dfs(i - 1, j, board, curr, res);
        if(j < board[0].length - 1) dfs(i, j + 1, board, curr, res);
        if(j > 0) dfs(i, j - 1, board, curr, res);
        board[i][j] = temp;

    }
}
```

* [Replace Words — LC 648](https://leetcode.com/problems/replace-words/)

```java
class Solution {

    static class TrieNode{
        TrieNode[] children = new TrieNode[26];
        String word = null;
    }

    TrieNode root = new TrieNode();

    public String replaceWords(List<String> dictionary, String sentence) {
        buildTrie(dictionary);
        String[] words = sentence.split(" ");
        StringBuilder sb = new StringBuilder();
        for(String word : words){
            TrieNode curr = root;
            //⚠️❗ if cannot be replaced then let the original word be
            String replace = null;

            for(char c : word.toCharArray()){
                int i = c - 'a';
                //if no children means no root found, break and put original word
                if(curr.children[i] == null){
                    break;
                }
                
                curr = curr.children[i];
                
                //root found in children pick and break
                if(curr.word != null) {
                    replace = curr.word;
                    break;
                }
            }

            if(replace != null){
               sb.append(replace);
            }
            else{
               sb.append(word);
            }

            sb.append(" ");
        }

        return sb.toString().trim();
    }

    private void buildTrie(List<String> dictionary){
        for(String word : dictionary){
            TrieNode curr = root;
            for(char c : word.toCharArray()){
                int i = c - 'a';
                if(curr.children[i] == null) {
                    curr.children[i] = new TrieNode();
                }
                curr = curr.children[i];
            }
            curr.word = word;
        }
    }
}
```

* [Map Sum Pairs — LC 677](https://leetcode.com/problems/map-sum-pairs/)

```java
class MapSum {

    static class TrieNode{
        TrieNode[] children = new TrieNode[26];
        int sum = 0;
    }

    TrieNode root;
    Map<String, Integer> map;

    public MapSum() {
        root = new TrieNode();
        map = new HashMap<>();
    }
    
    public void insert(String key, int val) {
        //⚠️ if key already exists then replace it with this one 
        // so newval = val - old value
        int newval = val - map.getOrDefault(key, 0);
        map.put(key, val);
        TrieNode curr = root;
        for(char c : key.toCharArray()){
            int i = c - 'a';
            if(curr.children[i] == null) {
                curr.children[i] = new TrieNode();
            }
            curr = curr.children[i];
            curr.sum += newval;
        }
    }
    
    public int sum(String prefix) {
        TrieNode curr = root;
        int sum = 0;
        char[] carr = prefix.toCharArray();
        for(int i = 0 ; i < carr.length ; i++){
            int idx = carr[i] - 'a';
            if(curr.children[idx] == null) return 0;
            curr = curr.children[idx];
        }
        return curr.sum;
    }
}

```

* [Maximum XOR of Two Numbers in an Array — LC 421](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/)

```java
//Greedy HSB Pick algorithm
//For XOR opposite HSB decides whether xor of 2 numbers will be maximum
// << left shift: x << n = x * 2^n
// >> right shift: x >> n = x / 2^n
class Solution {
    //Binary Trie
    static class TrieNode{
        TrieNode[] children = new TrieNode[2];
        int number = 0;
    }

    TrieNode root = new TrieNode();

    public int findMaximumXOR(int[] nums) {
        buildTrie(nums);
        int xorAns = 0;
        for(int i = 0 ; i < nums.length ; i++){
            TrieNode curr = root;
            int currxor = 0;
            for (int j = 31; j >= 0; j--){
                int bit = (nums[i] >> j) & 1;
                int complement = 1 - bit;
                if(curr.children[complement] != null){
            //⚠️ I found the opposite bit in the Trie, so XOR bit j will be 1
                   currxor |= (1 << j);
                   curr = curr.children[complement];
                }
           //⚠️ Even when we don't found complement, we still have to move down
           //on current path
                else{
                    curr = curr.children[bit];
                }
            }
            xorAns = Math.max(xorAns, currxor);
        }
        return xorAns;
    }

    private void buildTrie(int[] nums){
        for(int i = 0 ; i < nums.length ; i++){
            TrieNode curr = root;
            for (int j = 31; j >= 0; j--){  //32 bit representation
                int bit = (nums[i] >> j) & 1;  //Gets value (0 or 1) at index j
                if(curr.children[bit] == null){
                    curr.children[bit] = new TrieNode();
                }
                curr = curr.children[bit];
            }
            curr.number = nums[i];
        }
    }
}
```

* [Search Suggestions System — LC 1268](https://leetcode.com/problems/search-suggestions-system/)

```java
class Solution {
    static class TrieNode{
        TrieNode[] children = new TrieNode[26];
        String word = null;
    }

    TrieNode root = new TrieNode();

    public List<List<String>> suggestedProducts(String[] products, String searchWord) {
        buildTrie(products);
        List<List<String>> suggestedProductsList = new ArrayList<>();
        String search = "";
        for(char c : searchWord.toCharArray()){
            search += c;
            List<String> foundProductsList = findProducts(search);
            suggestedProductsList.add(foundProductsList);
        }
        return suggestedProductsList;
    }

    private void buildTrie(String[] products){
        for(String product : products){
            TrieNode curr = root;
            for(char c : product.toCharArray()){
                int i = c - 'a';
                if(curr.children[i] == null){
                    curr.children[i] = new TrieNode();
                }
                curr = curr.children[i];
            }
            curr.word = product;
        }
    }

    private List<String> findProducts(String searchWord){
        List<String> productList = new ArrayList<>();
        TrieNode curr = root;
        for(char c : searchWord.toCharArray()){
            int i = c - 'a';
            if(curr.children[i] == null) return new ArrayList<>();
            curr = curr.children[i];
        }

        boolean value = dfs(curr, productList);

        return productList;
    }

    private boolean dfs(TrieNode curr, List<String> productList){
        if(curr.word != null){
            productList.add(curr.word);
        }

        if(productList.size() >= 3) return false;

        for(TrieNode child : curr.children){
            if(child != null){
                if(!dfs(child, productList)) return false;
            }
        }

        return true;
    }
}
```

* [Concatenated Words — LC 472](https://leetcode.com/problems/concatenated-words/)

```java
```

* [Stream of Characters — LC 1032](https://leetcode.com/problems/stream-of-characters/)

```java
```

* [Maximum XOR With an Element From Array — LC 1707](https://leetcode.com/problems/maximum-xor-with-an-element-from-array/)

```java
```
