---
slug: negotiating-enhancements
date: 2022-09-25
categories:
  - Editorial
tags: 
  - Editorial
  - Community
  - Support
comments: true
---
# Negotiating Enhancements

No IT solution is delivered using code written solely by the solution provider. There is always dependent code written by a third party. Dependency management tooling has proliferated in every technology sector to support this. At the language level, this is handled by maven, gradle, npm etc. At the platform level, it’s handled by Homebrew on Mac and various options on Linux. At the DevOps level, it’s handled by Docker, Helm, etc.

And every solution includes an implicit assumption that the dependent code will continue to work as it does and provide whatever the consumer requires. For product offerings, this may be in the form of OEM agreements. For open source, it still exists, whether consumers are willing to admit it to themselves or not.

<!-- more -->

And the brutal truth for consumers is that the authors of your dependencies did not write their code knowing your requirements up front. Whether or not it fits your implementation falls in the realm of “caveat emptor”. If it doesn’t, if you need an enhancement or you find a bug, your priorities may or may not align with the priorities of the owners of that dependency. With a product, you’re just one paying customer. With open source, you’re just one *consumer* - not even a customer.

So how can you get the optimal result when you want something from that product owner or open source manager?

## Venting is Counter-Productive

Venting on social media or forums is a common tactic. The only way it can have a positive reaction is if it embarrasses the owner sufficiently. This can only be achieved if you are venting from a position of sufficient leverage or expect sufficient support or damage to build a position of sufficient leverage. That is rarely the case.

Even if you achieve this, venting will always alienate. The result will be damage to your personal standing with the owner. That will undermine your attempts to negotiate future enhancements, unless you are willing to spend the time to repair the relationship. But if your first thought was the vent, you’re not likely to but the work in to build a good working relationship.

Of course you may already have decided to move to an alternative provider. But then you’re not seeking anything positive out of your action. If you’re not recommending an alternative, or showing people how to more easily switch to an alternative, but you’re just venting, you’re not going to be improving your social reputation. But if you don’t care about that, in all likelihood you’ll hit something in the alternative provider that doesn’t work how you want it, vent again, and end up having to spend time switching again.

Venting is a lazy approach and in most circumstances counter-productive.

So what are my recommendations, based on experiences, for maximising your chances of achieving the outcomes you want? Because the best you can do is maximise your chances, there is no magic formula to always getting what you want - even taking ownership yourself won’t necessarily bring what you want.

## Understand The Product

Some may think this means understanding what the product *can do*. No. What’s important is understanding what the product was *intended to do*. More important is looking at recent releases, recent features and the roadmap. This will inform you on where the product or project owner is willing to invest time. You may need to read between the lines a little.
Also, look at other feature requests or issues. Pay attention to the responses. This can often inform on what the owner deems important.
Most important of all, *engage* with the product or project teams. I always say that we were born with two eyes, two ears and one mouth. So we should do twice as much observing and listening as we do talking. And observing is different to looking, listening is different to hearing. Engaging with the product teams is about *learning* what they consider important.
Only after all this can you understand what is important to the product or project owners. You should have gathered some understanding of this before choosing the product / project, and you need to regularly review it - directions change. But you need this information to know ***how*** to ask for what you want.

## Negotiate

You now have a better understanding of the priorities of the product or project owners. You now need to ask how what you want benefits them and their priorities. Even if you’re contributing a pull request, the owners have to do work. Even if you’ve fully covered all possible impacts, testing needs to be verified and documentation may need updating. If the work done doesn’t fit with direction and strategy, that work will not be prioritised. Even if you’ve paid for the product and pay for maintenance, that doesn’t buy you your own way. You’ve paid for the work spent on it so far, and the right to have your opinion listened to, nothing more.

So an argument needs to be constructed that takes into account the owner’s views on product direction. This may mean looking for an impact in an area pertinent to product direction. It may mean referencing strategy over recent years and highlighting how the work improves the quality or completeness, to maximise work done on that strategy. It may mean identifying how doing the work now will make future planned strategy easier or better received.

Look for an outcome, not an implementation. Concentrating on the outcome will ensure you focus on benefits for consumers, not a specific piece of functionality. When you’re speaking to someone whose focus is strategy, customer stories and customer benefits are key. By all means discuss possible implementations, but a specific implementation may result in a very narrow benefit. And the more micro you think, the more you might miss the macro.

It may not be possible, but work with others. However, it’s best to ensure you are not all wanting the same benefit. A broader set of stakeholders, outcomes and benefits produces a greater justification and impact.

Ask also what *you* can do to help. If you’re willing to do work, people are more willing to invest their own time.

## Change Takes Time

So you’ve got a commitment to do the work you’ve requested. But your work’s not done. Priorities always change, strategy evolves and there may be impacts you had not anticipated. Keep the channels of communication open, keep working with all stakeholders, adapt your justifications and requirements where appropriate. But most of all, stay patient. Change is either very quick or takes time. If expectations are unrealistic, you can lose support.

## Summary

Not all your required fixes or enhancements will fit in with the priorities of product or project owners. Sometimes you have to accept your needs do not align with strategic desires. But even when they are more closely aligned, achieving the best outcomes takes time, effort, understanding and careful thought.
