---
slug: statistics-reporting
date: 2020-03-26
categories:
  - Domino
tags: 
  - Domino
  - Vert.x
  - Prometheus
  - Micrometer
comments: true
---
# Statistics Publishing and Reporting Part One

**Part One: Domino and Statistics**
[Part Two: Prometheus](./2020-03-30-statistics-for-prometheus.md)  
[Part Three: Micrometer and Prometheus](./2020-04-01-statistics-using-micrometer.md)  
[Part Four: Micrometer and Composite Registries](./2020-04-18-micrometer-composite-registries.md)

## Domino V10 and Statistics Publishing

One of the big additions in Domino V10 was statistics publishing, initially focused on [New Relic](https://newrelic.com/). But as [Daniel Nashed showed](http://blog.nashcom.de/nashcomblog.nsf/dx/domino-10-statistic-collection.htm) this can easily be re-routed to other locations, for example a Domino database. When I worked at [Intec](https://www.intec.co.uk/) I tried the New Relic reporting on Domino early on and was very impressed at what was provided. My response wasn't focused on what statistics were delivered - what is outputted is not the important factor, it can easily be change. My opinion came from how easy it was to set up. New Relic itself is straightforward, but what needed to be done on the Domino side was even easier - a few Notes.ini settings, restarting and the statistics flowed. Since the days of Embedded Experiences I have been convinced that ease of implementation is critical for adoption, and adoption is key to value for effort.

<!-- more -->

Getting the statistics is just one part and I'm not covering which tool is best in this blog post and subsequent. For that sort of topic, there is a [webinar](https://register.gotowebinar.com/register/7882842366917205516) this afternoon on the new partner for Domino statistics, Panopta. This blog post is about producing statistics, and the learning points from my experience.

## Prometheus

The code I picked up was not publishing to though was not New Relic, but [Prometheus](https://prometheus.io/). Prometheus seems to be developing quickly from an [article](https://devclass.com/2020/03/25/prometheus-lights-up-v2-17-0/) I read this morning, with v2.17.0 released barely a month after v2.16.0. As I did the development, a few things became clear following my experience with Domino and New Relic:

### Pull vs Push

New Relic expects statistics to be pushed to it. But Prometheus expects to poll an endpoint and receive the statistics. This is a significant difference in how the system generating the statistics needs to be architected. It doesn't necessarily preclude both occurring, but it is a key difference.

### Naming Conventions

The second difference is more profound - naming conventions for labels. If you use the sample database provided in [Daniel's blog post](http://blog.nashcom.de/nashcomblog.nsf/dx/domino-10-statistic-collection.htm) you'll see the statistics outputted from Domino have a dot notation format, e.g. `Domino.myserver.Domino.Requests.Per1Day.Peak` and `Domino.myserver.Domino.Requests.Per1Day.Total`.

However, Prometheus has a [very specific naming convention](https://prometheus.io/docs/practices/naming/). Instead of dots the separator is an underscore. There is a strict convention on units, which differs from what is outputted from the Domino statistics, and the suffix needs to reference this.

### Tags and Buckets

Comparing an existing output for Prometheus, labels had tags in brackets afterwards. The tags were key-value pairs. Statistics for durations were also aggregated into buckets based on length of time spent. So for duration of an HTTP request, for example, buckets might be for 0.1 seconds, 0.3 seconds, 0.5 seconds etc. So if a request took 0.5 seconds, only the 0.5 seconds bucket got incremented; if it took 0.2 seconds, the buckets for 0.3 and 0.5 got incremented; if it took 0.1 seconds, all buckets got incremented.

In the next blog post, I'll cover my initial coding approach.