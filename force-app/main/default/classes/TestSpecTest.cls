@isTest
public class TestSpecTest {

    @isTest
    static void itShouldAssertWhenExpectedIsSetAfterActual(){
        TestSpec spec = new TestSpec();
        spec
            .unitUnderTest('classMethod()')
            .given('a nonsense condition')
            .itShould('do what\'s expected')
            .actual(2);
        Test.startTest();
        spec.expected(2);
        Test.stopTest();
        System.assertEquals(true, spec.assertionMade);
    }

    @isTest
    static void itShouldAssertWhenActualIsSetAfterExpected(){
        TestSpec spec = new TestSpec();
        spec
            .unitUnderTest('classMethod()')
            .given('a nonsense condition')
            .itShould('do what\'s expected')
            .expected(2);
        Test.startTest();
        spec.actual(2);
        Test.stopTest();
        System.assertEquals(true, spec.assertionMade);
    }

    @isTest
    static void itShouldBuildMessage(){
        TestSpec spec = new TestSpec();
        spec
            .unitUnderTest('classMethod()')
            .given('a nonsense condition')
            .itShould('do what\'s expected');
        Test.startTest();
        String actual = spec.buildMessage();
        Test.stopTest();
        System.assertEquals('classMethod(), given a nonsense condition should do what\'s expected', actual);
    }

    @isTest
    static void itShouldNotAllowedMultipleAsserts(){
        TestSpec spec = new TestSpec();
        spec
            .unitUnderTest('classMethod()')
            .given('a nonsense condition')
            .itShould('do what\'s expected')
            .expected(2)
            .actual(2);
        String exceptionType;
        Test.startTest();
        try{
            spec.expected(3);
        } catch(Exception ex){
            exceptionType = ex.getTypeName();
        }
        Test.stopTest();
        System.assertEquals('TestSpec.TestSpecException', exceptionType);
    }

    @isTest
    static void itShouldNotAllowSkippingDescription(){
        TestSpec spec = new TestSpec();
        spec
            .given('a nonsense condition')
            .itShould('do what\'s expected')
            .expected(2);
        String exceptionType;
        Test.startTest();
        try{
            spec.actual(2);
        } catch(Exception ex){
            exceptionType = ex.getTypeName();
        }
        Test.stopTest();
        System.assertEquals('TestSpec.TestSpecException', exceptionType);
    }

    @isTest
    static void itShouldNotAllowSkippingScenario(){
        TestSpec spec = new TestSpec();
        spec
            .unitUnderTest('classMethod()')
            .itShould('do what\'s expected')
            .expected(2);
        String exceptionType;
        Test.startTest();
        try{
            spec.actual(2);
        } catch(Exception ex){
            exceptionType = ex.getTypeName();
        }
        Test.stopTest();
        System.assertEquals('TestSpec.TestSpecException', exceptionType);
    }

    @isTest
    static void itShouldNotAllowSkippingExpectation(){
        TestSpec spec = new TestSpec();
        spec
            .unitUnderTest('classMethod()')
            .given('a nonsense condition')
            .expected(2);
        String exceptionType;
        Test.startTest();
        try{
            spec.actual(2);
        } catch(Exception ex){
            exceptionType = ex.getTypeName();
        }
        Test.stopTest();
        System.assertEquals('TestSpec.TestSpecException', exceptionType);
    }

    @isTest
    static void sanityCheckShouldAssertWhenExpectedIsSetAfterActual(){
        TestSpec spec = new TestSpec();
        TestSpec.SanityCheck sanityCheck = spec.sanityCheck('sanityCheck 1');
        sanityCheck.expected(2);
        Test.startTest();
        sanityCheck.actual(2);
        Test.stopTest();
        System.assertEquals(true, sanityCheck.assertionMade);
    }

    @isTest
    static void sanityCheckShouldAssertWhenActualIsSetAfterExpected(){
        TestSpec spec = new TestSpec();
        TestSpec.SanityCheck sanityCheck = spec.sanityCheck('sanityCheck 1');
        sanityCheck.actual(2);
        Test.startTest();
        sanityCheck.expected(2);
        Test.stopTest();
        System.assertEquals(true, sanityCheck.assertionMade);
    }

}