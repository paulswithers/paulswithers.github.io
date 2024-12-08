---
slug: troubleshooting-support
date: 
  created: 2019-10-28
category: Support
tags: 
  - Support
  - Editorial
comments: true
---
# Thoughts on Troubleshooting Support

Over the years I've spent a lot of time supporting applications. I would like to think I'm pretty effective at it. So I thought it was the right time to share my approaches. The key is a systematic, logical approach to identify the cause - or causes.

<!-- more -->

## Information Gathering

The key to solving any problem, IT or other, is information and successfully sifting the relevant and irrelevant information. They say a picture paints a thousand words, and a good screenshot certainly does that:

- It cuts through incorrect or misleading use of terminology.
- It will typically identify which application and where.
- It will hopefully identify the document being edited at the time, which may be critical.
- If there's an error message displayed to the user, it gives you that information.
- Depending on the application, the screenshot may also give information of the specific user profile and permissions in play at the time. Although not typically relevant, on occasion it can be.

It is a snapshot in time though, a snapshot after the error or problem has occurred. So it doesn't necessarily identify what happened immediately prior to the screenshot. Hopefully with a good knowledge of the application the support technician will be able to work that out, but obviously that's also critical.

Where a screenshot is not available, clear and full details of what was done, what was the expected outcome and what was the actual outcome. Understanding the technical ability of the person who reported the issue will have an impact. Assumptions will have to be made, and symptoms - all symptoms - teased out. If you know the person you're dealing with, that will colour what questions are asked, in which way and whether there is going to need to be additional clarification.

Some of that clarification may need to be asking for logs. But this comes back to filtering relevant and irrelevant information. You need to be able to answer the following questions, or additional logs just means additional misleading noise:

- What should you be looking for in the logs?
- What is normal processing in the logs?
- Can you recognise and filter out irrelevant error messages?
- Is anything relevant even being written to the logs?

Context is also key

- Is it working for someone else, on a different PC, a different site?
- Has it worked before and when did it stop working?
- Has the problem previously been reported?
- Was scheduled maintenance occurring at the time?

### Time Travelling

If it's a workflow system, when it comes to looking at the data, you need to bear in mind what the status of the data was at the time the problem occurred, and how it's changed since.

With Domino, the Seq Num property of fields helps identify this.

With local replicas or applications on multiple servers, you also need to think about what the status of the data was on each server at the relevant time.

Thinking in this "fourth dimensional" way takes some lateral thinking, but can sometimes be key and is always crucial to being certain about what happened when.

### Simple Solutions

From all of this, it may be immediately obvious what the cause and resolution is. If there is an error message with a stack trace, that can sometimes solve the support call. It may be that there is a misalignment between the expected outcome and the actual outcome. By this, I mean that the user is expecting a certain outcome but, because of certain parameters or environment circumstances, the code is resulting in a different outcome, but one which is correct for normal processing.

## Reproducing

If it's feasible and if the relevant information has been provided, it may be possible to reproduce the problem. Reproducing the issue may identify the cause, but at the very least will allow more detailed troubleshooting.

But it's worth bearing in mind what is different between the attempt to reproduce and the original issue. There may be environmental or data differences, or you may not have enough detail to reproduce exactly. There is always going to be one particular difference, and that is timing. Trying to reproduce it at another time may not make a difference, but it's worth bearing in mind.

## What's Changed?

But, if not, those questions will have fed into a key part of problem solving: what has changed? Because for a problem to have occurred, something has changed.

- You may be installing something new
- It may be the **application's code** that has changed and this changed code has introduced an issue.
- There could have been configuration changes in the **user permissions**.
- A different **environment**, **platform** or **hardware** can be the relevant "what's changed".
- The most common difference is **data-related** or **specific parameters** that were passed.

## Forming Hypotheses

If it's not a simple solution, then based upon the information available, an analysis of the data, identifying what's changed, you need to come up with hypotheses. Note, I'm specifically using the plural here, because you should always come up with multiple hypotheses. One is rarely enough if you've had to get this far.

There is a process I always take here, almost subconsciously. For each hypothesis:

- How can I prove the hypothesis?
- How can I _disprove_ the hypothesis? Ruling certain hypotheses out is often as useful as proving it.
- If a hypothesis is right, what other symptoms would I expect to see?
- And what symptoms would you _not_ expect to see?

If you're thinking about what other symptoms you should see and should not see, you're identifying definitive ways to prove and disprove the hypothesis. If you can't come up with other expected symptoms, you're not in a position to 100% confirm the hypothesis. If you can anticipate symptoms, you're also showing you understand what should or shouldn't happen. If you're just saying "Maybe it's X, maybe it's Y, maybe it's Z", throwing possible causes around without a methodology for proving or disproving them, you're basically hoping you get lucky.

## Prioritising Hypotheses

So now you have a set of hypotheses, but it's not yet time to dive into them. You need to think about two thing:

- The probability of each.
- The ease of proving or disproving.

This is key to the order you attack them. There may be some that have low probability but which you can quickly disprove. It may be worth taking a few minutes to try that. Because if you fail to disprove it, even though it's less probable, you may have found the cause quicker. The most probable may be hard to prove or disprove, and you may need a lot more information to do so. And if you wait for that information and the hypothesis is disproved, things may have happened to the data that make it harder to prove or disprove other hypotheses.

## Identifying the Right Cause...Or Causes!

This is why gathering enough information and thinking about symptoms is crucial. If there were symptoms you expect that were not reported, it may be worth querying to see if those symptoms occurred but were not identified or not reported.

On the other hand, a hypothesis may not answer all the symptoms reported. It's possible that the other symptoms reported were incorrectly identified as relevant by the user. But it may be that you haven't identified the right cause or all the causes. I can be somewhat relentless if my hypothesis doesn't fit all symptoms, but typically I've missed something, either in my understanding or in identifying the true cause.

## Fixing The Problem

Similarly, fixing the problem also needs some careful thinking. There could be previously unreported or incorrectly reported instances of the same problem. A certain combination of clean data and clearer reporting may explain a problem that you've failed to fully diagnose previously.

But there may also be knock-on impacts of the problem, impacts you need to address. And there may be specific actions that need to be taken to ensure no additional knock-on issues arise.

## Summary

A nice resolution to a support issue is one that has precise reporting of symptoms, symptoms that neatly fit a hypothesis or hypotheses, that give a definitive cause or causes. The resolution should clean up the data, ensure no knock-on issues, and prevent any additional instances of the problem.