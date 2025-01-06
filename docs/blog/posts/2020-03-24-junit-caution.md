---
slug: junit-caution
date: 
  created: 2020-03-24
categories:
  - Java
tags: 
  - Java
links:
  - blog/2020-02-03-unit-tests-mocks.md
comments: true
---
# Lessons Learned from JUnit and Refactoring

JUnit testing just makes sense. But writing tests is certainly a skill and your tests can have a big impact on how you structure your code. Sometimes a sensible bit of refactoring can have a large impact, particularly if the code or unit tests were not written in the best way.

It is inevitable that some code will need to interact with a database, and that database will not be available when the unit tests run. There are multiple approaches for handling code that cannot run in a test.

<!-- more -->

## Mocking Methods

If the code is embedded within normal class methods or in utility classes, you can create create [mocks](./2020-02-03-unit-tests-mocks.md), where you will effectively create a placeholder for the class from your database's API and "hard-code" the output for specific methods. You're effectively skipping the code and specifying what you want to return. The code coverage looks good, but those lines have not actually been tested, you're only really testing the code around them. You need to run integration tests to ensure the real code works, running against the actual database.

## Mocking Classes

When writing your code, it's best to try to keep all code that interacts with a database self-contained. In the past, I've even used a database-specific package for that code, to isolate it even more and you may also have a specific class as an entry point. When it comes to testing, this means you can ignore a package from code coverage tests. But for writing the tests, it means you are likely to need to mock one of your own classes. The key thing to bear in mind here is that once you mock that class, any code in that class will not run. If it's a large class, this means a lot of code that cannot easily be tested.

## Extending Classes for Tests

If it's a small class with only a little database integration, you can extend it specifically within your test suite, which will allow you to test some methods. But this may require rewriting chunks of that class specifically so it can work for tests. You create an extended class and pass in the database-specific classes as arguments to the constructor or the method. Then in your tests, instead of passing in the actual objects, you pass in mocks. This allows you then to process some of that class and therefore get higher code coverage.

## Utility Class

The other option is to move the code to a utility class as a static method. The caveat here is that you cannot mock a static method. So you need to mock all the code within it. That can result in a lot of copying and pasting around your test classes.

## Refactoring

As you write you're code, you will inevitably have some code blocks or methods that are repeated or repeated with small differences. These are ripe candidates for refactoring. But it's important to think about your tests. Let's assume one of the key arguments passed is your database-integrating class. At this point, it's worth considering whether there's any point in unit testing the code you're refactoring.

If it is just making database calls, unit tests will all be false anyway. What you're wanting to test is the outcome of the method, which will affect the calling code:

- if you move it to a mocked class, you can mock the method as well, including success / failure. But you need to also need to refactor your tests. Do this before testing or before you've used the code block many times, and the refactoring of your tests will be minimal. Do it later, and you may have to make more significant changes. But the refactoring of your tests may result in cleaner code.
- if you move it to a class extended for testing or a utility class, you can pass in mocks and still have some control over outputting success / failure. In this scenario, you're less likely to need to make changes to your tests, but you may still have a lot of duplication in your tests.

If the code is doing more than just database calls and you want to test the actual code, then again you need to understand the impacts of mocks:

- if you move it to a mocked class, you can only mock the result of the method. You cannot process it.
- if you move it to a class extended for testing or a utility class, you can still run through it, ensuring it works as expected.

The other key factor for tests is where your mock classes are used outside individual tests. Anything used in `@BeforeAll` methods has to be static, anything used in `@BeforeEach` doesn't have to be. If your mock is static, the same instance is used across all tests. That's fine if you're always returning the same result for that mock's method calls, so if `MyMock.doFoo()` and all other `MyMock` methods should return the same. But if you want to change the mocked result for a method for an individual test, to simulate success / failure, then that mock will be applied also for subsequent tests that run. Because the tests are not run in a linear fashion, from top to bottom, you need to update the mock in all classes. In this case, it's best to avoid using the mock in `@BeforeAll` method and ensure it's not static. Then you can set your default behaviour in the `@BeforeEach` method and override it only where needed.

As ever, the best time to refactor is as early as possible. It will have the least impact and greatest affect.