### TLDR;
- A **lexical environment** tracks what variables are visible and where.
- **Block scope** limits variable visibility to `{}` blocks.
- **Hoisting** moves variable declarations to the top but behaves differently for `var` vs `let`/`const`.
- Use **`let` and `const`** to avoid hoisting confusion and limit variable access to where it’s needed.
- **`var`** is older and more error-prone due to being function-scoped and hoisted as `undefined`.

This is an ever confusing concept, so **What is a lexical environment?** -

- Lexical environment is where variables and functions live in the code
- Every time a block of code runs (like a function or a block wrapped in `{}`), a new lexical environment is created, that keeps track of
	- The variables and functions declared inside it
	- A reference to the outer environment (where the code was written)

This helps JavaScript know what variables are accessible at any point in the code

Let's understand what is meant by block scope >> A block in JavaScript is any code inside `{}` - like in loops, if statements, or functions

> Block scope means variables declared inside that block are only accessible inside that bloack

- `let` and `const` are block-scoped
- `var` is not block-scoped, it's function-scoped

### Hoisting
It is JavaScript's behavior of *moving declarations to the top* of their scope before running the code, but there's a difference in how `var`, `const` and `let` are hoisted,
- `var` declarations are hoisted and initialized as `undefined`
- `let` and `const` are hoisted, but not initialized. They stay in a "temporal dead zone"  until the line where they are declared

|Keyword|Scope|Hoisted|Re-declarable|Re-assignable|
|---|---|---|---|---|
|`var`|Function scope|Yes (as `undefined`)|Yes|Yes|
|`let`|Block scope|Yes (TDZ)|No|Yes|
|`const`|Block scope|Yes (TDZ)|No|No|

```js
function test() {
  console.log(a); // undefined (var is hoisted)
  // console.log(b); // Error (b is in TDZ)
  // console.log(c); // Error (c is in TDZ)

  var a = 10;
  let b = 20;
  const c = 30;

  if (true) {
    var x = 40; // available throughout the function
    let y = 50; // only inside this block
    const z = 60; // only inside this block
  }

  console.log(x); // 40
  // console.log(y); // Error (block scoped)
  // console.log(z); // Error (block scoped)
}
```