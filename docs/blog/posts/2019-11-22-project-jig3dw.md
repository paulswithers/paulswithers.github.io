---
slug: project-jigd3w
date: 2019-11-22
categories:
  - Tutorials
tags: 
  - Tutorials
  - Domino
  - Nomad
comments: true
---

# Project Jig3dw: Tutorials Re-Imagined

![Project Jig3dw](../../images/post-images/2019-11-22-project-jig3dw.png)

The world of HCL Digital Solutions is evolving rapidly. This brings a lot of excitement but also a lot of challenges. The last certification exams for Domino were in the era of Domino 8.5. Training materials have also languished a lot - official ones from the vendor and from elsewhere, as the ecosystem has contracted. At the same time, the product has diversified and expanded.

<!-- more -->

Would a single "upgrade exam" work for a product that covers XPages, Nomad, App Dev Pack, OSGi plugins and more? It's debatable, but probably unlikely. And that's without considering HCL Leap on Domino.

Meanwhile, there's a drive to introduce Domino to newer markets. Developers who have no background on Domino will obviously have different requirements. Can a traditional tutorial approach provide enough information for those unfamiliar with the product, while also fitting those with decades of experience?

And that also fails to cater for different personalities. There are those who can pick up new technologies and simple 1-2-3 tutorials without an issue. There are others who are adept at finding new and interesting ways to get it wrong, even though they're following the steps faithfully. There are those who just want to speed through the tutorial "developing by numbers". There are others who want (maybe "need") to understand what they're doing. Traditional tutorial approaches tend to take a "one size fits all" approach - you get what you get, and _you_ need to be the one to adapt.

And that's before we get into validation / certification to confirm you've followed the tutorial and understood what's done.

Project Jig3dw is designed to evolve a proof-of-concept framework for modular tutorials to address all these areas. What there is now is the start of a [tutorial on HCL Nomad development](https://paulswithers.github.io/domino_todo/pages/setup/create-images), following through building the sample I put together following the [2019 Collabsphere Beauty Contest](https://collabsphere.org/ug/collabsphere2019.nsf/contest.html). It was profoundly disappointing that more in the community didn't get involved - you don't need an iPad to develop for HCL Nomad, as the tutorial will show. The key concepts were outlined previously by Theo Heselmans in his [Wine app on OpenNTF](https://openntf.org/main.nsf/project.xsp?r=project/Wine%20Tasting) and by me in my [modernisation session at Engage](https://www.slideshare.net/paulswithers1/engage-2019-modernising-your-domino-and-xpages-applications). And it doesn't take long, as you'll see with the tutorial which will build the app in the related [GitHub repo](https://github.com/paulswithers/domino_todo). The screenshots for that were included in [a tweet some weeks ago](https://twitter.com/PaulSWithers/status/1188044204821405697).

The tutorial itself is built using GitHub Pages, integrating Bootstrap, thanks to [bootstrap-4-github-pages](https://nicolas-van.github.io/bootstrap-4-github-pages/). The theme used is the [Bootswatch Cosmo theme](https://bootswatch.com/cosmo/). This means it's markdown pages, integrated with Jekyll and Liquid into HTML files. I hasten to mention that this technology is in use for proof-of-concept. I expect it to change, though it's also possible this might be a workable option going forward. Whatever is used needs to be relatively simple with a low barrier of entry, because the framework needs to work for not only developers but administrators, power users and more. You can see some examples of elements in use on the [samples page](https://paulswithers.github.io/domino_todo/samples). The key elements specifically introduced are the "Why?" and "Troubleshoot?" blocks. These are initially hidden, but allow more detailed exposition for those who wish it and troubleshooting to allow followers to jump back and validate they haven't made a mistake on specific areas. This is about richness without overwhelming and ease of use without the burden of support. This is very much the "3D" element.

This is the tutorial part, but I also have specific ideas about how validation / certification could work.

And it's designed for a modular approach. One tutorial could link in to other pre-requisite tutorials (e.g. "Installing a Domino Server", "Administering HCL Nomad") and link off to other tutorials (e.g. "Advanced Nomad Development"). This is envisaged as an approach to minimise the burden on the community while maximising the expertise of HCL Masters and more, and building an expansive "jigsaw" of professional development.

Whether this is adopted or abandoned, I don't know. Whether it evolves into something bigger, we'll have to see. At this point I'm only throwing it out there to see if it's got legs and can run. It's just one of those ideas that have been forming in my mind for a while, and why I've taken the opportunity to get involved at HCL. But it's something that shouldn't be the responsibility only of the vendor - the community has a wealth of expertise and best practices, but they need to be leveraged in a way that doesn't overwhelm. Because, at the moment, I don't think the proactive people in the community can support the number of consumers without being burned out. And the community can't afford for that to happen.