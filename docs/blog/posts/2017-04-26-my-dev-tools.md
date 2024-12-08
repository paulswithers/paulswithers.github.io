---
slug: my-dev-tools
date:
  created: 2017-04-26
comments: true
category: Dev Tools
tags:
  - Dev Tools
  - Editorial
  - Git
---

# My Development Tools - Part One: Domino and XPages

I've recently had a new laptop. Since I last had an upgrade of hardware a lot has changed. Back then, I think my development tooling was Domino Designer, a Domino server, and possibly SourceTree. Now the software I needed to install was much more significant. So now is a good time to cover that.

<!-- more -->

## Domino Designer, Domino server

I'm still a Domino developer, so Domino Designer was the first application development software installed.

The bulk of that development is around XPages applications now. There are a few Notes Client applications or traditional Domino web (only) applications, but for a number of years now any new applications have been XPages. New aspects of traditional Domino web applications have been done in XPages too, resulting in a number of "hybrid" Domino web applications, with older areas using traditional Forms-based access but any newer areas using XPages. And where significant development has been done on Notes Client applications, the focus has been on providing functionality via XPages, so Notes Client access has been predominantly for administrative access only.

Moreover, since 2011, every XPages application has included at the very least the Extension Library and often other plugins like Debug Toolbar or XPages OpenLog Logger. Over the last few years, every application I've used XPages in has also used OpenNTF Domino API.

This use of plugins means Domino Designer local preview is inadequate as a rendering engine. That means I also have a local Domino server installed.

## Plugins / Open Source Extensions

It's beyond the scope of this blog post to cover my passion for open source and why I think everyone who wants a _career_ in application development should get involved with it. But that means there are a lot of extensions to Domino Designer or my Domino server that I install automatically (and which I cover in my training courses). Here is the list I currently use:  

- **OpenLog:** I believe it's a no-brainer for best practice Domino logging. That belief is backed up by experience of where I've inherited applications where developers have tried to use "supported" alternatives, making errors in implementation, incorrectly copy/pasting, not returning adequate information for support etc. With OpenLog I always quote the example I had some years ago where an error started occurring because of a Notes Client bug introduced in a fix pack. Without OpenLog I would have spent a long time trying to work out the cause, because I had no reason to believe the customer had deployed that fix pack version and the end user would probably not have realised. OpenLog immediately identified the version they were using, giving absolute concrete proof that corresponded exactly with an IBM technote. No other Domino logging mechanism that I've encountered, in-built or proprietary, would have provided me with that information.  
- **XPages OpenLog Logger / ODA:** OpenLog itself has libraries for use in LotusScript or Java agents / web services. But for XPages the code in XPages OpenLog Logger (subsequently incorporated into ODA) is my de facto integration point between XPages applications and OpenLog. That partly started because an OpenLog implementation in TaskJam was not Apache-licensed, so couldn't be incorporated in Apache-licensed open source solutions. But thanks to knowledge I had gained and improved by feature requests, it has gone way beyond just an implementation of the Java Script Library available with OpenLog itself.  
- **Extension Library:** The extension library was a no-brainer for me from when it was first released. Anyone involved since the early days of XPages will have read blog posts about various hacks for using Dojo dialogs within XPages. The issue arose not because of a failure of XPages, but because of an inevitable conflict that will always occur when trying to combine two independently developed frameworks. Extension Library immediately solved the problem. But anyone who stuck only with "officially supported" releases has really been handicapping themselves, missing out on things like Bootstrap and enhancements I've contributed back for Value Pickers and Name Pickers. I've always used Extension Library from OpenNTF, never just the core. Feature Pack 8 and the focus on a continuous delivery model now mean if companies keep their servers up-to-date their will be less of a gap, but really there's little point _not_ deploying the Extension Library. If you happen to hit a bug, you'll be waiting longer for a fix in the "officially supported" version than if you use the open source version. And if support is the argument against using it, plenty of business partners will provide support.  
- **Debug Toolbar:** Mark Leusink's Debug Toolbar is another no-brainer. It provides insight into the current XPage that's not easily available elsewhere. I've not seen many custom implementations since Debug Toolbar was released, but I've never seen a better one. Plus, for those wanting to use it as a learning resource, it's a good demonstration of a tool that started as a custom control and has morphed into an OSGi plugin.  
- **XPages Log Reader:** For reading log and configuration files, XPages Log Reader is a great interface, reducing the need for direct access to the server itself.  
- **ODA:** OpenNTF Domino API is a no-brainer too for me. Prior to using that, infinite loops were a regular inevitable outcome. Java developers can take advantage of setting up templates (using core Eclipse functionality) to mitigate, but if you're not using ODA, you're probably not aware of how to do that. Since ODA I can remember only once having an infinite loop since, and that was not in Domino-specific code. Recycling is another minefield. If you know how to recycle correctly and efficiently, chances are you've since embraced ODA. And that's without the host of enhancements to Domino functionality that have come in since early versions. The ODA channel on OpenNTF Slack currently has 74 members and that's by no means covering all developers. It's a key library.  
- **POI4XPages:** This is another useful library, though not one I've used heavily. My integration with Apache POI has tended to be more customised, so I've just added the relevant jar files to my application.
- **XPages Toolbox:** This is always useful for performance tuning.
- **Swiper:** Swiper is another no-brainer as far as I'm concerned, if you're using source control. Enhancements for FP8 make it even more useful.

## Source Control

Talking of Swiper leads perfectly into covering source control. Source control is still problematic with Notes Client or traditional Domino web applications, because of limitations with DXL round-tripping. Recent work done for Panagenda's ApplicationInsights may address some areas I raised at IBM Connect some years ago, we'll have to see when that comes into a future feature pack. But beyond Notes Client or traditional Domino web, it's a no-brainer.

I committed 100% to it after making the mistake of accidentally deploying changes made for a POC change request for a customer. At the time I had no reason not to expect the change request to go ahead, so the changes were made in the template to speed up actual development. But months passed and the approval on the change had still not happened. Some months after the change request was submitted a fix was required. I'd forgotten I had made the POC changes and they accidentally got deployed.

Since then, source control has been integral to my development and that kind of POC is done in a feature branch. If the feature doesn't go ahead, it remains a dead branch. But its still there if it is needed in the future. Plus it also is useful as an aide memoire if similar functionality is required for another project, and I've had that occur.

### SourceTree

For source control, the tool generally used by developers I'm aware of is Atlassian SourceTree. It's a nice GUI interface which also provides terminal access as well.

### P4Merge

Merge conflicts inevitably occur. My tool of choice for managing them is Perforce P4Merge. It nicely compares original, yours and theirs. It also makes intelligent guesses about which to choose. Once the result of the merge is saved, you still have a .orig file which is the original, although I typically delete that.

### Git

I still also install Git. Sometimes it's useful to just use a command line prompt, although SourceTree's terminal would also suffice. An example is if you want to move a file or folder. Physically moving it will produce a deleted and new file. The `git mv` command moves it allowing comparisons against the previous versions in the previous locations. StackOverflow regularly gives answers on how to do such functionality (changing a tag or branch name is another), but answers typically give the raw git commands. Being able to issue those get around working out how to do it in SourceTree, if SourceTree actually exposes that functionality. After all, it doesn't reproduce all git functionality, and nor should it: that's what the terminal access is for, for those kinds of advanced functions.

### Pageant / ssh

If you're using SourceTree, you'll probably use SSH integration. Setting up the SSL private and public keys can be done from SourceTree itself or by installing ssh. But it requires a SSH authentication agent program running. The SourceTree help mentions Pageant for a Windows environment and I've always used that for PuTTy authentication.

That covers software specifically for XPages development and source control. Next I'll cover the host of software used for work around and beyond Domino.