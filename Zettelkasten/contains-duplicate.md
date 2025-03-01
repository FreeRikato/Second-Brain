## Using Hashmap to track elements

```ts
function containsDuplicate(nums: number[]): boolean {
	let hashMap = new Map<number, number>();
	for(const number of nums){
		if(hashMap.has(number)) return true
		hashMap.set(number, 1)
	}
	return false
};
```
```python
class Solution:
def containsDuplicate(self, nums: List[int]) -> bool:
	hashSet = set()
	for num in nums:
		if num in hashSet: return True
		hashSet.add(num)
	return False
```
## Using Hashset to track elements
```ts
function containsDuplicate(nums: number[]): boolean {
	let hashMap = new Set<number>();
	for(const numbers of nums){
		if(hashMap.has(numbers)) return true
		hashMap.add(numbers)
	}
	return false
};
```
```python
def containsDuplicate(self, nums: List[int]) -> bool:
	return any(value > 1 for value in Counter(nums).values())
```
