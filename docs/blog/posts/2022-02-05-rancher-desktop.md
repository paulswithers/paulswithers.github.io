---
slug: rancher-desktop
date: 2022-02-05
categories:
  - Docker
tags: 
  - Docker
  - Containers
comments: true
---
# Rancher Desktop, A New Dev Tool

Docker has been a significant development tool for me for some time. The ease of spinning up a clean, standalone development environment for applications is a great benefit. The ability to switch seamlessly between different versions is a big benefit when testing. Another benefit is the ability to create demo environments for conference sessions and share them via GitHub for others to easily deploy samples.

But when Docker announced new licensing terms last year, it shook up the desktop development landscape. Rancher, who have a long history of expertise with Kubernetes, stepped into the desktop game by announcing [Rancher Desktop](https://rancherdesktop.io/). I was aware of the open source project last year, but when [Daniel Nashed](https://blog.nashcom.de/) pointed out to me that 1.0 had recently been released, I decided it was time to give it a try.

<!-- more -->

First it's worth giving a little background on my experience of containerisation. I've had virtually no exposure to Kubernetes on desktop or production. My knowledge of Kubernetes in a DevOps environment is probably less than my knowledge of kubernetes in the classical world, being the [first declension Greek noun for a helmsman](https://en.wiktionary.org/wiki/%CE%BA%CF%85%CE%B2%CE%B5%CF%81%CE%BD%CE%AE%CF%84%CE%B7%CF%82) which was adopted and modified in Latin as the [noun gubernator](https://en.wiktionary.org/wiki/gubernator). I've used Docker for a number of years. Initially I did a lot of work via command line, both building containers and images, heavily using volumes and networks, and writing dockerfiles. More recently, most of my work with Docker containers has been via the excellent VS Code plugin. Although I still use command line for creating containers and connecting a shell as root user, most of my interaction is via the VS Code menus and so my Docker CLI fu has slipped a little.

Rancher Desktop is available for all operating systems - Mac (both Intel and Silicon), Windows and Linux. For those running Kubernetes in production and wanting to mimic their production environments, the ability to choose the Kubernetes version running will be a big advantage. The lay developer will probably not change from the default. The big decision comes on the container runtime - containerd or dockerd. Developers like me who have never used Kubernetes may be lost here. The good news is you can switch between the two.

If you are used to Docker, don't have to worry about deployment to Kubernetes environments and don't want to step outside your comfort zone, then dockerd will be the go-to choice. This allows you to use the docker commands on the command line that you're used to. I believe you can also use Docker Compose, though I've not tried that yet. Those who use the Domino Docker image will find this very essential, though I have no doubt that the community project will expand its scope to use helm in the future as well. Even better, the Docker plugin for VS Code works seamlessly with it. This is not too surprising when you realise that it's using [Moby](https://mobyproject.org/), the open source framework from Docker for containerisation.

There are a couple of caveats here. The first is that Rancher Desktop can only create bind mounts to directories in your Users directory on Mac. If you try to create a bind mount to another location (I have files on an external SSD), it will create the mapping, but the container will not see any of the files. Creating a symlink may work, but I had already moved the files. The other caveat is that uninstalling Docker Desktop on Mac did not remove the symlinks in /usr/local/bin, which means Rancher Desktop could not initially be set as the source for usr/bin/docker. However, that was resolved by manually removing all remaining symlinks to Docker in usr/local/bin.

If you are likely to have to deal with containers in production, you should probably use this as an opportunity to get experienced with running containerd and nerdctl / helm. At this point I must emphasise that I'm not experienced with them, but it's definitely on my development roadmap. Once you switch the container runtime to containerd then docker commands are no longer available and the Docker plugin for VS Code will not work.

Instead of docker on the command line, you can use [nerdctl](https://github.com/containerd/nerdctl), the Docker-compatible CLI for containerd. This will probably be the initial starting point for those coming from Docker Desktop and switching to containerd. According to the documentation nerdctl also supports Docker Compose, although again I've not tried that yet. On the whole, for every command that you would previously have prefixed with `docker`, you can prefix with `nerdctl`. However, it's worth bearing in mind that some flags are not supported. For those coming from the Domino world, one big flag that will not work is `stop-timeout`. Another key point to be aware of is that if you start a container using `nerdctl run -it ...`, you cannot shut it down and subsequently restart it. In this scenario, the approach I found recommended and which worked for me was to use `nerdctl run -d ...`.

As mentioned, you can quickly switch between dockerd and containerd as the container runtime. But bear in mind that the images and containers you create with one runtime won't be available when you switch to the other.

It's worth bearing in mind that Rancher Desktop is still very new. It was only started late last year. Documentation is an area that will be improved over coming months. But the community is very active, with a Slack channel available and issues already regularly being created. The demand is certainly there for Rancher Desktop and the use of Moby means dockerd is a first class citizen. But, as mentioned previously, it is certainly a good time to build your skills on containerd and helm.
