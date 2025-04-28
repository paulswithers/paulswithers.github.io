---
slug: dql-what-is-it-good-for
date: 2020-01-21
updated: 2024-12-01
categories:
  - Domino
tags: 
  - Domino
  - XPages
  - Java
  - LotusScript
  - VoltScript
  - Domino REST API
comments: true
---
# DQL: What Is It Good For?

tl;dr - anything you're doing on Domino, but the message doesn't seem to have reached everyone.

DQL has been at the forefront of my radar since Domino V10 over a year ago. If I remember correctly, documentation wasn't immediately available in Domino Designer's Help, but was soon published online. It's been at the heart of sessions and advances ever since. It's often been discussed alongside the app dev pack, which allows Node.js applications to interact with Domino via the proton task. And judging from a couple of discussions in different fora over the last week, it appears the connection between DQL and the app dev pack seems a little too close. It seems to have led some to ignore DQL assuming it's only for Node.js development.

<!-- more -->

**NEWSFLASH:** DQL is not just for Node.js development.

Thanks to the excellent John Curtis, DQL is coded at the C++ layer, exposed to:

- **LotsScript**
- **Java**
- Therefore also **XPages**
- Therefore also **ODA**
- **Karsten Lehmann's Domino JNA project**
- **Node.js endpoints**
- **Command line utility domquery.exe**
- **and soon more...**

!!! info
    Update: DQL is also available in Domino REST API and VoltScript now.

I'm sure there have been plenty of slides highlighting that, but I'm not sure the message has got through as loud and clear as it should.

Yes, it requires at least Domino V10. But I'm aware of customers that have had V10 running in production for a while. And with various releases, more and more features are being added to DQL and fixes are included.

Some have bemoaned the lack of a demo NSF that they can use.

**NEWSFLASH:** It's called **DQL Explorer**.

DQL Explorer may be known as a Node.js application and I'm sure some assume it's using the proton task. The UI is indeed Node.js, packaged into an NSF - yes, you can do that. But it's not using proton, it's not dependent on the app dev pack. If you take the time to download it and have a look, the Node.js UI is calling **LotusScript agents**. There are 13 calls to LotusScript agents in `App.js`, 1 call to a LotusScript agent ("getDatabasesFromServer") in `DatabaseList.js` and 2 calls to LotusScript agents in `index.js`. These agents are all called via the ?openagent URL command which has been available for as long as I've been working with Domino. The agents are all available for investigation using the skills you've honed over your whole Domino career **in the NSF**.

And, yes, it's LotusScript. But if you've got skills with Java it shouldn't be rocket science to work out how to use the samples in Java.

So now you know.

And if you're on V10 or V11, DQL should be one of the tools in your toolkit. If you're on V9, hopefully you're already planning upgrades to a more recent version.

There are several sessions on DQL at [Engage](https://engage.ug). If you're in Europe and doing Domino, it is one of the premier conferences in the region and well worth the money, without a doubt, every single time. I would recommend anyone attend. For manager, the ROI is significant and well worth an annual training budget. (And if you don't have a training budget, you don't deserve staff retention.)