---
slug: reproducers
date: 
  created: 2022-07-02
categories:
  - Support
tags: 
  - Support
  - Testing
  - Java
  - LotusScript
  - Domino
  - Vert.x
  - Voltscript
comments: true
---
# The Importance of Reproducers

So you think you've found a bug. What next? Create a support ticket, right? Wrong!

<!-- more -->

First off, let's point out something critical in that first line - "you **_think_** you've found a bug". You may be a consumer for the code you think you've found a bug in. But you're also a _committer_ to other code. How many times has someone raised a problem where the code is actually working correctly? How many times has someone raised a problem but given insufficient evidence to know what's going on, resulting in the famous "works for me"? And how many times was it PEBKAC (problem exists between keyboard and chair)?

And let's be clear. **_Everyone_** is capable of PEBKAC errors. There's a reason the ["Midvale School for the Gifted" cartoon by Glen Larson](https://store.gocomics.com/product/the-far-side-comic-art-print-midvale-school-for-the-gifted-color/?ref=thefarside&_encoding=UTF8&tag=thefarside00-20) is so famous.

But even if you're 99% certain there's a bug, even if you can consistently reproduce with your code, still stop.

Open source projects typically use GitHub Issues. If you've raised issues on good open-source projects, you've seen a section that says "Steps to Reproduce". If you maintain open source projects, you should be creating those GitHub Issue Templates that include an area for "Steps to Reproduce".

That's good, but a reproducer is better.

## Why Should I Bother?

If you've had to support an open source project, hopefully you should not be asking this and you can skip this section. But if you are asking this question, you **_need_** to read this.

Let's put open source to one side for the moment. With open source you have the right to expect what you pay for - nothing.

But if it's a paid product, and you have a support contract, you're paying for the _right to raise tickets_ and the right to expect a technician to spend _some time_ looking at the problem. You're not paying for the right to get fixes. That's what your renewals pays for. But renewals only pay for fixes and new features the vendor chooses to deliver.

If you want a fix, there's a _quid pro quo_. You're expecting someone who owns the code to change the code. More importantly, you wanting the _right_ fix, one that's fully thought through and QA'd to avoid or at least minimise knock-on effects. That takes time, time that - whether you want to accept it or not - you are not paying for.

If you want the owner of the code to put in the time, show your respect for them by putting in some time yourself. And you can greatly minimise their time by creating a reproducer.

A reproducer doesn't give you the right to expect a fix. It doesn't even give you the right to expect a workaround. Providing a reproducer creates a favourable impression with the owner of the code, increasing the likelihood of receiving the most positive response - not only for this support ticket, but also for future ones.

## Purpose of a Reproducer

A reproducer should allow the owner of the code to quickly reproduce - and thus cleanly troubleshoot - the cause of a bug. It should:

1. Allow the symptom to be consistently reproduced on any device, or at least any device of a specific type.
2. Minimise additional code.

The first avoids the dreaded "works on my machine" response. It can also allow you to prove that before raising the ticket. The second minimises other possible causes or distractions.

Together the code provides a simple test case - or set of test cases - to debug, verify the bug and identify the cause.

Additionally a reproducer could include code that tests other scenarios, to help the technician pinpoint the cause. I've been in this scenario, which I covered in a blog post on [GetAllDocumentsByKey with Doubles](https://www.intec.co.uk/apparent-java-getalldocumentsbykey-getallentriesbykey-bug/). In this case I experienced it with Java in XPages. I provided a reproducer specifically for XPages, but also a reproducer in a Java agent. This was specifically to rule out that the problem was specific to XPages. Yes, that was highly unlikely. But the reproducer allowed anyone picking it up to _know_ that within seconds.

The result of all of these should be fewer questions from the support technician and quicker agreement that the code is doing what you think. Note, I did not say "agreement that it's a bug". You have code that is not behaviour as you expected. The code may be working as it should because of other factors you had not considered when expecting a specific outcome. Your expectations may even have been correct, but the code is doing what the owner of the code wants it to. Or it may be a bug, meaning the code is not behaving as the owner wants it to. But the reproducer ensures you get to a conclusion as quickly as possible.

With open source that conclusion may be you providing a pull request - for code or documentation - that gets accepted more quickly. Or the conclusion may be not wasting your time on a pull request, or creating a fork to make it work the way you want it to. Whatever the outcome, the reproducer will increase the chances of a swift solution and avoid a support ticket going into "discussion hell", wasting your time as well as the support technician's.

Why is time important? Because time spent on support is time that isn't spent on other things. For open source, which is often done in personal time, that's _very_ important. But it's also important for products.

As we're working through VoltScript, I'm both owner and consumer of code, as well as the person responsible for delivering the whole project. If it takes time to verify if the code is working as we want, that's time lost on adding new features. And so I'm always trying to include a short reproducer when querying whether code is functioning correctly.

Of course, there is also another advantage of a reproducer. It will enhance your reputation with the support technician, improving your credibility. If you're just a consumer, that will be a benefit for future support issues. If you're working together on a product, it's even more important.
