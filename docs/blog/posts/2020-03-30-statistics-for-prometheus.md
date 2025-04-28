---
slug: statistics-for-prometheus
date: 2020-03-30
categories:
  - Vert.x
tags: 
  - Vert.x
  - Micrometer
  - Prometheus
comments: true
---
# Statistics Publishing and Reporting Part Two: Statistics for Prometheus

[Part One: Domino and Statistics](./2020-03-26-statistics-reporting.md)  
**Part Two: Prometheus**
[Part Three: Micrometer and Prometheus](./2020-04-01-statistics-using-micrometer.md)  
[Part Four: Micrometer and Composite Registries](./2020-04-18-micrometer-composite-registries.md)

In the last blog post I covered the differences between different statistical reporting tools. I can't speak for Panopta covered in the recent HCL [webinar](https://register.gotowebinar.com/register/7882842366917205516). I suspect they're using "pull" (they install an agent on the Domino server) and I suspect they're using one of the traditional reporting databases (their monitoring covers time periods, so there must be a database; and their offering is based around pre-built dashboards for various products, so no necessity for their USP to build their own reporting repository).

<!-- more -->

But my comparators were the Domino statistics and the out-of-the-box statistics for Prometheus from Vert.x. This highlighted some significant differences in what was built:

1. Prometheus naming convention used underscores, Domino's stats were provided with dot notation.
2. Vert.x stats for Prometheus were dimensional, Domino stats were not. By this I mean the Prometheus stats had a name followed by tags in curly brackets. For example, `vertx_http_server_responseTime_seconds_count{code="200",method="POST",} 1.0`, where the tags are the HTTP  ("POST") and HTTP response code ("200"). The tags then allow slicing and dicing the data in different ways. In contrast, the Domino stats didn't include tags, just a descriptor string (e.g. `Domino.myserver.Database.DbCache.CurrentEntries 7`).
3. Prometheus has a standard set of units always used - seconds and bytes. However, Domino's stats output a variety of different units (`Domino.myserver.Mem.Local.Max.AllocFromOS_KB`, `Domino.myserver.Mem.MaxSharedMemory_MB`, `Domino.myserver.Server.ElapsedTimeDays`, `Domino.myserver.Server.ElapsedTimeMinutes`).
4. Prometheus stats included buckets for histogram reporting. This is the "le" tag in `vertx_http_server_responseTime_seconds_bucket{code="200",method="POST",le="0.001",} 0.0`. So this bucket is for HTTP 200 responses for a POST request completing in less than 0.001 seconds.

Pull or push is actually not an issue with Vert.x. Creating another HTTP server endpoint mapping to a method is easy. And Vert.x can also handle creating an HTTP client, to perform a push. But for Vert.x, it was a pull.

## Collector

The stats needed to be incremented as anything was happening. But we needed somewhere to store them, so a [singleton enum](https://wissel.net/blog/2020/01/unit-tests-and-singletons.html). Within that singleton, we needed maps to hold the various statistics. When it comes to maps in a singleton that will be updated, concurrent access is a key requirement. And for that my go-to options are [ConcurrentHashMap](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html) and [AtomicInteger](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicInteger.html) or in this case AtomicDouble for when a single value is needed.

### Seeding the Maps

The first step was to add a method to load the relevant key into appropriate maps. In Vert.x, we create [handlers](https://vertx.io/docs/vertx-core/java/#_don_t_call_us_we_ll_call_you) to respond to HTTP requests and [Verticles](https://vertx.io/docs/vertx-core/java/#_verticles) to perform database-facing code. So when setting up each of these, I initialised the map with a 0.0 value (e.g. `databaseHandlerCounts.put(classNameForPrometheus, 0.0);`). I converted the dot notation of the class name to underscores with single string substitution - `StringUtils.replace(className, ".", "_")`.

### Incrementing the Maps

The second step was to increment the value each time there was a call. With Java 8 the code for that becomes more succinct:

```java
databaseHandlerCounts.merge(classNameForPrometheus, 1.0, (a,b) -> a+b);
```

The `merge()` method replaces the need for separate `get()` and `put()` calls. The first parameter (`classNameForPrometheus`) is the key to look for. The second parameter (`1.0`) is what is being merged in, and so becomes the value of `b` in what follows. And the third parameter is a lambda function for how to merge the values. `a` is the old value, `b` is the value being merged in. So we just need to add them.

### Buckets

Handling buckets for a histogram got more complicated. That's because you need to increment the lowest bucket the duration fits in, and all higher buckets. For that I used an `if` statement where I compared the duration to a bucket's maximum and returned an integer - bucket 1 as 1, bucket 2 as 2 etc. I then used a switch statement _without a break_ to increment each bucket, so that it incremented not only the matching bucket, but all subsequent. E.g.:

```java
if (duration.compareTo(0.1) <= 0) {
	le = 1;
} else if (duration.compareTo(0.3) <= 0) {
	le = 2;
} else if (duration.compareTo(0.5) <= 0) {
	le = 3;
}

switch (le) {
	case 1:
		databaseHandlerDurationBuckets.merge(0.1, 1.0, (a,b) -> a+b);
	case 2:
		databaseHandlerDurationBuckets.merge(0.3, 1.0, (a,b) -> a+b);
	case 3:
		databaseHandlerDurationBuckets.merge(0.5, 1.0, (a,b) -> a+b);
}
```

### Outputting the values

I then just needed a method to output the statistics when called by Prometheus. Again by comparing the output from Vert.x, it was clear that each unique label was preceded by `HELP` and `TYPE` comments, presumably for the relevant UI. So for a given map, this resulted in the following code being added to a StringBuilder:

```java
sb.append("\n# HELP keep_database_handler_total Number of messages processed per database handler");
sb.append("\n# TYPE keep_database_handler_total counter");
databaseHandlerCounts.forEach((k, v) -> {
	sb.append("\nkeep_database_handler_total{class=" + k + ",} " + v);
});
```

This worked well. But in part three, the last part, I'll show how I took a much better-practice approach.