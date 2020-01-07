public with sharing class TestSpec {
    
    private String description, scenario, expectation;
    private Object expected, actual;

    @testVisible
    private Boolean assertionMade = false;

    public TestSpec unitUnderTest(String description){
        this.description = description;
        return this;
    }

    public TestSpec given(String scenario){
        this.scenario = scenario;
        return this;
    }

    public TestSpec itShould(String expectation){
        this.expectation = expectation;
        return this;
    }

    public TestSpec expected(Object expected){
        this.expected = expected;
        if(actual != null){
            assert();
        }
        return this;
    }

    public TestSpec actual(Object actual){
        this.actual = actual;
        if(expected != null){
            assert();
        }
        return this;
    }

    private void assert(){
        if(assertionMade){
            throw new TestSpecException('Only one assertion can be made per TestSpec instance');
        }
        System.assertEquals(this.expected, this.actual, buildMessage());
        assertionMade = true;
    }

    @testVisible
    private String buildMessage(){
        if(description == null){
            throw new TestSpecException('call unitUnderTest() before trying to assert');
        }
        if(scenario == null){
            throw new TestSpecException('call given() before trying to assert');
        }
        if(expectation == null){
            throw new TestSpecException('call itShould() before trying to assert');
        }
        return description + ', given ' + scenario + ' should ' + expectation;
    }

    public SanityCheck sanityCheck(String assumption){
        return new SanityCheck(assumption);
    }
         
    public class SanityCheck {

        private Object expected, actual;
        private String assumption;
        @testVisible
        private Boolean assertionMade;

        public SanityCheck(String assumption){
            this.assumption = assumption;
        }

        public SanityCheck expected(Object expected){
            this.expected = expected;
            if(actual != null){
                assert();
            }
            return this;
        }

        public SanityCheck actual(Object actual){
            this.actual = actual;
            if(expected != null){
                assert();
            }
            return this;
        }

        private void assert(){
            assertionMade = true;
            System.assertEquals(expected, actual, buildMessage());
        }

        private String buildMessage(){
            return '[Sanity check failed] ' + assumption;
        }

    }

    public class TestSpecException extends Exception {}

}