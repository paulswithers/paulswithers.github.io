---
slug: making-progress
date: 
  created: 2016-10-20
comments: true
categories:
  - Editorial
tags:
  - Editorial
---
# Making Progress (Bars)

Earlier this week I had problems with high CPU utilisation and had to restart my PC. I took the opportunity to bite the bullet and install some Windows Updates. What I saw brought my mind back to UX and coding of applications. For at least five minutes, the progress displayed as "**100% Complete**". It prompted me to issue the following tweets:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Developers, progress bar should never show 100% complete. It should be 0% of next process or gone. Windows updates 100% complete for minutes</p>&mdash; Paul Withers (@PaulSWithers) <a href="https://twitter.com/PaulSWithers/status/788393811022143488">18 October 2016</a></blockquote>

<!-- more -->

As web applications have become more sophisticated, it is commonplace for applications to load at least the basics of a page before running additional processes, or to make callbacks to the server before taking action based on the response (what used to be called AJAX calls, are still asynchronous, but rarely return XML nowadays). There are various mechanisms for managing the user experience of such processes, from the non-existent to the sophisticated - doing absolutely nothing, just disabling a button clicked, adding a mask over the page to prevent access while the process runs, adding some kind of animated image to the mask to help comfort the user that something is still happening, or adding some kind of progress bar that is updated as degrees of progress are reached. They may be newer to web development, but they've existed in computers for as long as I can remember.

But being on the user end gives some kind of perspective. A progress bar that updates its progress may seem the best and most sophisticated approach. It's certainly the most sophisticated, but in my opinion not necessarily the best. Take the scenario I had with a status of "100% Complete" or a progress bar that just sits at 100% full. What is the user to think? How does the user know something is still happening? After all, as I vented on Twitter, if it's actually doing something either the process is **not** at 100%, or there is another process which is happening. And as much as the developer might think that process won't last long so doesn't need a progress bar, as in this case, it might not be instantaneous. And when (not "if") it's not, the effort put in to create a nice user experience by showing progress for the last process is completely undermined. The developer has took the time to communicate to the user that something is happening and will take some time, they've communicated where in the process it is, but they've then misled the end user by implying that everything is finished.

Admittedly, as developers we're all also human beings and the nature of being human is to be lazy. So there will be times when we don't make the effort to produce that best user experience. If the process isn't critical, maybe we can afford to be lazy. But if the process is critical, and connectivity or other circumstances mean a process takes longer than we think, and we don't bother with the progress bar, we can't blame the user if they think it's hung and not doing something when in fact it is. If they abort the process prematurely, it's then our fault, not theirs.