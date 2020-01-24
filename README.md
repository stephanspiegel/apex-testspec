# TestSpec for Apex

Inspired by [Eric Elliott](https://twitter.com/_ericelliott)'s [RITEway](https://github.com/ericelliott/riteway).

How good are your unit tests? You won't know until they fail. A passing unit test only tells you "all is well." A failing unit test has the potential to tell you exactly what went wrong and how to fix it, but it takes discipline to write your tests to achieve that!

Built-in Assert methods in Apex -- `System.assert()`, `System.assertEquals()` and `System.assertNotEquals()` -- have the following downsides:

* The message argument is optional.
* System.assert() by itself offers little context about the failure, just that the assertion failed.
* System.assertEquals(expected, actual) requires you to remember the order of the arguments -- "does `expected` come first, or was it `actual`?"

The [RITEway](https://github.com/ericelliott/riteway) testing framework for Javascript encourages you to write unit tests that answer the following questions:

1. What is the unit under test?
2. What should it do?
3. What was the actual output?
4. What was the expected output?
5. How do you reproduce the failure?

Using answers to these questions, it produces test failure messages that read like bug reports. It also lays out the unit test code in a consistent way that allows the reader of the code to quickly answer the five questions above. 

TestSpec is my attempt to create something similar for Apex.

## Usage

```apex
public class NumberAdder {

    public static Integer addTwoNumbers(Integer a, Integer b){
        return a-b; //bug: subtracting instead of adding
    }
}


@isTest
private class NumberAdderTest {

    @isTest
    private static void adding2And5ShouldReturn7(){
        new TestSpec()
            .unitUnderTest('NumberAdder.addTwoNumbers()')
            .given('the numbers 2 and 5')
            .itShould('return 7')
            .expected(7)
            .actual(NumberAdder.addTwoNumbers(2,5));
    }
}

```
will produce the test failure message:
```
System.AssertException: Assertion Failed: NumberAdder.addTwoNumbers(), given the numbers 2 and 5 should return 7: Expected: 7, Actual: -3
```

The methods `unitUnderTest()`, `given()` and `itShould()` must be invoked before `expected()` and `actual()` can be called. Once both `expected()` and `actual()` have been called, TestSpec calls `System.AssertEquals()` to complete the unit test.

### Sanity Checks

By design, `unitUnderTest()`, `given()`, `itShould()`, `expected()` and `actual()` all can only be called a single time for a given instance of TestSpec. A good unit test should test one thing only.
Occasionally though it makes sense to guard against failure conditions that may cause the test to fail, but aren't part of the test itself. For example, the number of records in the database may change, but the logic of the code under tests doesn't directly depend on it. In these circumstances, use a sanity check.

A (very contrived) example:

```apex

@isTest
private class NumberAdderTest {

    @isTest
    private static void adding10ToNumberOfUsersShouldReturn15(){
        TestSpec spec = new TestSpec();
            spec.unitUnderTest('NumberAdder.addTwoNumbers()')
                .given('the number of users and 10')
                .itShould('return 15');
            Integer numberOfUsers = [SELECT count() FROM User];
            TestSpec.SanityCheck userCheck = spec.sanityCheck('number of users');
            userCheck.expected(5)
                .actual(numberOfUsers);
            spec.expected(15)
                .actual(NumberAdder.addTwoNumbers(numberOfUsers, 10));
    }
}
```
If the number of users is actually 6 instead of 5, this test will fail with the following message:
```
Assertion Failed: [Sanity check failed] Number of users: Expected: 5, Actual: 6
```

A TestSpec instance can create any number of sanity checks.

## Limitations

Because TestSpec calls `System.assertEquals()` outside of the actual unit test itself, static code analysis tools like [pmd](https://pmd.github.io/pmd/index.html) or [CheckMarx](https://www.checkmarx.com/) will complain that the test doesn't contain asserts.

