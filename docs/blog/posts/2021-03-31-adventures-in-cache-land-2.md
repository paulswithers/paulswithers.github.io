---
slug: adventures-in-cache-land-2
date: 2021-03-31
categories:
  - Domino
tags: 
  - Domino
  - LotusScript
comments: true
---
# Adventures in CacheLand 2

In my [last blog post](./2021-03-24-adventures-in-cache-land-1.md) I talked about challenges we had to overcome as a team with regard to caching of constants. But a bigger challenge we hit was caching of design elements.

Part of the solution we built required copying design elements from one database to another. Part of the beauty of Domino is that everything is a Note - including design elements. Design elements are just Notes with a special flag. So just as you can copy a document from one database to another by getting a handle on the note, you can also copy a design element from one database to another by getting a handle on the design note. The API is exactly the same - `Call NotesDocument.copyToDatabase(targetDb)`.

<!-- more -->

And that all worked fine for a start. But then we got the error message that someone else had edited the document. We were able to pinpoint the specific document throwing the error to an agent. It was being edited - but by the developer running the agent. And we were able to reproduce the error regularly - all the developer in question had to do was edit the agent.

Our hypothesis was that the agent design element was somehow being cached. So the cached version was being retrieved, its underlying NotesDocument had been modified (by the developer running the agent!), and Notes was identifying a conflict and so throwing an error. With a bit of googling we found that some design elements like Script Libraries were cached (http://www.redbooks.ibm.com/redbooks/pdfs/sg245602.pdf, p95). But there was no reference here to agents. The redbook was written quite some time ago, in 2000 - and there is still some very advanced learning in there that should not be lost. So maybe agents are also cached now?

Thankfully, when you are working with people who have been closely involved in the product for a very long time, there is a great deal of knowledge. One of our team (not me!) remembered that Notes was changed to cache agents back around the Notes 6.5 timeframe - the key bit of information required for the hypothesis to be feasible.

So how to clear the cache? We tried various things. The solution may seem a radical one, but actually very simple. UNIDs are set automatically when you create a note, but they're actually read/write. So we updated the UNID for agents and script libraries at the start of the process...and then copy it. Immediately the error stopped occurring, and the code we needed to run worked consistently.