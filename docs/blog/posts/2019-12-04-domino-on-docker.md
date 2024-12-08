---
slug: domino-on-docker
date: 
  created: 2019-12-04
category: Domino
tags: 
  - Domino
  - Docker
comments: true
---
# Domino on Docker - Some Learning Points

About a year ago I did a blog post on Domino on Docker, with the intention to follow it up on developing against that Domino Docker server via Notes Client and integrating with it from other Docker containers or outside of Docker. Unfortunately other things got in the way, and it then got put on hold pending the work Thomas Hampel and Daniel Nashed were doing on the [IBM repository](https://github.com/IBM/domino-docker) for Domino on Docker and Roberto Boccadoro's Domino on Docker guide posted on [OpenNTF's wiki guides site](https://wiki.openntf.org/display/OPH/Community+Guides).

<!-- more -->

Particularly the IBM repository means that the steps involved in setting up Domino on Docker are very different. A goal for that repository was to auto-manage a lot of the configuration of Domino and some of Daniel's excellent scripts have covered aspects of that. The effort to make a short, brief installation of a Domino server is undermined if developers and administrators - particularly non-Domino technicians - have to then connect with Domino Administrator and configure the server before it's ready for development or learning. Thomas and Daniel have lots of ideas for that and I wanted to get involved, but unfortunately I was not able to find the time.

The good news is that Domino on Docker is not really different to any other Domino server. In my video I changed the ports from the standard ones, because I already had a Domino server on my PC and didn't want to conflict. If that's not the case, you can just use the standard ports 80/443 and 1352.

However, one thing to bear in mind is that Domino generates certificates that the Notes Client stores and uses to verify the server. It also creates a connection document for the relevant IP address and Domino server name. This means that if you have multiple Domino on Docker servers, all using the same ports, the connection documents will all be pointing to the same place. But two Docker server registered as MyServer1/MyOrg and MyServer2/MyOrg will have different certificates associated. As a result, Notes may generate a warning. That's not a problem for development or training purposes, you just have to realise that's why the warning is being triggered and it's not anything you have to do anything about. Naming them both MyServer1/MyOrg won't help, because even though the Notes name is the same, the certificates will be different. And it's this which is checked to verify authenticity.

One very good use case for Domino on Docker is testing multiple versions. If you're storing the data directory locally and re-using it for the different Domino on Docker servers, that's going to be fine as long as you don't upgrade the names.nsf and other core databases. If you do, you may have problems when using a previous Domino Docker version. Alternatively, if you use a Docker volume for the data directory, you can clone it using [this useful utility](https://www.guidodiepen.nl/2016/05/cloning-docker-data-volumes/). That means you can have an exact copy of the data directory and notes.ini etc, ready to test and verify functionality. You can be certain that the only difference is the Domino version. This is also a good use case for test servers, deleting and recreating the data volume from a backup clone, so you always have your starting data and databases.

As I mentioned, you can alternatively store your data outside of Docker. However, there are differences between different operating systems for the command needed to run.

- For Linux and MacOS, `-v ${pwd}:/data` would map the current working directory the command is running in, mapping it to the "/data" folder within the container that gets created. (So for Domino, you want "/notesdata". For Node-RED "/data").
- For Windows cmd prompt, you use `-v %cd%:/data`.
- For Windows Powershell, you use `-v ${PWD}:/data`.
This took me quite a while and searching a few times to find the right syntax for Windows. On Windows you will need to do the other steps in the Docker documentation to provide Docker with your Windows credentials to interact with your filesystem.

Another bit of advice from personal experience, if you start using Docker a lot you will soon have a number of images, volumes and containers (as I did by the time I was presenting at Engage). I'd recommend keeping documentation of what the images, volumes and containers are, versions in use and what you use them for. It's very easy to get lose track which makes housekeeping more challenging.

It's also worth bearing in mind that, if you build images, if an image is deleted the containers using that image lose their name and get a hex string as the name instead. Similarly, when you're building an image, it will build intermediate containers during the process and those intermediate containers are also created with a hex string as the name. So it's very easy to get confused between the two - again a benefit of regular housekeeping and documentation.