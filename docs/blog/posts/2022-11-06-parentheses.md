---
slug: parentheses
date: 
  created: 2022-11-06
category: LotusScript
tags: 
  - LotusScript
  - VoltScript
  - Domino
comments: true
---
# Understanding Parentheses in LotusScript Method Calls

Look at the following code and guess the error message.

<!-- more -->

```vbscript
Class Person
    Public firstName as String
End Class

Sub Initialize
    Dim p as New Person
    Call outerPrint(p)
End Sub

Sub outerPrint(msg as Variant)
    innerPrint(msg)
End Sub

Sub innerPrint(msg as Variant)
    If (TypeName(msg) = "PERSON") Then
        Print msg.firstName
    Else
        Print msg
    End If
End Sub
```

The error message received will be a Type Mismatch, on the line `innerPrint(msg)`. But the cause might be harder to work out - although the title of this blog post might point you in the direction.

Firstly, there's no coding error in the `innerPrint` sub. If you add error handling to `innerPrint()`, it won't log anything. Indeed if you try printing something on the first line of the `innerPrint()` sub, it won't print anything. When the Type Mismatch error logs on the line `innerPrint(msg)`, that is specifically the line and the Type Mismatch is on passing `msg` into that method.

There are two uses for parentheses when calling a LotusScript method. And that is also why it won't be possible to remove the `Call` keyword for VoltScript. Parentheses are used to *just* pass arguments **only** if you include the keyword `Call`. But (accidentally) the `Call` keyword has been omitted in `innerPrint(msg)`. So the second usage for parentheses when calling methods is being used, namely that the parentheses mean "pass the variable by value rather than by reference". If it had been written `innerPrint (msg)`, it might have been more obvious. You could also use `Call innerPrint((msg))`, in which case the outer parentheses denote arguments to pass and the inner parentheses identify this argument as being passed by value.

Of course pass by value can be explicitly required on a method by using the `ByVal` keyword. So `Sub innerPrint(ByVal msg as Variant)` means the argument being passed into `innerPrint` will always be passed by value rather than by reference. The calling code cannot override this. But wrapping an argument in parentheses when calling the method will also pass it by value. This isn't exclusive to LotusScript. It's also the same in [Visual Basic](https://learn.microsoft.com/en-us/dotnet/visual-basic/programming-guide/language-features/procedures/passing-arguments-by-value-and-by-reference#determination-of-the-passing-mechanism).

But only scalars can be passed by value in LotusScript. You cannot pass an array, a List, a [Type instance](https://help.hcltechsw.com/dom_designer/12.0.0/basic/LSAZ_TYPE_STATEMENT.html) or an object by value. If the code had been `Call outerPrint("Hello World")`, it would have run fine. But because we're passing an object - an instance of the Person class - it throws an error at runtime. If we had called `innerPrint` directly from the `Sub Initialize`, the compiler would have generated an error. But because the Person object is being passed into the `outerPrint` method as a Variant *and not being re-cast explicitly as an instance of the Person class*, the compiler cannot generate an error.

Typically this would only bite a developer if they're writing a framework, something where arguments are defined as Variants because the code needs to handle various different datatypes. But it's one that, when it bites, it can be harder to identify. This is because passing by value vs by reference is done so rarely in LotusScript.
