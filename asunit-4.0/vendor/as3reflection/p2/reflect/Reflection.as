package p2.reflect {
    import flash.net.getClassByAlias;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    public class Reflection extends ReflectionBase {

        private static var READ_WRITE:String = "readwrite";
        private static var READ_ONLY:String = "readonly";
        private static var WRITE_ONLY:String = "writeonly";
        private static var reflections:Object;
        private var _accessors:Array;
        private var _allMembers:Array;
        private var _base:String;
        private var _classReference:Class;
        private var _constructor:ReflectionMethod;
        private var _extendedClasses:Array;
        private var _interfaceNames:Array;
        private var _isClass:Boolean;
        private var _isDynamic:Boolean;
        private var _isFinal:Boolean;
        private var _isInterface:Boolean;
        private var _isStatic:Boolean;
        private var _methodNames:Array;
        private var _methods:Array;
        private var _readMembers:Array;
        private var _readWriteMembers:Array;
        private var _types:Array;
        private var _variables:Array;
        private var _writeMembers:Array;

        public function Reflection(classOrInstance:*) {
            _isClass = (classOrInstance is Class);
            super(describeType(classOrInstance));
        }
        
        public static function create(classOrInstance:*):Reflection {
            var name:String = getCacheNameFromClassOrInstance(classOrInstance);
            var cache:Object = getCache();
            if(cache[name] != null) {
                return cache[name];
            }
            return cache[name] = new Reflection(classOrInstance);
        }

        override protected function getRawMetaData():XMLList {
            return description.factory.metadata;
        }

        private static function getCacheNameFromClassOrInstance(classOrInstance:*):String {
            return getQualifiedClassName(classOrInstance) + ((classOrInstance is Class) ? "Class" : "");
        }
        
        private static function getCache():Object {
            if(reflections == null) {
                clearCache();
            }
            return reflections;
        }
        
        public static function clearCache():void {
            reflections = new Object();
        }

        private function buildMethods():Array {
            var methods:Array = new Array();
            var list:XMLList = description..method;
            var item:XML;
            var method:ReflectionMethod
            for each(item in list) {
                method = new ReflectionMethod(item);
                methods.push(method);
            }
            return methods;
        }
        
        private function buildAccessors():Array {
            var accessors:Array = new Array();
            var list:XMLList = description..accessor;
            var item:XML;
            var accessor:ReflectionAccessor;
            for each(item in list) {
                accessor = new ReflectionAccessor(item);
                accessors.push(accessor);
            }
            return accessors;
        }
        
        public function get hasConstructor():Boolean {
            return (constructor != null);
        }
        
        public function get classReference():Class {
            return _classReference ||= getDefinitionByName(name.split("::").join(".")) as Class;
        }

        public function get constructor():ReflectionMethod {
            return _constructor ||= buildConstructor();
        }

        private function buildConstructor():ReflectionMethod {
            var constr:XML = description..constructor[0];
            if(constr != null) {
                return new ReflectionMethod(constr);
            }
            return null;
        }

        /**
         * Returns whether or not this Class implements or extends the 
         * provided Class or Interface name.
         *
         * The name provided must be fully qualified and can use only
         * dots to delimit between the package and class name (pkg.ClassName), 
         * or it can use the double-colon that Adobe seems to prefer.
         *
         **/
        public function isA(fullyQualifiedClassOrInterfaceName:String):Boolean {
            var cleanedName:String = normalizeEntityName(fullyQualifiedClassOrInterfaceName);
            return referencesInterfaceOrClassName(function(name:String):Boolean {
                return (name == cleanedName);
            });
        }

        /**
         * Works just like +isA+, but doesn't require a fully-qualified name,
         * and will instead work with any portion of the full Class or Interface name.
         **/
        public function mightBeA(classOrInterfaceName:String):Boolean {
            return referencesInterfaceOrClassName(function(name:String):Boolean {
                return (name.indexOf(classOrInterfaceName) > -1);
            });
        }

        private function referencesInterfaceOrClassName(matcher:Function):Boolean {
            return findFirst(types, function(name:String, index:int, names:Array):Boolean {
                return matcher.call(null, name);
            });
        }

        /**
         * Convert human-normal class names and return Adobe-generated Strings 
         * for matching purposes.
         **/
        private function normalizeEntityName(name:String):String {
            if(name.indexOf('::') > -1 || name.indexOf('.') == -1) {
                return name;
            }
            var parts:Array = name.split('.');
            var className:String = parts.pop();
            return [parts.join('.'), className].join('::');
        }
        
        public function hasAccessor(name:String, type:String, declaredBy:String=null):Boolean {
            return findFirst(accessors, function(item:*, index:int, items:Array):Boolean {
                return (item.name == name && item.type == type);
            }) != null;
        }
        
        public function hasVariable(name:String, type:String):Boolean {
            return findFirst(variables, function(item:*, index:int, items:Array):Boolean {
                return (item.name == name && item.type == type);
            }) != null;
        }
        
        public function hasReadWriteMember(name:String, type:String):Boolean {
            return findFirst(readWriteMembers, function(item:*, index:int, items:Array):Boolean {
                return (item.name == name && item.type == type);
            }) != null;
        }
        
        public function hasWriteMember(name:String, type:String):Boolean {
            return findFirst(writeMembers, function(item:*, index:int, items:Array):Boolean {
                return (item.name == name && item.type == type);
            }) != null;
        }
        
        public function get variables():Array {
            return _variables ||= buildVariables();
        }

        private function buildVariables():Array {
            var result:Array = [];
            var list:XMLList = description..variable;
            var item:XML;
            for each(item in list) {
                result.push(new ReflectionVariable(item));
            }
            return result;
        }
        
        public function get readWriteMembers():Array {
            return _readWriteMembers ||= buildReadWriteMembers();
        }

        private function buildReadWriteMembers():Array {
            var result:Array = [];

            variables.forEach(function(item:*, index:int, items:Array):void {
                result.push(item);
            });

            accessors.forEach(function(accessor:ReflectionAccessor, index:int, items:Array):void {
                if(accessor.access == READ_WRITE) {
                    result.push(accessor);
                }
            });
            
            return result;
        }

        public function get readMembers():Array {
            if(_readMembers == null) {
                _readMembers = [];
                variables.forEach(function(item:*, index:int, items:Array):void {
                    _readMembers.push(item);
                });
                var accessors:Array = this.accessors;
                var accessor:ReflectionAccessor
                for each(accessor in accessors) {
                    if(accessor.access == READ_WRITE || accessor.access == READ_ONLY) {
                        _readMembers.push(accessor);
                    }
                }
            }
            
            return _readMembers;
        }
        
        public function get writeMembers():Array {
            if(_writeMembers == null) {
                _writeMembers = [];
                variables.forEach(function(item:*, index:int, items:Array):void {
                    _writeMembers.push(item);
                });
                var accessors:Array = this.accessors;
                var accessor:ReflectionAccessor
                for each(accessor in accessors) {
                    if(accessor.access == READ_WRITE || accessor.access == WRITE_ONLY) {
                        _writeMembers.push(accessor);
                    }
                }
            }

            return _writeMembers;
        }
        
        public function get interfaceNames():Array {
            return _interfaceNames ||= buildInterfaceNames();
        }

        private function buildInterfaceNames():Array {
            var result:Array = new Array();
            var list:XMLList = description..implementsInterface.@type;
            var item:XML;
            for each(item in list) {
                result.push(item);
            }
            return result;
        }
        
        public function get extendedClasses():Array {
            return _extendedClasses ||= buildExtendedClasses();
        }

        private function buildExtendedClasses():Array {
            var result:Array = [];
            var list:XMLList = description..extendsClass.@type;
            var item:XML;
            for each(item in list) {
                result.push(item);
            }
            return result;
        }
        
        public function get types():Array {
            return _types ||= extendedClasses.concat(interfaceNames);
        }
        
        public function get base():String {
            return _base ||= description.@base;
        }

        public function get isInterface():Boolean {
            return _isInterface ||= inferIsInterface();
        }

        private function inferIsInterface():Boolean {
            return (base == "Class" && (description..factory..extendsClass.length() == 0));
        }
        
        public function get isClass():Boolean {
            return _isClass;
        }
        
        public function get isDynamic():Boolean {
            return _isDynamic ||= (description.@isDynamic == "true");
        }
        
        public function get isFinal():Boolean {
            return _isFinal ||= (description.@isFinal == "true");
        }
        
        public function get isStatic():Boolean {
            return _isStatic ||= (description.@isStatic == "true");
        }
        
        public function get methods():Array {
            return _methods ||= buildMethods();
        }
        
        public function get accessors():Array {
            return _accessors ||= buildAccessors();
        }

        /**
         * An alphabetized list of all variables, accessors and methods.
         **/
        public function get allMembers():Array {
            return _allMembers ||= buildAllMembers();
        }

        private function buildAllMembers():Array {
            return variables.concat(accessors).concat(methods).sortOn('name');
        }
        
        public function get methodNames():Array {
            return _methodNames ||= buildMethodNames();
        }

        private function buildMethodNames():Array {
            var result:Array = [];
            var list:XMLList = description..method.@name;
            var item:XML;
            for each(item in list) {
                result.push(item.toString());
            }
            return result;
        }
        
        public function hasMethod(methodName:String):Boolean {
            return (methodNames.indexOf(methodName) > -1);
        }

        /**
         * Return an alphabetized list of all variables, accessors and
         * methods that are annotated with the provided +metaDataName+.
         **/
        public function getMembersByMetaData(metaDataName:String):Array {
            var result:Array = allMembers.filter(function(item:ReflectionMember, index:int, items:Array):Boolean {
                return (item.getMetaDataByName(metaDataName) != null);
            });
            // We should have some way to remind folks to add a new metadata tag to
            // their compiler options, shouldn't we? 
            // it's just that the following is really annoying...
            //if(Reflection.WARN && result.length == 0) {
                //var warning:String = "[WARNING] p2.reflect.Reflection.getMembersByMetaData was unable to find any members with meta data: " + metaDataName + "\n";
                //warning += "Did you forget to add --keep-as3-metadata=" + metaDataName + " to your compiler options?\n";
                //warning += "(set p2.reflect.Reflection.WARN = false to hide this message in the future)";
                //trace(warning);
            //}

            return result;
        }

        /**
         * Return an alphabetized list of all methods that are 
         * annotated with the provided +metaDataName+.
         **/
        public function getMethodsByMetaData(metaDataName:String):Array {
            return methods.filter(function(item:ReflectionMember, index:int, items:Array):Boolean {
                return (item.getMetaDataByName(metaDataName) != null);
            });
        }
        
        public function getAccessorByName(name:String):ReflectionAccessor {
            var ln:Number = accessors.length
            for(var i:Number = 0; i < ln; i++) {
                if(accessors[i].name == name) {
                    return accessors[i];
                }
            }
            return null;
        }
        
        public function getMethodByName(name:String):ReflectionMethod {
            var ln:Number = methods.length;
            for(var i:Number = 0; i < ln; i++) {
                if(methods[i].name == name) {
                    return methods[i];
                }
            }
            return null;
        }
        
        // This implementation of Clone has some serious caveats...
        // a) Only member variables and accessors that are read/write will be cloned
        // b) The clone is shallow, meaning property references will not also be cloned
        // c) Only argument-free constructors are supported
        public static function clone(instance:Object):Object {
            var reflection:Reflection = new Reflection(instance);
            var clazz:Class = reflection.classReference;
            var clone:Object = new clazz();
            var members:Array = reflection.readWriteMembers;
            var name:String;
            var member:ReflectionMember;
            for each(member in members) {
                name = member.name;
                clone[name] = instance[name];
            }
            return clone;
        }
    }
}

