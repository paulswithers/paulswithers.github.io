---
slug: micrometer-composite-registries
date: 2020-04-18
categories:
  - Vert.x
tags: 
  - Vert.x
  - Micrometer
  - Prometheus
comments: true
---
# Statistics Publishing and Reporting Part Four: Auto-Configuration and Composite Registries

[Part One: Domino and Statistics](./2020-03-26-statistics-reporting.md)  
[Part Two: Prometheus](./2020-03-30-statistics-for-prometheus.md)
[Part Three: Micrometer and Prometheus](./2020-04-01-statistics-using-micrometer.md)
**Part Four: Micrometer and Composite Registries**

## Easier Endpoints for Single Backends

In the last part I covered outputting metrics. If you have an existing HTTP server or wish to create a standalone server, it's easy to output the metrics, as shown on the [Vert.x samples](https://github.com/vert-x3/vertx-micrometer-metrics/blob/master/src/main/java/examples/MicrometerMetricsExamples.java#L104):

<!-- more -->

```java
Router router = Router.router(vertx);
router.route("/metrics").handler(PrometheusScrapingHandler.create());
vertx.createHttpServer().requestHandler(router).listen(8080);
```

But even easier is the use of an embedded server. The caveat here is that the embedded server can only be used if you're outputting to a single backend - Prometheus, InfluxDB or JMX. If you only have a single backend, you can set the [configuration options](https://vertx.io/docs/vertx-micrometer-metrics/java/#_configuration_examples_2) and it will automatically start a single registry for the relevant backend. So for Prometheus, the example in the documentation is:

```java
Vertx vertx = Vertx.vertx(new VertxOptions().setMetricsOptions(
  new MicrometerMetricsOptions()
    .setPrometheusOptions(new VertxPrometheusOptions().setEnabled(true))
    .setEnabled(true)));
```

There is a similar `set....Option()` method for InfluxDB and JMX. The actual options for the embedded server can be set via JSON configuration or Java methods of the [VertxPrometheusOptions class](https://github.com/vert-x3/vertx-micrometer-metrics/blob/master/src/main/java/io/vertx/micrometer/VertxPrometheusOptions.java). If you want to use a JSON configuration, the Prometheus-specific options are built using a JSON object like this:

```json
{
  "embeddedServerEndpoint" : "/metrics",
  "enabled" : true,
  "publishQuantiles" : true,
  "startEmbeddedServer" : true
}
```

This defines an **endpoint** for the embedded server, which is automatically started because `startEmbeddedServer` is set to `true`. `publishQuantiles` tells it to output histogram data. There is a constructor `public VertxPrometheusOptions(JsonObject json)` which will take that JSON object and set the properties accordingly. But you also need to define the embedded server's settings - whether to use SSL, which HTTP port etc. This is done by calling `setEmbeddedServerOptions()`, passing in an `HttpServerOptions` object, as you would for any other Vert.x HTTP server.

## Composite Registries

However, the embedded server and VertxPrometheusOptions will only work if you _only_ want to publish stats for Prometheus. As I mentioned, this auto-creates a registry. There is a method `MicrometerMetricsOptions.setMicrometerRegistry()` to pass in a registry, which you need to do if you want a composite registry for multiple backends. But as the Javadoc confirms, you can _either_ add options for Prometheus / InfluxDB / JMX _or_ you can set a registry - you cannot use `VertxPrometheusOptions` if you want a composite registry.

As I mentioned in the last part, there are two strengths for Micrometer:

1. It makes it easier to get the correct format for a specific backend.
2. The `CompositeMeterRegistry` means you can output the same metrics for multiple backends.

If you've got a very specialised implementation and only want to support a single backend, the embedded server makes that very easy. If people want to use other backends, you place the onus on third-party manipulations. That's presumably what Panopta's Domino agent does, if I understood the [webinar](https://register.gotowebinar.com/register/7882842366917205516) at the end of last month correctly. Similarly, if you would want to report on Domino's statistics on Prometheus, for example, you would also need to write custom code to convert the statistics yourself - because they're hierarchical, not dimensional; because Prometheus pulls, doesn't receive a push.

But offering freedom of choice and making it easier for consumers is always good, and Micrometer allows you to do that. There are (at least) two key changes.

### Create And Seed CompositeMeterRegistry

The first is you need to create a `CompositeMeterRegistry` and use `MicrometerMetricsOptions.setMicrometerRegistry()` to load it. You can then add the various registries you wish to support with `CompositeMeterRegistry.add()`. The [Micrometer documentation](https://micrometer.io/docs) will give you the relevant Maven settings and code needed to add the registry, e.g.

```java
PrometheusMeterRegistry prometheusRegistry = new PrometheusMeterRegistry(PrometheusConfig.DEFAULT);
```

In the last part, when creating meters I used `BackendRegistries.getDefaultNow()` to get the registry. The same method will then get the `CompositeMeterRegistry` you created. The good news is that if you just add Counters and Timers to the composite registry, then when you scrape the statistics later, you still get them.

### Outputting Statistics

The second change you need is to write the code for the server endpoint (if it's pull) or client (if it's push). The `PrometheusScrapingHandler()` won't work here, because the registry in use is a CompositeMeterRegistry, not a PrometheusMeterRegistry. Instead, you'll need to scrape from the relevant registry:

```java
final HttpServerResponse response = routingContext.response();
BackendRegistries.getDefaultNow().getRegistries().forEach(registry -> {
    if (registry instanceof PrometheusMeterRegistry){
        PrometheusMeterRegistry promRegistry = (PrometheusMeterRegistry) registry;
        response.putHeader(HttpHeaders.CONTENT_TYPE, TextFormat.CONTENT_TYPE_004)
        .end(promRegistry.scrape());
    }
});
```

### Histograms

As I mentioned, adding Counters and Timers to the composite registry means those statistics get outputted. However, histogram data doesn't. There isn't an obvious setting on `PrometheusConfig` to enable it, though the `HistogramFlavor` seems to be relevant. There isn't a specific option when scraping. The `PrometheusDistributionSummary` seems to be key. It may be necessary to create Timers on the PrometheusMeterRegistry rather than the CompositeMeterRegistry, I'm not sure. More trial-and-error investigation would be necessary to confirm.