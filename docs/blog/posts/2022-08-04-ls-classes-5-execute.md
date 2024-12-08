---
slug: ls-classes-5-execute
date: 
  created: 2022-08-04
category: VoltScript
tags: 
  - VoltScript
  - LotusScript
  - Domino
  - Volt MX Go
links: 
  - blog/2022-07-31-ls-classes-1.md
  - blog/2022-08-01-ls-classes-2.md
  - blog/2022-08-02-ls-classes-3.md
  - blog/2022-08-03-ls-classes-4.md
comments: true
---
# LotusScript Classes Deep Dive Part Five: Execute

In the previous parts [one](./2022-07-31-ls-classes-1.md), [two](./2022-08-01-ls-classes-2.md), [three](./2022-08-02-ls-classes-3.md) and [four](./2022-08-03-ls-classes-4.md) I talked about various aspects of LotusScript / VoltScript classes. But there's a LotusScript function which has become very relevant for me recently, in the context of classes.

<!-- more -->

## The Basics

Almost all Domino developers are used to writing LotusScript, compiling it and running it. But for those who have dug into the mail template or maybe other advanced coding, there is a less well-known approach to running LotusScript - `Execute`. Execute takes a string of LotusScript.

This is actually nothing new for Domino developers. There are at least two direct comparisons I can think of. The first is also in LotusScript - `Evaluate`, which also takes a string, this time a string of Formula Language, and runs it using the Formula Language engine. The second is XPages, where properties take a string prefixed with "javascript:" and run it using a Server-Side JavaScript engine; or it takes a string prefixed with "el:" and runs it with the Expression Language engine. In the case of XPages and Server-Side JavaScript, there is an editor that performs some validation of the string to catch runtime errors. But it's still a string, parsed and processed at runtime.

To give a simple example, imagine the following simple piece of LotusScript:

`Print "Hello World"`

The same code can be achieved with Execute:

`Execute "Print \"Hello World\""`

Of course LotusScript allows different delimiters for strings, which makes things a lot easier. So we can have:

`Execute |Print "Hello World"|`

## Passing Context

On the surface, this may seem of little benefit. There is not much point is switching a `Print` statement for an `Execute` statement that prints. There may be use cases for running dynamic LotusScript - maybe LotusScript that's stored in a config document. But the real benefit, as with `Evaluate` and EL / SSJS, comes from running dynamic LotusScript with _context_.

To explore those a little further, there are two main use cases for `Evaluate` in LotusScript. The first one is to use `@Round`, to perform half-up rounding as opposed to bankers rounding, which is what the LotusScript `Round` function does. The second is to run contextual formula language, passing a string and a NotesDocument as the context in which to run the Formula Language. Imagine the following LotusScript:

`Evaluate(|@Round(unit_price x qty)|, doc)`

This is taking the `doc` variable and using it as a context in which to perform the `@Round`. So the variables `unit_price` and `qty` map to fields of the contextual Notes Document, `doc`.

SSJS and EL do the same thing. `#{database.title}` or `#{javascript:database.getTitle()}` run using the `database` variable for the current context. Of course there are other variables that can be used, like `session`, `view` or the variable defined in the `var` property of a repeat control. Take it to a more advanced coding level, and you can contribute additional variables as we did at various times with OpenNTF Domino API. And with the `binding` property of a component, you can access that component from outside of its current context.

The same can be done with `Execute`. It's just that the variables need to be scoped appropriately. For `Execute` that means declaring the variables as **Globals**. Then you can just reference those variables within the Execute statement. So imagine the following code:

```vbscript
Private doc as NotesDocument

Sub calcTotal(idex as Integer)
    Execute(|doc.total_| & idex & | = doc.qty_| & idex & |(0) * doc.price_| & idex & |(0)|)
End Sub
```

The `calcTotal()` sub can be used to set a relevant total field to the product of its quantity and price. If the parameter passed in is `1`, the string that is executed is calculated as `doc.total_1 = doc.qty_1 * doc.price_1`. If `2` is passed in, the string that is executed is `doc.total_2 = doc.qty_2 * doc.price_2`. Because `doc` is a global variable, defined in the Declarations of an Agent or Script Library, the Execute statement has access to it.

Of course with the NotesDocument class, there are other ways of doing this. But with custom classes, especially if the class has not been written yet, that can't be guaranteed. Imagine you want generic code to set variables in a class. Now we can do this:

```vbscript
Private obj as Variant

Sub setVariable(varName as String, var as Variant)
    Execute(|obj.| & varName & | = | & var)
End Sub
```

There are a wide variety of use cases here for dynamic processing of an object. But there are three points to bear in mind:

1. `var` here can only be a scalar or array. If it's an object, you need to pass it to a global variable and pass that to the `Execute` statement, as is being done with `obj`.
2. If `var` is a String, then the `Execute` line isn't actually setting the variable as a string - it's setting it to a variable with the string name. You'll realise if you transpose the variables into the statement, because if `varName` if "foo" and `var` is "bar", what we get us `obj.foo = bar`. What we need is `obj.foo = "bar"`. So the execute statement needs to be `Execute(|obj.| & varName & | = "| & var & |"|)`.
3. If `var` is an array, for example a String array, the variable cannot be declared as `Public foo() as String`. That's because you cannot use assignment to load an array declared like that, you would need to redim the variable (`foo`) to the same bounds as the source array (`var`), iterate the source array, and assign each element in turn. The cleaner way is for the variable to be declared as a Variant - `Public foo as Variant`.

The final point to bear in mind is returning values. As with normal code, if you're returning an object you need to use `Set`, if you're returning a scalar or array, you need to _not_ use `Set`. This can create some more complex code if you're creating something generic. Once you have the return value, `IsArray()` will tell you if it's an array of _something_. `IsObject()` to know whether or not something you're dealing with is an object or, against an element in an array, whether it's an array of objects - and so you need to use `Set`. `IsScalar()` can be used to do the opposite.

There are a number of scenarios where you might want to run custom code, and a variety of places those custom code strings may reside. But `Execute` provides a great deal of power.
