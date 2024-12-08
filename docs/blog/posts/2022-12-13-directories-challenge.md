---
slug: directories-challenge
date: 
  created: 2022-12-13
category: LotusScript
tags: 
  - LotusScript
  - VoltScript
  - Domino
links:
  - blog/2022-06-10-voltscript-a-unique-opportunity.md
comments: true
---
# Andre's Directories Challenge

I am sure that anyone who uses LotusScript has been following the excellent blog posts of [Andre Guirard](https://lotusscript.torknado.com/blog). Recent blog posts on large arrays and queues have been particularly interesting for those of us working on VoltScript. His [blog post on a Queue data structure](https://lotusscript.torknado.com/blog/queue-data-structure/) ended with a challenge. The root of the problem is that the LotusScript `Dir()` function is not recursive. Without a parameter it gives the next file or directory relative to its last call. So you can't have one loop using `Dir()` and an inner loop that also uses `Dir()`. Andre uses a Queue class to perform FIFO (First In First Out), which achieves what's needed, but not as required:

<!-- more -->

> For this task, if you care about the order of the returned results, this probably isn’t what you want. You’d prefer all the files in a given folder to be grouped together with the files from its subfolders, so those last two should be switched.
>
> Exercise for the reader: what data structure could be used instead of a queue to track the work and give the result in the desired order?

Proper Collection and Map classes has always been on our wishlist for [VoltScript](./2022-06-10-voltscript-a-unique-opportunity.md). Immediately after the Factory Tour in Chelmsford in September Devin, Rocky and I stood at a whiteboard and scoped out Collection and Map classes. We took note of how other languages handle the challenge, most notably Java and JavaScript. We also bore in mind a key requirement placed on our work - simplicity. LotusScript has flourished because people without a Computer Science background - like myself - were able to add powerful coded functionality to our databases without the complexity of other languages.

I've got extensive experience of Java and an abiding memory of Collections and Maps in Java is a PDF that lists which class to use for which purpose. For VoltScript we have just two classes - Collection and Map. When creating a Collection, you define whether it is sorted (every Collection is ordered, even if that is insertion order) and whether values should be unique. So what about Queues (FIFO) and Stacks (LILO)? We don't need them, because Collections have `getAndRemoveFirstRaw()` and `getAndRemoveLastRaw()`. This means a Collection can be used as a Queue, or a Stack, or both at the same time ("nibbling" the Collection from both ends, if there's such a need).

So could our Collection solve Andre's problem?

There was only one way to find out - after the latest round of major [refucktoring](https://www.urbandictionary.com/define.php?term=refucktor), and revisiting unit tests to prove I'd fixed everything I'd broken!.

## Converting Andre's Code

I initially thought about creating a Map for each directory holding its files / subdirectory names. But it turned out I was over-complicating it. Andre's idea of a Queue pointed me in the best direction, which proved very simple to adapt.

First I created a directory structure:

- C:\temp\foods with "tomatoes.lss", "bakery", "meat", "fish"
- In bakery directory, three files "baguette.lss", "bread.lss", "croissant.lss"
- In meat directory, three files "beef.lss", "lamb.lss", "pork.lss" and a directory "fish"
- In fish directory, three files "basa.lss", "dover_sole.lss" and "salmon.lss"
- In vegetables directory, two files "broccoli.lss" and "sprouts.lss"

Constants were swapped out (`NEWLINE` for `Chr(10)` etc), the path in Initialize amended accordingly, but no changes needed to `IsLikeAnyOf` function.

The only changes needed were in the FileSearch function, which actually looks very similar:

``` vbscript
Function FileSearch(ByVal baseDir$, ByVal patterns$) As Variant
	Dim delim$, afile$, results$, adir$, patternArr
	Dim workColl As New Collection("STRING", Nothing, False, False)
	Dim files List As Boolean
	Dim dirCount as String
	' find what path delimiter the caller prefers.
	If basedir Like "/*" then
		delim = "/" ' linux style path
	ElseIf basedir Like "\*" Or basedir Like "[A-Z]:\*" Then
		delim = "\" ' windows style path
	Else
		Error 20030, "FileSearch needs an absolute filepath."
	End If
	
	patternArr = Split(LCase(patterns), "|")
	' internally we want all filepaths to end with the folder separator
	If baseDir Like "*[!\/]" Then baseDir = baseDir & delim
	workColl.add basedir
	
	' while there are directories in the queue, process the first directory.
	Do While workColl.hasContent
        dirCount = 0    'Reset, we're on a new directory
		adir = workColl.getAndRemoveFirstRaw
		Erase files
		afile = Dir$(aDir & "*", 6) ' all files but not directories.
		Do Until afile = ""
			files(afile) = True ' remember the names of the files
			If IsLikeAnyOf(LCase(aFile), patternArr) Then
				results = results & Chr(10) & adir & afile
			End If
			afile = Dir$
		Loop
		
		' now find the names of each subfolder.
		afile = Dir$(aDir, 18) ' this will include files also
        
		Do Until afile = ""
			If afile <> "." And afile <> ".." Then
				If Not IsElement(files(afile)) Then
					' this is a folder. Add it to work queue for processing on later iteration.
					Call workColl.insertAt(adir & afile & delim, dirCount++)
				End If
			End If
			afile = Dir$
		Loop
	Loop
	FileSearch = Split(Mid$(results, 2), Chr(10))
End Function
```

On line 3, I use Collection class instead of Queue. The constructor sets "STRING" as the data type of entries, third and fourth parameters mean non-unique and insertion order only, and as a result no comparator needs to be passed as the second parameter. Line 5 declares an additional counters required further down - we'll see why later!

There are then no changes until we get into the Do Until loop. We reset dirCount to 0, we'll see why later. The next line sets `adir`. Whereas Andre's code calls `Get` to retrieve the first entry from the Queue, we call `getAndRemoveFirstRaw()` - raw because the function returns a Variant, because we don't know at compile-time what datatype a given implementation of a Collection will contain.

There are then no other changes until the middle line of the second inner Do Until loop. Andre calls `workq.put adir & afile & delim`, which adds it to the end of the Queue. This is what causes the problem with ordering of the output. But the Collection class allows us to run `Call workColl.insertAt(adir & afile & delim, dirCount++)`. If the Collection is *not* sorted, we can use the `insertAt()` function - for sorted collections the Comparator should decide where entries get put, not the developer. Here we leverage the `dirCount` variable from earlier. This means we're inserting all directories at the **start** of the Collection. As a result, we can iterate any subdirectories before processing sibling directories. And this is why we reset `dirCount` as we process each directory, so subdirectories are always put at the start. You may notice `dirCount++` - we need to increment dirCount as we add subdirectories, so we're not always inserting at element 0.

This then gives us the following output on Windows:

``` txt
C:\temp\foods\tomatoes.lss
C:\temp\foods\bakery\baguette.lss
C:\temp\foods\bakery\bread.lss
C:\temp\foods\bakery\croissant.lss
C:\temp\foods\meat\beef.lss
C:\temp\foods\meat\lamb.lss
C:\temp\foods\meat\pork.lss
C:\temp\foods\meat\fish\basa.lss
C:\temp\foods\meat\fish\dover_sole.lss
C:\temp\foods\meat\fish\salmon.lss
C:\temp\foods\vegetables\broccoli.lss
C:\temp\foods\vegetables\sprouts.lss
```

## Linux

On Linux things get a little more complicated. On Windows it appears `Dir()` automatically processes files in alphabetical order (I deliberately created them in different orders). However, on Linux that's not the case.

So how do we address that?

We create `New Collection("STRING", Nothing, False, True)` and put the files and directories temporarily in that Collection, then process that Collection. The final parameter `True` ensures it the Collection is sorted (sort happens on insertion). The second parameter means it uses a default Comparator, sorting on datatype then `CStr()` of the value - the sorting on datatype is not required, but will have minimal performance impact on a small collection, so produces simpler code.

## Summary

The Collection and Map classes are very much POC at this point. As I mentioned, I've just completed the latest major refactoring, including adding new methods and leveraging some newer constructs we've added to the core language. They've only been used in one project so far, and that's not complete. So the tyres ("tires", for my US colleagues) have barely been kicked on them. Because we're using new language constructs, the classes could not be leveraged currently, although there is nothing done that could not be reverse engineered to work with existing LotusScript. And although the unit tests include creating large Collections, the primary focus at this point is functionality, not performance with large Collections / Maps. All of this points to the fact that as much as developers might be excited by this work, it's far too early for it to be made available and LotusScript developers' use cases might not align with ours.

But it'e encouraging that our architecture solves real business problems.

And I haven't even mentioned the synchronicity of Andre mentioning that `Dir()` is not recursive. But that's a completely different topic.
