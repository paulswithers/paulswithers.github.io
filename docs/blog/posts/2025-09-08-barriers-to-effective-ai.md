---
slug: effective-ai-1
date: 2025-09-08
categories: 
    - AI
tags:
    - AI
    - Editorial
    - GitHub Copilot
comments: true
---
# Effective AI Usage Part One

In [my last blog post](./2025-08-16-ai-lessons.md) I talked about some lessons I've learned from using AI. I talked about a follow-up article talking about AI use at a higher level. Recent experience has reinforced my thinking on this. In this blog post we're going to focus on what AI is, the initial interaction, and training.

<!-- more -->

## What Is AI?

First off, "AI" is a misnomer. This isn't the first time that I've talked about the importance of [understanding the processes](./2024/07/22/research/#understanding) behind how technology works. It's the same with AI, we have multiple aspects in play, and it's evolving. We have the **interface**, but we need to understand what it allows *and doesn't allow* access to.

First off, there's the **LLM** (Large Language Model). GitHub Copilot offers a limited number of LLMs to choose from, the most common ones I've used are GPT-4.1 and Claude Sonnet 3.5. Later in the year Copilot will allow BYOM - Bring Your Own Model, but that's not available yet. And different models are suited for different things. Alternative extensions like [Continue](https://docs.continue.dev/getting-started/overview) and other IDEs allow you to integrate with different LLMs, local or cloud.

Local LLMs depend on suitable hardware, usually including a GPU. This isn't something your average end user is going to have access to, although ARM-based Macs and Windows laptops with a very recent Intel chip have started to include GPUs. However, the LLM and something like Ollama or LM Studio need to be downloaded locally. And the more powerful the large language model, the bigger it is. Specific LLMs are good for specific tasks, e.g. coding. So one LLM may not even be enough.

There have been attempts to distribute the work of LLMs, for example clustering hardware to create an AI hub. The problem here is the performance of communication amongst the cluster.

Then there's **RAG**, Retrieval Augmented Generation, which can add additional specialist information into the mix. RAG uses a **vector database**, which takes inputs and "vectorises" the content using an **embedding model**. The choice of embedding model will affect how the data is stored, but the same embedding model is needed for both loading and reading. When retrieving content, the LLM takes the input and *retrieves* a subset of documents from the vector database based on a similarity search. The number of documents retrieved is a variable passed to the retriever - the higher the number of documents, the more potential matches but also the more contextual information the LLM needs to take into account. And depending on what's in the vector database, too much may include a lot of useful information.

There is also **CAG**, Cache Augmented Generation, which can be used to avoid calling the LLM by identifying questions already asked and answers already available. However, it depends on the quality of those answers.

Then there is **MCP** ([Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro)), which also has two parts: an **MCP Client**, which the interface needs, otherwise you can't use MCP in that interface; and an **MCP Server** which can provide prompts, tools, and resources. These can be included in the process to bring additional specific information into the mix.

Then there's are **AI agents**, which can add automation into the process. Copilot can run in agent mode, performing iterative code updates.

There are also IDE integrations, like how Copilot can read code in editors and files, run terminal commands and read terminal responses, and update code in the editors. These could be considered tools.

It's important to understand these moving parts, in order to understand where effective use of AI needs to be optimised and where it can go wrong. But there's another moving part involved: **humans**. Unfortunately humans are involved in every parts of the process...as well as another part I've omitted to mention - *using AI*. And that's where I'll start.

## We've Been Here Before Part One

My most recent usage of AI did not go well. What I was trying to ask may actually be impossible, but it's not a priority to confirm or deny at this point. As I covered in my last blog post, being specific is key. And I thought I had been specific enough. The ask was for configuration that:

1. Created a new file when the program started.
2. Rolled over when file size exceeded.
3. Retained old logs.

But there are two major problems with this. There is a difference in English between "when" and "every time" or "whenever". And when does the current log become old? In precise English terms, what AI did was what I asked for - create a new file *only the first time* the program started, and then retaining foo_1.log and foo_2.log but not the current foo.log file. The problem was what I asked for and what I wanted were not the same.

Because whether you accept it or not, the English I used was imprecise and I didn't include sufficient examples to illustrate my requirements.

We've been here before.

Remember the days of IT off-shoring, with business analysts creating spec for cheaper IT "code monkeys" to do the work? AI is just an extension of IT off-shoring, and the same problem is rife - poor communication skills and lack of clarity. It results in a solution that does what's asked for and no more, even if that results in something that makes no sense.

I've seen the same in enhancement request systems, where an empty text box is given without even a hint at the amount of content required. Sometimes you get a one-liner, sometimes something that's so imprecise it becomes a Schrödinger's requirement - simultaneously shipped and not shipped, because both sides can argue what it *could* mean and no one knows what it *should* mean!

South Park's recent episode, season 27 episode 3 "Sickofancy", wittily riffs on this idea of ChatGPT, poorly thought out requirements, and poor review of the answers. It's a good commentary on the use of AI by those not qualified to use it *effectively*.

## We've Been Here Before Part Two

If you have something more than one-shot AI, there's a whole process in the middle where a conversation takes place between the human and the LLM. This constitutes a whole blog post on its own, so I'll come back to it.

But the RAG depends on the quality of the data that goes into it. And we've been here before too, most notably for AI in the era of machine learning which came to prominence around the turn of the century. It didn't really take off in enterprises, often failing in pilot stages, for a simple reason: businesses were not willing to invest sufficient time to train ML systems on data. I've also seen the same with OCR tools in the pre-AI era. It takes time to find good-quality samples, train the systems effectively, avoid issues caused because of bad data. And it's time that needs to be spent *in addition to* the day job.

And the initial training isn't the end of the story. There needs to be ongoing training. That still seems to be a nascent aspect of AI, training *beyond* the initial conversation to ensure better and quicker results *next time*. Again, this needs to be done *in addition* to the day job - and with no immediate benefit: the benefit comes from planning for the future. And fail to plan, then plan to fail. But whether it's hubris or laziness, human nature so often prefers procrastination.

## Why Bother With RAG

AI has become pervasive in our personal lives, with NPUs on our phones helping avoid typing, learn about the world around us, or modify photos we take (for improved quality or humorous outcomes). The NPUs or Neural Processing Units are the chips that perform the AI functions, which seem to be quite lightweight. But we never use RAG in our personal lives, and the fact is we don't really need to. The answers to the personal questions we have are typically in the public domain.

That's typically not the case in business AI usage.

There are two approaches. One is MCP to make API calls to systems to include a subset of data gathered via traditional means. That may work where the information is readily available from a database with a simple query. But where you need to review a broad corpus of data or search via vectorised similarities, the better option is RAG. And that's not necessarily just your internal data. Manuals for systems that have been bought may not be publicly available and may not have been indexed by the LLM in use. In-app AI may leverage RAG to contribute specific content to their AI integrations.

Of course it's more true in the context of open source software. And that raises the question of whether AI will make developing in the open more attractive, because starting from closed source may mean you're already on the back foot in terms of customer productivity.

## Summary

There are a lot of moving parts to AI and while generic and cloud offerings will work for simple tasks and many personal requirements, enterprise AI is a much more complicated challenge. So understanding the moving parts is even more important.

The ability to optimise the various parts of AI offered to the business will be a major requirement of IT departments and third parties. Proper understanding by both sales executives and procurement is crucial to moving beyond the sale and basic POC to implementation.

But even then, **AI-fu** has a major role to play.
