---
slug: effective-ai-3
date: 2025-10-05
categories: 
    - AI
tags:
    - AI
    - Editorial
    - GitHub Copilot
comments: true
---
# Effective AI Usage - Understanding Brains

I've talked about the (current) [moving parts of AI](./2025-08-16-ai-lessons.md) and [AI-fu](./2025-09-15-barriers-to-effective-ai-2.md). But a fundamental aspect of AI-fu is being aware of how we think and how that's different to how LLMs "think". It's probably true that most people are not consciously aware of how they think or aware of how colleagues thinking works differently. So it's well worth raising that topic, because it's crucial to the quality of results.

<!-- more -->

## AI Program vs LLM

I will use the term "AI program" quite a bit in this blog post. This is because, as we covered in the first blog post, the AI the "thinking" is done in multiple places:

- interpretation and natural language processing by the LLM
- traditional database searching
- chunking of large data when populating a vector store
- choice of metadata put into the vector store
- ANN (approximate nearest neighbour) or hybrid search in a vector store
- specifying which tools and context stores are available to the AI program
- coded steps in tools

Of course the LLM is just one part of the process. The AI program integrates an LLM with various other pieces of functionality, as well as a system prompt and user prompt.

## Expertise

If Ferrari have a problem with their formula one car, they don't take it to the local garage. But if you need an MOT for a moderately-priced pre-owned car, you probably don't take it to a specialist for that make and model. The level of knowledge comes from two main places - the model (LLM) and context (RAG or traditional search). It's best done in the model, but few will have the skills or ability to create their own model. Context is limited by the quality of the search and the size of the context window.

The quality of the search depends on what you're looking for. Humans may type a full question into a search engine or refine it to specific keywords. Sometimes those will be sufficient (e.g. what oil to use for a specific car make and model - "oil" + make + model). Sometimes you'll need to try multiple attempts, reviewing the results and trying again. A traditional database search will give you answers for the first, assuming the database holds the information. A vector search will be better for the second.

The additional contextual information needs to be prepared beforehand, and the LLM needs to be pointed to the right store before the question is asked. A business will need multiple such stores, and which one (if any) is needed will depend on what the user wants to know or do.

As a human being we have access to many areas of expertise and we choose the right "datastore" to use without thinking. Sometimes it's driven by what we're doing at the time. A mechanic will point their mind to a specific datastore of knowledge at work, and a completely different datastore of knowledge when cooking at home. This may seem obvious, and this is something that software developers can do when providing specific AI systems: if the legal department are creating legal agreements, it's not rocket science to point it to a RAG of existing agreements. But sometimes it's harder to anticipate what contextual information needs providing and how it's best to prepare it.

But other times it's less obvious which datastore or datastores we're going to need. As human beings we *work it out*. But how? Are the rules defined? Because those rules *need* to be defined for the AI program to make the right choice. Because if the right RAG store is not provided, it will not be used. And if too many RAG stores are provided, results that fit the search criteria but are - to a human being - totally irrelevant will be used. The result will be hallucination, because the LLM is designed to just use what context is provided *without question*.

## Tools

At the other end of the process are **tools**. The use of tools is similar to datastores: we have access to a large number of tools, both physical (e.g. calculators) and conceptual (e.g. mental arithmetic skills). And as with datastores of knowledge, we have access to all of them all the time, and we *just know* which to use. But an AI program will use tools based on the descriptions provided. So, providing too many tools with imprecise descriptions is more dangerous than providing not enough. And the order of tools may also impact which tool gets used.

An example was an AI program I built following a Python course. It provided a tool for simple arithmetic calculations, with a description to use them if the result of a previous step was "Calculate...". However, the LLM provided an observation "Calculate Jupiter + Mars", which caused the program to error. As a human being we have learned that we only calculate numeric values, but the description didn't specify that, so an error occurred because the tool was used at the wrong step in the process.

## Context Window

The obvious solution for this is to put the human in control. Let the human decide what gets passed to the LLM, make the human manually use the right tool. But the benefits of using AI in this way are minimal, e.g. summarising a large document, as long as the size doesn't exceed the context window. One-shot AI use has the additional limitation that it is only aware of what's currently being asked, it doesn't have memory. So you have to constantly summarise the history or pass that large document each time.

And this is where things can go wrong very quickly. Because even though an LLM is designed to have a large pre-loaded datastore, it is limited on what content can be passed in a single request. And if the amount of content being passed in the request exceeds the context window, it will just get ignored - typically without informing the user that trimming has occurred.

Furthermore, different LLMs can support different context window sizes. Obviously cloud models are designed to scale to a greater context window than local models, but the bigger the context window, the more powerful the server needs to be to run it. And then there's also the interface to the context window, which may further refine the size of the context it passes to the LLM. And context is typically in tokens, which varies depending on the tokenization process. So it's hard to map to a number of characters. And anyone who deals with text at a platform level also knows single-byte and multi-byte character sets have an impact here as well.

As humans we also have a limited context window and it will also vary from person to person. But our action when the context window is exceeded is more extreme: we will tell the person to restrict what they're asking for. Or if they're asking about larger documents we don't have a ready summary of, we will ask them to provide the summary. Few if any will just ignore excessive content. So it's not an approach we're used to, and it's one we need to be aware of. (By the way, I've not tried asking the LLM to tell me if I'm providing too much context, but I wouldn't be hopeful that it would work, because the trimming would occur before the LLM assesses the contextual data.)

## Conversational AI

So the standard AI program implements conversational AI: it "remembers" and passes the history of the conversation with each request *for you*. Of course, after a certain amount of content, the conversation needs summarizing, in order to not exceed the context window or give the LLM less text to trawl through.

As human beings we're used to conversations, but we also subconsciously deal with changing the subject of a conversation. We can typically tell when someone has moved onto a new subject and wants us to ignore what was said previously. Sometimes confusions appear, and on occasion we may start to suspect the conversation has switched topics, and clarify. But in human interactions, we're used to switching topics in the same conversation or at best we use micro-cues, saying things like "on a different topic...", or "changing the subject...".

However, an LLM needs more explicit conversational splitting in order to know when to ignore past conversational history. It's possible that as AI evolves, models may become more aware of change of topic. But for now, the onus is on the human to create new conversations whenever the topic changes.

## The Customer Is Always Right

One of the biggest problems with LLMs is that its starting point is that the customer - in this case, the user - is always right. That means it will try to do what it's asked to do. I mentioned in part one that this has been encountered before, with outsourcing. The problem is that the customer is *never* always right. Except at very low levels in business, employees are expected to be smarter. Employees are paid more so that the instructions they are given are briefer and not explicitly specific. Experts are paid because they know better, they can do additional research and think around a problem, they can provide better alternatives, and a good consultant will tell the customer when they're asking for something that's just not right.

But that's not how LLMs work, and I don't expect that to be achievable any time soon. With LLMs the onus is on the person to provide all suitable information, to ask the questions that are hidden from end users.

The other problem is that the default assumption from an LLM is that the human is asking for something that's possible. That may not be the case. The LLM needs to be advised if that's a possibility. It also assumes the information it has is correct. If you wish it to verify the information, you need to explicitly ask that. Some humans are capable of pre-assessing the likelihood of a correct answer, or the likelihood of needing to verify information, based on the topic or the source of the information. LLMs do not currently have that ability, and we need to bear that in mind.

## Iterative Approaches

So far we've only been dealing with single-response interactions. But particularly in the case of coding, we often use AI to achieve a specific outcome in code, which requires a cycle of writing code, checking compilation, fixing, checking compilation, and repeating until it works. It's very easy to assume approaches based on the level of knowledge. But in my experience, what we get is the approach of a junior developer with the knowledge of a senior developer: code is written, checked if it works, then modified, checked if it works, modified again etc. But what if problems are introduced during modification, what if there were multiple options and the wrong one was chosen? From my use of GitHub Copilot, it's not been good at going back and trying a different approach. It's also not great at recovering when code gets totally broken.

## Summary

Consumers of AI programs need to be aware that they will "think" in a certain way. LLMs will assume high quality of the information and requests it is provided with. If history is available, conversations need carefully separating to ensure only relevant information is used. AI programs can accumulate additional contextual information, but it's important to only include datastores and other contextual information that is relevant to the query in question. And if there is insufficient information available, that needs to be carefully managed. AI programs can leverage tools to perform additional functions, but again you will cause problems if there are too many tools and poor quality descriptions of when they can or should be used. These are problems humans have learned to adapt to. Maybe future generations of LLMs will improve on these, but today it's down to the user to be aware of these limitations and adapt accordingly.