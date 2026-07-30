---
slug: plato-paradox
date: 2026-07-30
categories: 
    - AI
tags:
    - AI
    - Editorial
comments: true
---
# The Plato Paradox and AI

## Plato Paradox

I didn't study Computer Science at university. Instead I studied Classics - Latin and Greek. This meant translating texts from a variety of authors and genres, one of which was Plato.

<!-- more -->

With many authors and genres, the biggest challenge is the vocabulary. There are a wide range of words, sometimes "hapax legomena" - words that occur only once in the whole corpus of Greek or Latin. Even if they exist elsewhere, with the texts covering centuries and a breadth of topics, individual words can have a broad range of meanings. Compare how some workds have changed their meaning just within a generation because of popular usage, and then extrapolate that to authors like Dickens (19th century), Shakespeare (16th and 17th centuries), or even Chaucer (14th century).

But with Plato, the vocabulary was mostly basic, because the dialogues covered concepts like justice or love. So it's easy to translate, right?

Wrong!

What you hit is something I call the Plato Paradox, although it's more associated to the "hero" of the Platonic dialogues, Socrates. But that doesn't give an alliterative impact, so we'll stick with Plato Paradox.

Because the problem is not the vocabulary, it's the syntax, and the meaning behind the arguments that the syntax generates. To demonstrate, I'll quote a bit from the [Project Gutenberg translation](https://www.gutenberg.org/files/1600/1600-h/1600-h.htm).

> Is not a brother to be regarded essentially as a brother of something?
> Certainly, [Agathon] replied.
> That is, of a brother or sister.
> Yes, he said.
> And now, said Socrates, I will ask about Love:—Is Love of something or of nothing?
> Of something, surely, he replied.
> Keep in mind what this is, and tell me what I want to know—whether Love desires that of which love is.
> Yes, surely.
> And does he possess, or does he not possess, that which he loves and desires?
> Probably not, I should say.
> Nay, replied Socrates, I would have you consider whether 'necessarily' is not rather the word. The inference that he who desires something is in want of something, and that he who desires nothing is in want of nothing, is in my judgment, Agathon, absolutely and necessarily true. What do you think?

The difficulty comes from the fact that in order to translate it, you need to be able to understand what it means. But in order to understand what it means, you need to be able to translate it.

This is the Plato Paradox.

## IT Challenges and AI

For me, there's a similar challenge with some IT concepts. Yes, there are IETF and RFC specifications for the concepts. But sometimes, in order to work out how you would code a system that implements these concepts, you really need to see them in action. But in order to see them in action, you need code that implements the concept.

The most recent pre-AI example where I had this was [MCP](https://modelcontextprotocol.io/). Thankfully I was using an SDK. But it still required some extensive reading of documentation, blog posts, articles etc to get the level of understanding I needed to code a system. All-in-all, it took me a couple of weeks to build what I wanted to.

More recently I was looking at another concept covered by an RFC. The specifics are not important. But the approach was significantly different and, although still requiring deep concentration, it was much more satisfying.

### Step One

Step one was in-depth discussion with AI. The benefit over reading RFCs here is that you can ask a single question that brings together information from multiple sections of the RFC. And you can then drill down to a specific section very quickly. No time-consuming reading front-to-back, potentially multiple times, making exhaustive notes to stop overwhelming short-term memory.

And if anything is unclear, you don't have a fixed spec where the onus is on you to work out what it means. Instead you can ask questions for clarification.

Moreover, a spec covers a specific set of scenarios, only some of which may be relevant to your use case. And there may be other impacts relevant for your infrastructure, like proxy servers, that the spec glosses over or omits. This used to require deep research trying to find someone who had blogged about the specific combination of circumstances, and probably trying to extract other circumstances that are not relevant to you. AI certainly makes this a lot easier.

### Step Two

Step two was creating a proof of concept to help see what steps are required and how they are coded in a specific language. This may require finding a specific third-party libraries to use. Historically, that's a lot of legwork, building the specification and the code at the same time, often adapting the architecture as you understand more things about the concepts.

In the era of AI, that plan can be built with a model, ensuring it covers sufficient functionality for the architecture it will need to go into. The model understands the concepts involved, understands the technologies in use, and so can build an architecture that covers all relevant aspects of the RFC from the start.

That plan can be used to let the appropriate model or models to build the proof of concept. And it's a lot quicker to get to working code, which you can then drill into to understand the flows involved.

### Result

The whole process took just a few days. That included over half a day spent on in-depth planning across multiple models. I also went through the code personally rather than asking AI to write the documentation for me. Of course there were places where I asked the agent to write detailed comments for a function, so it was not necessarily completely manual. And I also used AI to generate sequence diagrams to help. But I made sure I understood everything and manually created the documentation, so that it *should* be clear enough for others.

Reducing the time and the mental effort has another positive side-effect. The shorter the time and the fresher the mind, the fewer mistakes result. It also means the code is cleaner, without multiple failed attempts with changes across various files causing unnecessary complexity.

And obviously this means much greater productivity, not only for the proof-of-concept but for later implementations. And if you need a different coding language or third-party dependency, AI will have plenty of content from which to use AI to "translate" the code.