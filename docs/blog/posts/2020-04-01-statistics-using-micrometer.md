---
slug: statistics-using-micrometer
date: 
  created: 2020-04-01
categories:
  - Vert.x
tags: 
  - Vert.x
  - Micrometer
  - Prometheus
links:
  - blog/2020-03-26-statistics-reporting.md
  - blog/2020-03-30-statistics-for-prometheus.md
  - blog/2020-04-18-micrometer-composite-registries.md
comments: true
---
# Statistics Publishing and Reporting Part Three: Using Micrometer

[Part One: Domino and Statistics](./2020-03-26-statistics-reporting.md)  
[Part Two: Prometheus](./2020-03-30-statistics-for-prometheus.md)  
**Part Three: Micrometer and Prometheus**
[Part Four: Micrometer and Composite Registries](./2020-04-18-micrometer-composite-registries.md)

## The Easy Way

In the previous two parts I gave some background on metrics and then described my first pass at coding metrics, quite frankly the hard way. The [elephant in the room](https://en.wikipedia.org/wiki/Elephant_in_the_room) should be apparent: the metrics output was manually coded for a specific reporting tool.

<!-- more -->

The solution to that problem, in Java, is [Micrometer](https://micrometer.io/), a vendor-neutral metrics facade. This is what [Vert.x](https://vertx.io/docs/vertx-micrometer-metrics/java/) uses to manage the metrics and how it outputs out-of-the-box for Prometheus, InfluxDB and JMX. But of course because they're just hooking Vert.x into standard Micrometer, metrics can also be provided for any other backend that Micrometer supports, e.g. [Graphite](http://micrometer.io/docs/registry/graphite), [Elasticsearch](http://micrometer.io/docs/registry/elastic), [New Relic](http://micrometer.io/docs/registry/new-relic) and [many others](http://micrometer.io/docs).

The benefits of this should be obvious. You're offloading all the hard work of integrating with multiple metrics backends to someone else. And Micrometer is [open source](https://github.com/micrometer-metrics/micrometer), so you can see the code for yourself and, if you should identify a problem, work out the fix and submit a pull request. It also means additional metrics backends can be coded, if required, and added to the registry. By using a [CompositeMeterRegistry](https://vertx.io/docs/vertx-micrometer-metrics/java/#_other_backends_or_combinations) your Vert.x can output to multiple.

## Why Recode Now?

My initial plan was to revisit the metrics in a later phase and recode them. But after some more investigation it became apparent that Micrometer handles buckets for histograms automatically, handles creating summaries for them etc. So the output would undoubtedly be different to what I had already coded.

Obviously this would invalidate any effort on producing reporting graphs.

The right approach was to recode now.

## Meters and Registration

When coding manually I had created ConcurrentHashMaps. With Micrometer the approach is to create [Meters](https://micrometer.io/docs/concepts#_meters) and add them to the registry. `BackendRegistries.getDefaultNow()` provides a simple method to get the registry that should have previously been added when your application starts.

There are different types of Meters. The ones relevant to what I was doing were:

- [Timer](https://micrometer.io/docs/concepts#_timers) to record how long something took.
- [Counter](https://micrometer.io/docs/concepts#_counters) for number of times something is called. Note, this is used for something that can only increment.
- [Gauge](https://micrometer.io/docs/concepts#_gauges) for a numerical result that can go up or down, used to get the current number.

The Metrics are created with a **name** and one or more **tags**. The tags are key-value pairs, so let's compare that with the code I was outputting:

```java
databaseHandlerCounts.forEach((k, v) -> {
	sb.append("\nkeep_database_handler_total{class=" + k + ",} " + v);
});
```

Here the name of the metric is "keep_database_handler_total". The tag was what was in the curly braces - the key was "class" and the value the Java class name. The benefit over the approach I had becomes immediately apparent, it's much easier to use multiple tags, e.g. class the metric is triggered from, database being interrogated etc.

There seem to be multiple approaches available for creating metrics.

- The [Meter base class](https://javadoc.io/doc/io.micrometer/micrometer-core/1.4.0/io/micrometer/core/instrument/Meter.html) has a static `builder()` method to create an instance of the Meter. Here you register the meter to a registry.
- There is a [Metrics class](https://javadoc.io/doc/io.micrometer/micrometer-core/1.4.0/io/micrometer/core/instrument/Metrics.html) with static methods to create different meters. This is what I first came across in the Micrometer documentation. `Metrics.addRegistry()` seems to be key here for enabling the counter for output.
- There is a method on the [Meter Registry](https://javadoc.io/doc/io.micrometer/micrometer-core/1.4.0/io/micrometer/core/instrument/MeterRegistry.html) to create an instance of a Meter.

The important point here is that a meter can only be registered with a given name and tags once. An error will be thrown if you try to register a duplicate meter. This also means you want to have all the tags available before you first register it. The key then is registering it once and then retrieving the meter for subsequent calls to use.

When it comes to outputting the results, the beauty of this approach is the simplicity: `PrometheusScrapingHandler.create()` creates a Vert.x route handler that writes out all metrics using the default metrics registry we've been creating metrics on. The method for enabling outputting for other registries will differ, but is beyond the scope of this blog post.