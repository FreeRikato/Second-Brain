## Using Hashmap
```ts
function isAnagram(s: string, t: string): boolean {
	if(s.length !== t.length) return false
	let hashMap = new Map<string, number>()
	for(const character of s){
		if(!hashMap.has(character)) hashMap.set(character, 0)
		hashMap.set(character, (hashMap.get(character) || 0) + 1)
	}
	for(const character of t){
		if(!hashMap.has(character)) hashMap.set(character, 0)
		hashMap.set(character, (hashMap.get(character) || 0) - 1)
	}
	for(const values of hashMap.values()){
		if(values !== 0){
			return false
		}
	}
	return true
};
```
```python
def isAnagram(self, s: str, t: str) -> bool:
	return Counter(s) == Counter(t)
```

## Using Alphabet array
```typescript
function isAnagram(s: string, t: string): boolean {
	if (s.length !== t.length) return false
	const count = new Array(26).fill(0)
	for (let i = 0; i < s.length; i++) {
		count[s.charCodeAt(i) - 'a'.charCodeAt(0)] += 1
		count[t.charCodeAt(i) - 'a'.charCodeAt(0)] -= 1
	}
	for (const value of count) {
		if (value !== 0) return false
	}
	console.log(count)
	return true
};
```
```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False
        alph = [0] * 26
        for i in range(len(s)):
            alph[ord(s[i]) - ord("a")] += 1
            alph[ord(t[i]) - ord("a")] -= 1
        return not any(value != 0 for value in alph)
```