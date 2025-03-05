## Hashmap
```python
def twoSum(self, nums: List[int], target: int) -> List[int]:
	hashMap = defaultdict(int)
	for i in range(len(nums)):
		complement = target - nums[i]
		if complement in hashMap:
		return [i, hashMap[complement]]
		hashMap[nums[i]] = i
	return []
```
```ts
function twoSum(nums: number[], target: number): number[] {
	const hashMap = new Map<number, number>
	for (let i = 0; i < nums.length; i++){
		let complement = target - nums[i]
		if(hashMap.has(complement)) return [i, hashMap.get(complement)]
		hashMap.set(nums[i], i)
	}
	return []
};
```

