import type { Difficulty, Language } from '../types/oj'

export const DIFFICULTY_LABELS: Record<Difficulty, string> = {
  easy: '简单',
  medium: '中等',
  hard: '困难',
}

export const LANGUAGE_OPTIONS: Array<{ value: Language; label: string; monaco: string }> = [
  { value: 'cpp', label: 'C++', monaco: 'cpp' },
  { value: 'java', label: 'Java', monaco: 'java' },
  { value: 'python', label: 'Python 3', monaco: 'python' },
  { value: 'javascript', label: 'JavaScript', monaco: 'javascript' },
]

export const DEFAULT_CODE: Record<Language, string> = {
  cpp: `#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {

    }
};`,
  java: `import java.util.*;

class Solution {
    public int[] twoSum(int[] nums, int target) {

    }
}`,
  python: `class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        pass`,
  javascript: `/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
function twoSum(nums, target) {

}`,
}
