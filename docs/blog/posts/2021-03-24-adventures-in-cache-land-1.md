---
slug: adventures-in-cache-land-1
date: 
  created: 2021-03-24
category: Domino
tags: 
  - Domino
  - LotusScript
comments: true
---
# Adventures in CacheLand 1

Recently I've been involved in a project with a lot of LotusScript. As a team our approach has been to structure the code according to best practices and leveraging what we've learned from other languages. Standards are always good, but there are always peculiarities that impact what you do. The crucial skill is to be able to work out what is happening when the standard ways don't produce expected results. And most importantly, work out how to work around them.

<!-- more -->

One of the standards we chose was to use a lot of constants and store those in a single Script Library. That Script Library is then used in the other Script Libraries (and there are quite a few). This makes the structure cleaner. There are two constants that need to be changed during deployment, so it also simplifies where people need to go to make the changes.

Unfortunately, we found that when changing the constants in Script Library A, the old values were retained by dependent Script Libraries B, C, D etc. We knew Script Libraries are cached. But it appears LotusScript Script Libraries effectively caches the constant value.

So the code did not retrieve the value of the constant from Script Library A at run-time. If I remember correctly, we also tried closing a re-opening the Notes Client after changing, but I can't be certain. The conclusion we came to was that constants were cached at compile time of Script Libraries B, C, D etc.

Of course recompiling all LotusScript would solve the problem. But there were reasons why that was not an optimal solution. Our working hypothesis was that changing to reference the constant in a function call would ensure it didn't cache the value. Because the constant was then only used within the Script Library being saved, caching would not be a problem.

But rather than use a function, we used a [Property statement](https://help.hcltechsw.com/dom_designer/11.0.1/basic/LSAZ_PROPERTY_GET_SET_STATEMENTS.html). For those who have not used them, the resulting code is quite similar to a function:

``` vbscript
Property Get VERSION As String
    VERSION = g_VERSION
End Property
```

The differences are you need to specify whether you are defining how to Get or Set the property. Then it's just a case of passing the constant value into the result of the property call.

As expected, this solved the caching problem, but ensured changes just needed to be made in the Constant declaration. So no need to go hunting through code and make changes within the function or property get statement.