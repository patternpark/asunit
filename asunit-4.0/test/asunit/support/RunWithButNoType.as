package asunit.support {
    
    import asunit.asserts.*;

    [RunWith]
    public class RunWithButNoType {

        [Test]
        public function simplePassing():void {
            assertTrue("This will pass, we're interested in the RunWith", true);
        } 
    }
}

