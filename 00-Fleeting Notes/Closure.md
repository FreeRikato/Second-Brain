In JavaScript, **closures** are a fundamental concept that allow functions to "remember" and access variables from their **outer (enclosing) scope**, even after that scope has finished executing.

> A **closure** is created when a function is defined inside another function, and the inner function accesses variables from the outer function's scope.

```js
function outerFunction() {
  let outerVariable = "I am from outer";

  function innerFunction() {
    console.log(outerVariable); // innerFunction can access outerVariable
  }

  return innerFunction;
}

const closureFunc = outerFunction();
closureFunc(); // Output: "I am from outer"
```

### Why Closures Matter:
- **Data privacy** (e.g., creating private variables)
- **Currying** and **function factories**
- Used in **event handlers**, **callbacks**, and **async code**

Example:
```js
function createCounter() {
  let count = 0;

  return function () {
    count++;
    return count;
  };
}

const counter = createCounter();
console.log(counter()); // 1
console.log(counter()); // 2
```

Example to understand the problem and how to fix it:
``` js
for (var i = 1; i <= 3; i++) {
  setTimeout(function () {
    console.log("Count:", i);
  }, i * 1000);
}

// Output:
Count: 4
Count: 4
Count: 4
```

`var` is **function-scoped**, and all three callbacks **share the same `i`**, which ends at `4` after the loop finishes.

```js
for (var i = 1; i <= 3; i++) {
  (function (j) {
    setTimeout(function () {
      console.log("Count:", j);
    }, j * 1000);
  })(i);
}

// Output:
Count: 1
Count: 2
Count: 3
```

Each `setTimeout` callback remembers its own value of `j` because of the closure created by the Immediately Invoked Function Expression (**IIFE**).

```js
for (let i = 1; i <= 3; i++) {
  setTimeout(function () {
    console.log("Count:", i);
  }, i * 1000);
}
```

`let` is **block-scoped**—each iteration gets a new `i`, effectively mimicking a closure.