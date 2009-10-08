package asunit.framework {
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;

	public class TestMethodIterator implements Iterator {
		protected var beforeMethods:Iterator;
		protected var testMethods:Iterator;
		protected var afterMethods:Iterator;
		
		protected var testMethodHasRunThisCycle:Boolean;
		
		public function TestMethodIterator(test:Object) {
			beforeMethods = new ArrayIterator(FreeRunner.getBeforeMethods(test));
			testMethods   = new ArrayIterator(FreeRunner.getTestMethods(test));
			afterMethods  = new ArrayIterator(FreeRunner.getAfterMethods(test));
		}
		
        public function hasNext():Boolean {
            return testMethods.hasNext() || beforeMethods.hasNext() || afterMethods.hasNext();
        }

        public function next():Object {
			if (beforeMethods.hasNext())
				return beforeMethods.next();
			
			if (!testMethodHasRunThisCycle && testMethods.hasNext()) {
				testMethodHasRunThisCycle = true;
				return testMethods.next();
			}
			
			if (afterMethods.hasNext()) {
				return afterMethods.next();
			}
			
			if (!testMethods.hasNext()) return null;
			
			beforeMethods.reset();
			afterMethods.reset();
			testMethodHasRunThisCycle = false;
			return next();
        }

        public function reset():void {
			beforeMethods.reset();
			testMethods.reset();
			afterMethods.reset();
			testMethodHasRunThisCycle = false;
        }
		
	}
}

