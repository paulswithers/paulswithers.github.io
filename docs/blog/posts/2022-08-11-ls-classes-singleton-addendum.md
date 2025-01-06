---
slug: ls-classes-singleton-addendum
date: 
  created: 2022-08-11
categories:
  - VoltScript
tags: 
  - VoltScript
  - LotusScript
  - Domino
  - Volt MX Go
links:
  - blog/2022-08-02-ls-classes-3.md
comments: true
---
# LotusScript Classes - Singleton Addendum

After my [blog post](./2022-08-02-ls-classes-3.md) last week on LotusScript classes and using `Static Property Get` to create singletons, there was some discussion on [OpenNTF's Discord](https://openntf.org/discord) about the challenges of forcing use of the singleton. "Singleton" is a misnomer really, because it's not scoped to the JVM asaJava singleton would be. But I can't think of a better name yet, so I'll stick with that terminology, but be aware of the specific scope for static instances in LotusScript / VoltScript.

<!-- more -->

Firstly, it's not possible to create a public static property of a private class. So you cannot hide the class in the script file. And the `New` method is a Sub, so I couldn't find a way to define what the current instance is during the New sub, and so always return the same instance. That of course is possible in an LSX, as shown with the NotesSession class. No matter how many times you use `Dim session as New NotesSession` or `Dim s as New NotesSession`, every time you are returning the same instance of the NotesSession class - it is truly a LotusScript singleton.

I played about with a few scenarios, and the best I could come up with was a way to _prevent_ users creating new instances. First the script file needs a private global variable for whether or not the call is from the static instance: `Private fromInstance as Boolean`.

Next, we need the static public property of our class - we'll use a class called `Config` as in the previous blog post. The code for our public property is this:

```vbscript
Public Property Get Config As Config
	Static this As Config
	If (this Is Nothing) Then
        fromInstance = true
		Set this = New Config()
        fromInstance = false
	End If
	Set Config = this
End Property
```

This looks very similar to what we had before, except before instantiating the `Config` class, we set the global `fromInstance` variable to true, then reset it to false. It's a global and global variables persist, so we need to reset it.

Now, in the constructor for the Config class, we just need to check the `fromInstance` variable, and throw an error accordingly:

```vbscript
Sub New
    If (Not fromInstance) Then
        Error 1403, "Config cannot be instantiated in this way, use FooInstance variable"
    End If
End Sub 
```

Now if you use `Dim Config as New Config()`, you will get a runtime error. If you use `Print Config.version`, you will be fine.
