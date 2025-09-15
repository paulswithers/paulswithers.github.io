---
slug: effective-ai-2
date: 2025-09-15
categories: 
    - AI
tags:
    - AI
    - Editorial
    - GitHub Copilot
comments: true
---
# Effective AI Usage Part Two

In [my last blog post](./2025-09-08-effective-ai-1.md) I talked about the many aspects of modern AI and the importance of understanding them all. But even more important than this is what I am terming "ai-fu". So what is ai-fu?

<!-- more -->

## AI Fu

When I started working in IT, the internet was in a nascent form. Database searches were full text with fuzzy matches. Google was not even the predominant search engine. Over the first quarter of this century, the ability to refine a problem into the *right* search criteria has been a differentiator - [google-fu](https://en.wiktionary.org/wiki/Google-fu). Those who have been able to employ good google-fu have solved problems more quickly than those who could not. I often see questions on chat forums that I can easily answer with an online search - if the question is accurately reflecting the requirements.

The trend just starting is what can be called ai-fu, expertise in interacting with AI interfaces to retrieve accurate outcomes effectively.

Google-fu had some impact. But ai-fu will become a major differentiator, because its transformative power is so much greater. Those who can master effective use of AI will create more, better, faster. Those who can't will be stuck in the slow lane.

## Hypotheses

Using AI is not like using your coffee maker or TV: there's not a manual of fixed functions with clearly-defined options, and there will never be. If you use AI to create "smart buttons", you will not get the most out of AI, and it will be like taking a bazooka to a knife-fight (to use an analogy a friend once used for something else).

So using AI needs to be approached with the same mindset I discussed in my blog post on [troubleshooting](./2019-10-28-troubleshooting-support.md). Typically you're asking AI because you don't know the answer. But you need to approach it with possible hypotheses, and think about how your can test and verify the answers you receive. I'm reminded of when I suspected a use of Apache HTTP Client was not sending as UTF-8: rather than asking specifically about UTF-8, I asked what the default character set it would send would be. This verified my hypothesis without asking directly about UTF-8 and also gave me additional useful information. With that additional information, I could quickly verify with internet searches, removing the need for assumptions.

You also need to gather the right information beforehand and provide the right information to the AI. Garbage in, garbage out. And if you don't provide important pertinent information, AI may give an answer that is correct based on the inputs but incorrect based on the actual problem being solved. I'm not talking at this point about *how* the question is being asked, but *what* information is provided.

Based on what I see from some online chat platforms, there are even some IT people whose ability to provide pertinent information is lacking. IT people are often on the receiving end of support queries where pertinent information is crucial to effective processing. So they should be more capable of identifying and providing pertinent information than others. However, this requires approaching AI use with deliberate thinking.

One should not assume that will happen.

## Valuable Information

How do we know what we know?

It's a difficult question to answer, and one most people rarely ask themselves. But the simple fact is that we pick up valuable information from everywhere. And more importantly from lots of places that AI does not have access to. We may look at documents outside the IDE where we're using AI. Or we may perform internet searches. Or we may be using information from our past experiences or face-to-face discussions with colleagues. Or the *right* answer may vary depending on external factors or even change depending on the time of year. We identify chunks of that information as important almost subconsciously, using them in our decision-making process.

But if we want AI to help in that decision-making process, it also needs to be aware of that same information.

Including AI in the planning phase is one way to maximise information AI is aware of. But this only works if the AI user interface supports conversational interactions with the LLM. Certain AI interfaces also allow mechanisms to increase the contextual information automatically - or explicitly - included in an AI. You can get very different information depending on what contextual information is provided. And interfaces with GitHub Copilot in Visual Studio Code allow you to contribute prompt files that can include additional relevant information. Prompt files can also request that AI perform certain roles, which can change the kind of response gained. RAG can allow the AI to pull in additional pertinent information, but you need to take into consideration whether or not the particular AI interface is re-using previously collected information or using new information from RAG. Agentic processes can allow the AI interface to pull in additional relevant resources. And if you're deep into AI, different LLMs have different skills.

But this all requires an AI implementation that empowers you to control and maximise the inputs, and not all AI implementations do.

Where they do, you need to know what information has been taken into account when answering your questions. Or you need to be able to *anticipate* what information *may have been used*. Or you need to **confirm** what information has been used.

Super-powered ai-fu users will choose an AI implementation that empowers them and will understand what information it's using to ensure they can understand what AI has used to provide its responses.

## Awareness of Content

If the last decade has proven anything, it is that what you ask and how you ask it can drastically alter the outcomes received. Politicians have increasingly used language, provided a subset of facts, or repeated incorrect statements all for their own benefit. Interviewers have done the same as have mainstream media. That been the case in mainstream media news outlets for some time, but it has been increased by lower sales, cost-cutting, and increasing focus on clicks. Click-baiting is pervasive and headlines are deliberately worded to be sensational, appeal to specific demographics, and entice the reader with deliberately incomplete information.

There are already horror stories about how specific inputs have skewed answers from AI, whether it's encouraging a specific political viewpoint or [reinforcing human biases](https://www.forbes.com/councils/forbeshumanresourcescouncil/2025/07/15/ai-bias-in-hiring-is-an-hr-problem-not-a-tech-issue/) reflected in the training material. The quality of inputs is key to the quality of outcomes. "Why" is always an important question to ask, in order to get the best from AI.

Note, this article is focusing on *effective* use of AI, not *ethical* use of AI. Anyone who has been involved in school college, or university debating societies know that at - just like any source of information - can be used to create misleading narratives.

But the good news is that it can also be used to challenge narratives, get alternative viewpoints, and get additional information to help validate the basis of opinions. Where you are asking for recommendations, asking about pros and cons can provide more information to help you make a better decision. But it's important to be aware that what you want is the best decision *for you*, which might be very different to the best decision *in general*. Again, this comes back to providing pertinent information.

Where you are asking for factual answers, it's important to identify how to verify them. If you choose to take what you receive as gospel, you deserve whatever bad outcomes you inevitably will receive! You're the one paid to make the right decisions not AI.

## Language Skills

Underpinning all of this is the importance of good language skills. Human nature is to be careless with language, particularly when rushed and especially when using your first language. Among certain groups, colloquialisms and acronyms are thrown around without thought.

When interacting with AI, we **must** be aware of ambiguities in our language, as I demonstrated in my last blog post. We need clarity in our requests to avoid muddled thoughts from AI. There are a host of presentations and YouTube videos about quality of phrasing, using numbering, reducing the number of things you're asking in a single request, being specific about the kind of response you want.

But that's only part of the job.

When you receive the response, you need good comprehension skills. Responses are often detailed, so the ability to quickly comprehend the response is important. Core to this is being able to quickly identify if there has been a misunderstanding. A human colleague will tell you if they haven't fully understood or if there's some ambiguity in what you were asking. AI does not.

Moreover, AI will only tell you what you ask for. Those with good ai-fu will identify where additional information is needed. They will be able to identify what's missing in a response and ask follow-up questions. This requires an  awareness of your actual requirements, to ensure **all** have been met and, if not, why not.

Another key factor to effective AI usage here is *how* you communicate. For example, my typing skills are very good. I can type fast enough and accurate enough to be very productive when conversing with AI through typed interfaces. Others may not be, and an interface that supports speech may be required for optimal effectiveness (regardless of transcription accuracy). It's a factor that needs to be borne in mind.

## When Response Go Wrong

AI will inevitably provide an incorrect answer. There are two key aspects for ai-fu here. First is providing effective feedback to ensure correct information. Saying "that's wrong" will rarely get a better answer. And at this point it comes to employing everything I've already covered:

- reviewing what you asked to identify failings.
- reviewing the response to identify misunderstandings or confusion.
- identifying any pertinent information omitted first time round.
- reconciling what you asked for vs what you wanted.
- identifying incorrect assumptions.
- identify where unclear but crucial information was just ignored.
- knowing how to check the information received to ensure it's accurate.

But equally inevitably, there will be occasions when AI is incapable of giving the right answer - because you're trying to get it to do something that's not possible or is not a recommended approach. The key here is quickly identifying when what you're asking for is impossible or not the right approach. And if there are alternative approaches, finding them and identifying the *right* approach.

There are also some areas where it's not likely to have the right answer. And that is another blog post of its own. The key is anticipating where it is not likely to be useful, and either knowing not to use it or approaching it with a high degree of scepticism.

There are some mechanisms with certain AI interfaces where you can improve the outcomes next time. GitHub Copilot in VS Code allows you to change what AI can see or add prompt files to increase the corpus of information it uses. Then there are more complex training improvement approaches. If you're using a RAG, you may need to improve the quality of the information, change chunking, choose a different embedding model. You may need to change the LLM in use.

This takes ai-fu to a whole new level.

If you can.

AI implementations in some AI systems and certain IT departments will place barriers between the skilled AI user and effective use. Dumb down AI interactions and you get dumber outcomes. Companies will do this, and they will lose their best talent or you'll get "shadow AI" - skilled individuals using AI outside the constraints placed upon them by systems or IT, to get the job done.

## Summary

As I stated at the start, the difference between those with good google-fu and those with poor google-fu has not had a huge impact on the effectiveness of those individuals. That skill is a minor part of the difference between effective and ineffective employees.

But the potential for AI to speed up work is much more significant. Good ai-fu will maximise both the speed and quality of outcomes, optimised by effective cross-checking. The transformative power will vary depending on what you're trying to use it for. But I'm already seeing big productivity boosts in my daily development work, depending on language and framework choices. And AI is a key tool for me in accelerating my research. AI is often a first-choice go-to for me instead of Google. That does not mean it always gives me the right answer. But it's definitely having a transformative effect on my productivity that I will easily be able to demonstrate when appraisals come round.

That primarily comes from approaching AI with a good awareness of language, good comprehension skills, a healthy awareness that both parties can be wrong, and a desire to understand why AI might be giving the answers it gives. I'm using all the skills in this blog post, as often as possible, and always looking to improve my ai-fu.