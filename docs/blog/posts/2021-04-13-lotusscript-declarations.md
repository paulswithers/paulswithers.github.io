---
slug: lotusscript-declarations
date: 2021-04-13
categories:
  - Domino
tags: 
  - Domino
  - LotusScript
comments: true
---
# LotusScript Declarations

**How can you get a "Type Mismatch" error in a Forall loop in LotusScript?**

This was the question a few of us hit with a recent bit of coding. You can't declare the forall variable, and if you're iterating over a variant containing only strings, surely this shouldn't happen. The loop was quite basic:

<!-- more -->

``` vbscript
ForAll element In me.getContent()
    ' Do something
End ForAll
```

The syntax was correct, so the next step was to look for something unusual. The one thing that was out of the ordinary was that the forall loop was duplicated within the sub - exactly the same code, so it was just copied and pasted. But the forall loops were within an if statement, and only one of them should ever be encountered. Stepping through in debug, only one of them was being encountered. So why the problem?

Our first step was to put `me.getContent()` into a variable so we could step through in debugger and verify the datatype, so:

``` vbscript
Dim values as variant
values = me.getContent()
ForAll element In values
    ' Do something
End ForAll
```

Obviously we needed a different variable name for each loop. Because they were in an if statement, I suggested putting the dim within the if statement, so it only got declared if the code went into the if statement. Rocky (Oliver) pointed out though that every dim gets loaded at the start of the class. So there is no performance benefit in declaring variables within your code.

This suggested the actual cause of the problem, that for some reason there was some problem converting the forall variable to a string, because the same variable name was used for two loops. Sure enough, changing the forall variable name in one of the loops solved the problem.

Of course, the _correct_ solution was to refactor the code so that the relevant chunk of code was moved to a function.

After some time developing with Java, the obvious desire though was to be able to select the chunk of code, right-click and refactor automatically. But that's not possible. And while we do difficult immediately, the impossible takes a little longer.