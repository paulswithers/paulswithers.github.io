---
slug: rapid-development
date: 2025-06-30
categories: 
  - Coding
tags:
  - Coding
  - Editorial
comments: true
---
# Developing at Speed

One of the main outputs of research development is the proof of concept. An early lesson I picked up when I joined HCL Labs was to deliver working code, not slides. And the key when building a proof of concept is speed. In some cases, it may end up proving why an approach *won't* work. In many scenarios, it may end up being put on a shelf indefinitely. Even if the concept proves appealing, the implementation choices may not be the preferred option for the final solution. So speed is of the essence: spending a couple of weeks building something that goes nowhere is acceptable; spending a couple of months is not. So the ability to get maximum results in the minimum time is key.

But how do you do that?

<!-- more -->

Recent experiences have reinforced confidence in my ability to achieve this, to such an extent that the speed of my development surprised even me. It's led me to reflect on my approaches and draw some conclusions. The conclusions are not just relevant to building proof of concept applications, but are relevant to all development. Indeed many of the lessons are ones I've been using and talking about for many years.

## Planning

> If you fail to plan, you are planning to fail.

This is a well-known quote often attributed to Benjamin Franklin, but there is a lot of truth in it. The planning phase is the first and an important step in developing at speed. Is it the most crucial? Not necessarily. But a bad start is never a good omen.

Does it need to be done on paper? Not necessarily. It depends on the complexity of what you're building and your ability to understand it at a macro and micro level. An individual with a [Ri mindset](./2025-05-15-shu-ha-ri.md) may already have grasped all aspects we'll cover shortly. But in can be helpful to document all the requirements, both to ensure something's not forgotten during the development process and ensure it's documented in case something else takes precedence.

### Structure

Firstly, you're not building *something*. You're building a bunch of somethings that come together to comprise a bigger something. You need to **understand** the separate pieces in what you're building and you should break *everything* into small bite-size pieces. You need to identify those early on.

In addition, you should also consider what additional functionality might be needed, considering its importance and urgency. These are importantly not things you're going to build, but things that might end up needing to be built.

Most importantly, you're looking at functionality here, not technology. You're defining the "what", not the "how"; the functions that need to be delivered, not the technology or framework, not necessarily even the language you'll use. And everything may not even use the same technology. You need to focus just on what the proof of concept needs to *do*, not how it will do it. Until you know all the moving parts, you should not commit to a particular implementation.

This last point is particularly important, and a mistake I often see in software enhancement requests. Too often they focus on a specific technology choice or implementation approach. And sometimes those particular choices are not suited to the requirement or will prohibit key functionality that has not been identified. That's because the individual was focusing on a specific technical solution for a requirement that was too narrowly defined, focusing on the how instead of the what.

### Understand the Options

**PLURAL**. In my blog post about [troubleshooting](./2019-10-28-troubleshooting-support.md) I also focused on the importance of considering multiple potential causes. The same is true here. Once you've identified all the "whats" you need to build, it's important to consider multiple "hows" for each. I regularly describe development research as problem solving, as throwing a lot of balls into the air and looking for the best balls to use to get from A to B.

And there are multiple factors I take into account when I'm looking at potential options:

- ease to build
- off-the-shelf options
- ease to deploy
- skill-sets of those involved now or in the future
- standards and best practice approaches in other implementations
- vibrancy of relevant communities
- scalability, but only if relevant
- future-proofing / technical debt
- loose or tight coupling
- flexibility
- external factors

I want to go into more details on a few of the aspects here.

#### Ease to Build

It's important to get an idea of the complexity to build certain functionality. This isn't about giving firm timescales, although when doing customer-specific work there might be that requirement. It's about identifying where you might need to do a bit more investigation up-front, or where you need to do additional investigation later. It's also about identifying the order you'll work on pieces of functionality. A specific piece of functionality may be very important, but it's easy to build a quick throwaway alternative which can have advantages when it comes to the development phase.

#### Off the Shelf

Firstly, in all aspects of development, writing something from scratch will give greatest flexibility. But it will often be slower to build and harder for others to work with. Moreover, the more complex the functionality, the greater the likelihood of reinventing mistakes others have already learned.

Of course this can be mitigated if you understand how alternatives work, whether they be in the same or other languages. But personally, the "not invented here" attitude is not one I've chosen or considered productive. If something does the job, has decent documentation, is well-considered, is structured well-enough for me to understand, and gets the job done quickly, I'm happy to use it and move on.

Will it be perfect? Probably not.

Will my version be perfect? Certainly not. And I guarantee, neither will yours first time.

If I'm looking at open source, I'm not necessarily looking at number of downloads or git stars. Number of downloads is different to number of production uses. Git stars doesn't equate to relevance in the current climate. I'll be impressed if the documentation is decent, gets me productive quickly, and answers my related questions. If there's a vibrant community around the solution or technology, that also is important. But I'm also looking at level of technical debt and future-proofing. Are there techniques, approaches, or frameworks that are becoming out-dated? Can I understand the code well enough to support or extend it myself. Is it something that I think will need replacing in a few years? If it's not the ideal solution, can it be loosely-coupled so that a better alternative or a custom solution can be switched in later?

#### Flexibility

It's important to stress what flexibility is *not*.

I don't mean soft-coding everything, making everything configurable, or using configuration files for everything.

I'm talking about flexibility of use. A proof of concept may sit on a shelf indefinitely or may be picked up for something completely different a few years later. Or part of the solution may be relevant to a different project or product. The key here is not *enabling* flexibility, but *not preventing* flexibility: leaving as many avenues as possible open for the future.

There will be decisions you make that will preclude certain future opportunities. The key is being aware of where lack of flexibility is being included, identifying the level of risk, and minimising those that will have the worst impact.

#### Others

Technical debt and future-proofing most definitely fit into this flexibility. This is not just using modern frameworks or standards. It's also being aware of other projects happening, other products where the proof of concept may be relevant, and business and technical trends. Using an outdated technical approach because you're familiar with it may get quick outcomes in the short term. But adopting something more modern gives experience and sample code that will be relevant for other projects, as long you're able to be productive.

Understanding trends is something that's more difficult and something that may not be easy for detail-focused developers. It requires a broader focus, the ability to look at consistent themes across different areas or timescales, and an awareness of what's *not* said as well as what *is* said. But if you can identify trends, you're more likely to make decisions that have greater flexibility than a narrow use case.

And there will also be external factors that need to be borne in mind. This might be skill-sets of people available, technological preferences from interested parties etc.

#### Don't Be Afraid To Not Know

You don't have to have all the answers. There may be particular parts of the process for which you don't have a perfect answer - or maybe even no answer at all. It can be useful to have excluded certain options for a specific piece of functionality. If you need a certain prerequisite before a solution is possible, that is useful information that can be factored in. Maybe the overall understanding can still be conveyed by using mocking or hard-coding. Or you may identify a viable solution later in the process.

### Advantages and Limitations

With the various options for each part in the overall solution identified, you can assess the advantages, disadvantages, and limitations of each. The right option for a proof of concept may be different to the right option for a final product. Limitations may be acceptable or not. Increased flexibility may make an option for one part more preferable. The more loosely-coupled each piece in the puzzle is, the easier it will be to adapt in the future. And it may be quicker to develop as a result, because mock inputs / outputs can be used by different teams or developers.

The important point here is that this is a first pass. THe crucial part is to keep reviewing throughout the development process and *not to be afraid to change your mind*. Having multiple options makes this easier and **quicker**. The earlier you're able to change, the shorter the distance you've travelled down a dead end, the less mental effort will have been expended on the development and the less mental effort you'll need to expend on deciding on an alternate approach.

## Development

Now it's time to start the development. There are some key lessons I've learned over the years and ones I used very recently that significantly reduced development time.

### Build Incrementally

As I mentioned at the start of this post, one of the important lessons I learned early in HCL Labs was to show running code, not slides. Rarely does a week go by when I don't demo something and I'm not happy if I don't have something to demo after two weeks. I'm keen to highlight also where this demo fits into the process of the overall development.

So at the heart of my development, and at the heart of developing at speed, is building piece by piece. Of course this comes from the planning phase, where I've broken it down into smaller pieces. I'll add more functionality bit by bit. An added side-effect of this is it gives regular touchpoints to assess progress against expectations, assess what's left, and review existing and additional limitations or opportunities.

The timeframe is significant here. I'm not aiming to complete a milestone each week. I'm looking at adding a new piece of functionality every day or two at most. That is the level at which I've broken the development down at the planning phase, and the level of velocity I'm aiming at.

#### Hard-Code, Then Add Configurability

Hard-coding is bad, right? Wrong! For a proof of concept, it's perfectly acceptable. Even for a bigger development, hard-coding enables you to get more complex functionality working successfully and, most importantly, with greater simplicity. If it doesn't work, there are fewer places where things can go wrong. And even if you assume the soft-coding and configurability to built in is not the problem, you will be wrong sooner or later. And while you're wasting hours and getting exhausted and probably asking colleagues to help you, I'll be demoing the final solution.

Minimise the new code, minimise the places mistakes can happen, and progress will be quicker.

### Measure Twice, Cut Once

Ensure your code can be tested as granularly as possible. Some will prefer [pure functions](https://en.wikipedia.org/wiki/Pure_function) to minimise the risk, I'm personally not a purist (forgive the pun!). But if something doesn't work as expected, I will ensure I can identify with certainty where it's going wrong as quickly as possible. This may be through debugging hitting a specific breakpoint, this may be by cross-checking from multiple directions. For example, with a REST service, I'll test from bruno as well as the application I'm building.

Source control can help identify regressions and for that reason I ensure each commit tries to include all files affecting a particular piece of functionality, and ancillary cleanup is in its own commit. Unit or integrations tests can help identify regressions as well. These might be coded tests or might be bruno requests.

But the key throughout is speed. If it takes a long time to identify the cause of a problem, that increases mental exhaustion which increases the risk of more mistakes which slows down development. Looking longer term, it also means more time spent on support, which increases the risk of unfixed bugs and lower ROI.

#### Increase Complexity

At your planning phase, you should also have got an idea of what was easy and what was difficult. Get your quick wins in, demonstrate progress, build the easier parts and add the more complex functionality later.

It's not just about minimising new code at each new step, it's also about minimising *complexity*. Your planning phase may have identified options that were simpler but no use for a final solution. That doesn't mean you shouldn't code them.

In the case of a proof of concept, a less feature-rich option may have no perceptible difference to the audience. If it takes a fraction of the time, even if it needs to be replaced later, the proof of concept has still achieved its aim.

Even where it's not fit for final purpose, choosing the simpler option can still make a lot of sense. You may have identified a two inter-related parts that are both complex. Trying to get both right at the same time will be challenging, fraught with risk, and likely to slow you down. In the planning phase you may have identified an alternative option for part B that is simpler, but of no use for the final solution. I've found real benefit from developing the whole things with the production-ready option for part A and that simple option for part B. It can allow you to focus on getting a working outcome quickly, and minimising the changes you make to then integrate the more complex option for part B.

#### Standalone First

At some point, the codebase will grow and you have another piece of complex functionality to add, something you expect to get wrong first. Using hard-coding and less complex functionality may not be enough to avoid risk. At this point, I've found considerable benefit in building the functionality standalone first, working through all the complexities separately, then trying to integrate it into the full codebase.

This builds on everything we've seen so far: increasing complexity, giving a way to test standalone and cross-reference with the full codebase, and minimising new code.

### Fail Early

Failure is not a bad thing. But failure after days of struggling is bad. At that point, you're mentally exhausted, you may have introduced bugs into the code, or made changes that you've forgotten and which stop alternatives working.

Again, this comes back to identifying multiple options in the planning phase. It comes down to having alternative ways to test. It comes down to minimising complexity.

The sooner you can identify a failure to achieve your aim on a particular part, the better. The solution may vary. In the case of a proof of concept, some hard-coding or a less optimal option may be imperceptible when it's demoed. So go with that and move onto something more important. An alternative that seemed harder may end up being easier to implement. Or you may now see it as more preferable, when you review it some time later. A less optimal alternative may still be an acceptable stop-gap until the preferred option can be made to work. It may be that you can get it working just a day or two later, it may be that someone else can succeed where you failed. The key is progress.

### Summary

All of this comes down to minimising risk and focusing on progress.

## Review

My job title has usually used the term "developer". That's because I've never just coded to a technical spec, I've always been developing the application. That means reviewing the spec and reviewing the options *while* I do the development. This is crucial and it's why I specifically stated the planning phase was a first pass.

We've already seen it addressed in failing early. But it's a common case where I identify additional requirements, limitations, or flexibility as I'm developing. What seemed to be the right or wrong option initially may change as development progresses. Or it might be affected by external factors.

### Understand Limitations

It's also important to review, understand, and accept limitations. There is a difference between a proof of concept, a minimal viable product, and a complete solution. A limitation may cease to be a limitation because of changes elsewhere. Or something that seemed fine may subsequently become a limitation. And if it's a proof of concept that just gets put on the shelf and never used again, or functionality that gets delivered but never used, limitations are moot.

Knowing when to stop is important. Because there should always be another project.

## Overall Summary

There is a lot here. But there are a number of key takeaways I always bear in mind:

- Planning is crucial, whether it's in your mind, bullet points in your notepad, or a few slides.
- Developers are paid to write code, so have running code and demos.
- Having all problems solved is not critical. Solutions may come later if you review regularly, just as more problems will crop up.
- Ensure you can test parts of a process in more than one way.
- Minimise complexity, minimise what's new.
- If a problem is not overcome in a couple of hours, and you don't understand the problem, try an alternative.
- Constantly review.