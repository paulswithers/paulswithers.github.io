---
slug: docker-java
date: 2021-12-12
categories:
  - Java
tags: 
  - Java
  - Docker
  - Containers
comments: true
---
# Docker, Java and Processes

Whether it's Docker or Kubernetes (or some flavour thereof), running microservices in containers is a powerful option. It can make it easy to deploy development or test systems, ensuring consistency across your development team. But when you move from consuming to building, particularly when you're building less out-of-the-box containers, there are some deeper elements that you need to be aware of.

<!-- more -->

## CMD vs ENTRYPOINT

At the end of your Dockerfile, there will be a command for how to start the container. There are two options here:

- `CMD` followed by a command to run and parameters to pass to it.
- `ENTRYPOINT` passing a file to run using the default shell.

For those who are not Linux masters, it's important to bear in mind that the default shell differs for different Linux base images. If your starting image is Ubuntu, the default is dash (Debian Almquist Shell) and possibly also in Debian. This may have unexpected consequences. If bash is in use on all base images you're using, it may be preferable to use `CMD ["/bin/bash", "myfile.sh"]`.

There is a more significant point with regard to how the Java program runs and how stopping the container interacts with it.

| How Started          | Process / Sub-Process | SIGTERM Received By |
| ----------------- | -------------| ------------- |
|ENTRYPOINT, `java -jar` | Sub-Process  | Shell process |
|ENTRYPOINT, `exec java -jar` | Process | Java JVM |
|CMD ["/bin/bash"], `java -jar` | Sub-Process | bash |
|CMD ["/bin/bash"], `exec java -jar`| Process | Java JVM |
|CMD ["java"] | Process | Java JVM |
|Google Jib image | Process | Java JVM |
|Lightweight init system, e.g. "dumb-init" | Process | Java JVM |

Again for those who are not Linux experts, in the entrypoint, `java -jar myJar &` will ensure the stdout goes to the container log. If switching to `exec java -jar` you need to remove the `&` at the end.

If the Java JVM is running as a sub-process, by default it will not receive the SIGTERM signal that shuts down the container or other signal. So if you want to shut down your Java program gracefully, the shell script needs to pass on the signal. There are various ways to do that, and the right way may depend on Java program.

If the Java program is the main process, it will receive the SIGTERM signal. You can catch that by adding a `Runtime.getRuntime().addShutdownHook()` and action accordingly. This, for example, is how Vertx catches the SIGTERM signal and calls the `stop()` method of each verticle to gracefully shut them down.

You may want to confirm which processes are running in the container and which is the main process. I found [this StackOverflow question](https://stackoverflow.com/questions/34878808/finding-docker-container-processes-from-host-point-of-view) which gave the answers: `docker <container id> top` lists all processes, and `docker inspect -f '{{.State.Pid}}' <container id>` gives the main process.

## Java As The Sub Process

However, there are scenarios where, even though Java is the main process and a shutdown hook has been added via `Runtime.getRuntime().addShutdownHook()`, it doesn't trigger. I had this recently and, although I was able to identify the code that caused this, I wasn't able to completely understand why. The symptom was that no output was printed from the `stop()` method of Vertx verticles and a SIGKILL was sent to the container, killing the JVM. The status for the Docker container shutting down was 137, which means the SIGKILL was sent. If the container was created with `stop-timeout=-1`, to set no timeout when sending the SIGTERM, and so never send the SIGKILL, the container could not be stopped.

In this scenario, to get around the problem of the shutdown hook not working, the solution was to _not_ run the Java program as the main process.

Then the shell script needs to remain running, trap the SIGTERM, and shut down the Java program. [Daniel Nashed's Docker entrypoint script](https://github.com/IBM/domino-docker/blob/master/start_script/domino_docker_entrypoint.sh) for Domino gives a good example of how to do those first two points. The first part is the loop at line 120:

```sh
while true
do
  sleep 1
done

exit 0
```

This triggers an infinite loop at the end of the shell script. The final line's `exit 0` never gets reached.

The second part - catching the SIGTERM - is covered at line 64, `trap "stop_server" 1 2 3 4 6 9 13 15 19 23`. The `trap` command receives a function name to trigger when the signals are trapped ("stop_server"), and a list of signals to trap. This catches a variety of signals and (thanks to Daniel for the information) these are listed in a table halfway down the [man page on signals](https://man7.org/linux/man-pages/man7/signal.7.html). The key ones is 15 (SIGTERM).

The "stop_server" function is at line 44. Any `echo` commands will also print to the container's log, so you can verify that your function has triggered. Once you have shut down your Java program - that will depend on your Java code - calling `exit 0` will cleanly shut down the container.

## Summary

It took me quite some time to troubleshoot and understand all of this. But it has given me a much deeper understanding of containers, which I'm sure will be important for the future.
