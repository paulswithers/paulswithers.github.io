---
slug: ls-variants
date: 
  created: 2022-12-06
categories:
  - LotusScript
tags: 
  - LotusScript
  - VoltScript
  - Domino
comments: true
---
# LotusScript Variants: EMPTY, NULL, Nothing

One of the great things about working on VoltScript with our team are the regular discussions about the inner workings of the language. Of course it's also nice how easy it is to write and run a test script with the language, to quickly test various scenarios. Recently, because of two separate initiatives we've been working on, the topic of conversation has been Variants, and the potential values that denote a variant without a value.

<!-- more -->

## Understanding a Variant

Firstly, it's important to note that the Variant datatype is a catch-all variable datatype designed to hold any type of "thing". These different "things" are:

- scalars - strings, numerics, booleans, bytes.
- objects - instances of LSX classes or custom classes.
- arrays - indexed collections of scalars, objects, or both.

This explains certain language functions that can be run against Variants:

- `isScalar()`, returning true for scalars.
- `isObject()`, returning true for objects.
- `isArray()`, returning true for arrays.

But there are three other "values" that a variant can have: EMPTY, NULL or Nothing. The explanation for why these exist comes down to those first two types of "things" a variant can contain.

## EMPTY

When you create a Variant, it has a default value - EMPTY. This can be seen with the following code:

```vbscript
Dim foo as Variant
Print TypeName(foo) 'Prints EMPTY
Print IsEmpty(foo)  'Prints true
```

It's not possible to explicitly set a variable to EMPTY - `foo = EMPTY` will not compile. And you can't "empty" a variant. The only way to "reset" a variant is to set it to a variant variable that has never had a value put into it.

But `IsEmpty()` is not the only function that is relevant to the EMPTY datatype. Try the following:

```vbscript
Print isArray(foo)
Print isScalar(foo)
Print isObject(foo)
```

It's not a surprise that the first line prints "False". What is more important is that the second prints "True" and the third "False".

Yes, EMPTY is a scalar.

This becomes important when you want to assign it to another variable. As [Andre Guirard blogged recently](https://lotusscript.torknado.com/blog/overhead-of-error-trapping-in-lotusscript/), there are two ways to assign a value to a variable - again, depending what kind of "thing" it is. `Set` is the keyword to use for an object. `Let` - which is a [NoOp](https://en.wikipedia.org/wiki/NOP_(code)) and so can be omitted - is the keyword to use for a scalar or array.

The following code will throw a **Type Mismatch** error on the third line:

```vbscript
Dim foo as Variant
Dim bar as Variant
Set foo = bar
```

The mismatch is because we're trying to allocate a scalar - EMPTY - to a variant `bar` that we explicitly state (by using `Set`) will be an object.

## Nothing

Nothing, on the contrary, is an object. Try the following:

```vbscript
Dim foo as Variant
Set foo = Nothing
Print isArray(foo)
Print isScalar(foo)
Print isObject(foo)
```

This will print "False", "False" and "True". And note particularly the syntax in the second line: we have to use `Set` to allocate the datatype Nothing to `foo`. Another interesting point is what `Print TypeName(foo)` returns: whereas the datatype for an empty variant is "EMPTY", the datatype for a variant set to Nothing is "OBJECT".

Picking up from our last piece of code from the EMPTY examples, the following will not compile:

```vbscript
Dim foo as Variant
Dim bar as Variant
Set foo = Nothing
bar = foo
```

This doesn't generate a run-time error but a compile-time error, because our code has told the compiler `foo` will be an object. The following code, however, won't generate a compile-time error.

```vbscript
Dim bar as Variant
bar = getFoo()

Function getFoo() as Variant
    Set getFoo = Nothing
End Function
```

That's because the `getFoo()` function returns a variant, but a variant can be a scalar or an object. So instead it will return a runtime error: **SET required on class instance assignment**.

## NULL

Now we come to the interesting part. EMPTY is not the same as "nothing". Instead it means "not initialized".

This becomes crucial when you're allocating a variant to a variable that is *not* a variant. We know that variables are initialized with a value. A string has an initial value "". A numeric has an initial value 0.

```vbscript
Dim foo as Variant
Dim fooInt as Integer
Dim fooStr as String

fooInt = 12
fooStr= "12"
fooInt = foo
fooStr = foo
Print fooInt
Print fooStr
```

The first print statement will print "0". The second print statement will print "". Setting it to the "not initialized" value resets the Integer and the String to their default values.

But what if a blank string or 0 means something else. What if you want to return potentially a string or integer, but also something that's *not* a string or an integer. For example, in `ArrayGetIndex()`?

This is where NULL comes in, and why we have `IsNull()`. And this is also where variants come in.

The following code will work, and print 1:

```vbscript
Dim arr(1) as String
Dim fooInt as Integer

arr(0) = "Hello"
arr(1) = "World"
fooInt = ArrayGetIndex(arr, "Hello")
Print fooInt
```

But change the penultimate line to `fooInt = ArrayGetIndex(arr, "Hellos")` and you'll get an error - **Invalid use of null**. This becomes apparent from the following code:

```vbscript
Dim foo as Variant

foo = NULL
Print isArray(foo)
Print isScalar(foo)
Print isObject(foo)
Print isNull(foo)
```

This prints "False", "False", "False", "True". NULL is not an array (not surprisingly), not a scalar, not an object.

The ArrayGetIndex example can be fixed like so:

```vbscript
Dim arr(1) as String
Dim foo as Variant

arr(0) = "Hello"
arr(1) = "World"
foo = ArrayGetIndex(arr, "Hellos")
Print foo
```

`IsNull()` can be used to test if it's returned null, but otherwise it will return a variant of datatype "INTEGER". Thus ArrayGetIndex only needs to be run once, but can be used to check if the value is in the array *and* get its index, if it does.

## Caveat

But let's look back at the earlier example with a `getFoo()` function:

```vbscript
Function getFoo() as Variant
    ...
End Function
```

This function could return a scalar *or* an object. If the code is looking up something and actually finds something value, we check if it's an object and, if it is, use `Set` otherwise omit it.

But what if we don't get something? The calling code knows whether it expects an object or a scalar. But our `getFoo()` function doesn't. I'll leave that problem with you for now, but it is a problem that generic code needs to handle.
