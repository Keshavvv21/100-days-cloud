# Loops and Functions in Bash

## Overview

Bash scripts often require:

* Repeating tasks → **Loops**
* Reusable blocks of code → **Functions**

Using loops and functions makes scripts **cleaner, reusable, and maintainable**.

---

## Bash Loops

Loops allow executing a block of code multiple times based on a condition or list.

---

## 1. for Loop

### Syntax

```bash
for variable in list
 do
   commands
 done
```

### Example: Print Numbers

```bash
for i in 1 2 3 4 5
do
  echo "Number: $i"
done
```

### Example: Loop Using Range

```bash
for i in {1..5}
do
  echo "Count: $i"
done
```

---

## 2. while Loop

### Syntax

```bash
while [ condition ]
do
  commands
done
```

### Example: Countdown

```bash
count=5
while [ $count -gt 0 ]
do
  echo $count
  count=$((count - 1))
done
```

---

## 3. until Loop

Runs until the condition becomes **true**.

### Syntax

```bash
until [ condition ]
do
  commands
done
```

### Example

```bash
num=1
until [ $num -gt 5 ]
do
  echo $num
  num=$((num + 1))
done
```

---

## 4. Loop Control Statements

### break

Stops the loop.

```bash
for i in {1..10}
do
  if [ $i -eq 5 ]; then
    break
  fi
  echo $i
done
```

### continue

Skips current iteration.

```bash
for i in {1..5}
do
  if [ $i -eq 3 ]; then
    continue
  fi
  echo $i
done
```

---

## Bash Functions

Functions are reusable blocks of code that perform specific tasks.

---

## 1. Defining a Function

### Syntax

```bash
function_name() {
  commands
}
```

OR

```bash
function function_name {
  commands
}
```

---

## 2. Simple Function Example

```bash
greet() {
  echo "Hello, Welcome to Bash"
}

greet
```

---

## 3. Function with Arguments

```bash
add() {
  sum=$(( $1 + $2 ))
  echo "Sum: $sum"
}

add 5 10
```

* `$1`, `$2` → Function arguments

---

## 4. Function with Return Value

Bash functions return values using **exit status** or **echo**.

### Using echo

```bash
multiply() {
  echo $(( $1 * $2 ))
}

result=$(multiply 4 5)
echo "Result: $result"
```

---

## 5. Local Variables in Functions

```bash
example() {
  local msg="Local Variable"
  echo $msg
}

example
```

---

## Combining Loops and Functions

```bash
print_numbers() {
  for i in {1..3}
  do
    echo "Number: $i"
  done
}

print_numbers
```

---

## Best Practices

* Use meaningful variable and function names
* Prefer functions for repeated logic
* Use `local` variables inside functions
* Add comments for readability
* Use `#!/bin/bash` at the top of scripts

---

## Sample Script Structure

```bash
#!/bin/bash

say_hello() {
  for name in Alice Bob Charlie
  do
    echo "Hello $name"
  done
}

say_hello
```

---

## Conclusion

Loops and functions are **core building blocks** of Bash scripting. Mastering them helps you write **efficient, reusable, and professional shell scripts**.


