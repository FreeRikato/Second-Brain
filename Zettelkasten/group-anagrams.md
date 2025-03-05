```python
def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
	hashMap = defaultdict(list)
	for s in strs:
		hashMap[''.join(sorted(s))].append(s)
	return list(hashMap.values())
```
```ts
function groupAnagrams(strs: string[]): string[][] {
	let hashMap = new Map<string, Array<string>>()
	for(const s of strs){
		let sorted_s = [...s].sort().join("")
		if(!hashMap.has(sorted_s)){
			hashMap.set(sorted_s, [s])
		} else {
			hashMap.get(sorted_s).push(s)
		}
	}
	return Array.from(hashMap.values())
};
```