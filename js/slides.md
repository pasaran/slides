# Core JavaScript

## Книги

*David Flanagan*  
JavaScript: The Definitive Guide

*Douglas Crockford*  
JavaScript: The Good Parts

---

## Типы данных

  * `Number`
  * `Boolean`
  * `String`
  * `Object`
  * `Array`
  * `Function`

---

## Number

    var a = 42;
    var b = -3.1415;
    var c = 1e+3;
    var d = 0xff;
    var e = 077;

---

## Number

  * IEEE 754
  * 64-bit float
  * `0.1 + 0.2 !== 0.3`
  * Целые от `-2^53` до `2^53`
  * `Math.pow( 2, 53 ) + 1 === Math.pow( 2, 53 )`

---

## Number

    Infinity, +Infinity, -Infinity
    +0, -0
    NaN

    +0 === -0
    1/( +0 ) !== 1/( -0 )
    NaN !== NaN

---

## Boolean

  * `true`
  * `false`

Есть и другие falsy values. См. ниже.

---

## String

    var a = "Hello";
    var b = 'World';
    var c = '\n\\\'\"';

---

## String

    //  Плохо.
    var d = 'Hello, \
        World';

    //  Хорошо.
    var e = 'Hello, ' +
        'World';

---

## String

    var a = 'Hello';

    a.length                    //  5
    a.charAt( 2 )               //  'l'
    a[ 2 ]                      //  'l'
    a.indexOf( 'l' )            //  2
    a.indexOf( 'x' )            //  -1
    a.slice( 2, 4 )             //  'll'

---

## null и undefined

    var x = null;

    var y;
    y                           //  undefined
    var x = {};
    x.foo                       //  undefined

    var z = undefined;

---

## null и undefined

    null == undefined
    null !== undefined

    x == null
    x === null || x === undefined

---

## Falsy values

    false
    0
    ''
    null
    undefined
    NaN

---

## Truthy value

    []
    {}
    '0'

---

## == vs ===

    0 === ''                    //  false
    0 == ''                     //  true

Всегда используем `===` за исключением:

    x == null

---

## В JS все — объекты

Все, да не все. Не объекты:

    null
    undefined

Псевдо-объекты:

    String
    Number
    Boolean

---

## Wrapper object

    'Hello'.length              //  5
    200..toFixed( 2 )           //  '200.00'
    true.toString()             //  'true'

    var s = 'Hello';
    s.foo = 42;
    s.foo                       //  undefined

Строки — immutable.

---

## Wrapper object

    var x = new Boolean( false );
    x.foo = 42;
    x.foo                       //  42
    x.valueOf()                 //  false
    Boolean( x )                //  true
    typeof x                    //  'object'

---

## Wrapper object

Никогда не используем:

    new String( x )
    new Boolean( x )
    new Number( x )

---

## Object

    var o = {
        foo: 42,
        ' ': 24,

        get_foo: function() {
            return this.foo;
        }
    };

    var empty = {};

---

## Object

    o.foo
    o[ ' ' ]
    o.bar                       //  undefined

    o.get_foo()

    o.quu = 24;
    o.foo = 'Hello';

---

## Object

    var o = { foo: 42 };
    o.foo = undefined;
    o.foo                       //  undefined
    'foo' in o                  //  true

    var o = { foo: 42 };
    delete o.foo;
    o.foo                       //  undefined
    'foo' in o                  //  false

---

## Object

Итерация по объекту:

    for ( var key in o ) {
        console.log( key, o[ key ] );
    }

---

## Object

Есть определенный порядок ключей при итерации.

    var a = { foo: 42, bar: 24 };

    var b = {};
    b.foo = 42;
    b.foo = 24;

---

## Object

Но числовые ключи сортируются специально.

    var o = {
        foo: 42,
        '42': 'foo',
        bar: 24,
        '24': 'bar'
    }
    //  24, 42, 'foo', 'bar'

---

## Object

    var a = { foo: 42 };
    var b = a;

    b.bar = 24;
    a.bar                       //  24
    a === b                     //  true

---

## Object

    var a = { foo: 42 };
    var b = { foo: 42 };

    a === b                     //  false

---

## Array

    var a = [ 1, 2, 3 ];
    var b = [ 1, 2, 3, ];
    var c = [ 1, 'Hello', true, null, undefined ];
    var d = [ , , , ];

    var empty = [];

---

## Array

    var a = [ 1, 2, 3 ];
    a.length                    //  3

    a[ 0 ]                      //  1
    a[ 5 ]                      //  undefined

    a[ 5 ] = 6;
    a.length                    //  6;
    a[ 4 ]                      //  undefined

---

## Array

    var a = [];
    a[ 1000 ] = 1;
    a.length                    //  1001
    a[ 500 ]                    //  undefined

    a[ '2000' ] = 2;
    a.length                    //  2001

---

## Array

    var a = [ 1, 2, 3 ];
    a.length                    //  3
    a.foo = 42;
    a.foo                       //  42
    a.length                    //  3

---

## Array

    for ( var x in a ) {
        console.log( x, a[ x ] );
    }

    for ( var i = 0, l = a.length; i < l; i++ ) {
        console.log( i, a[ x ] );
    }

    a.forEach( console.log );

---

## Array

    var o = {
        0: 1,
        1: 2,
        2: 3
    };
    o[ 0 ]                      //  1
    o.length                    //  undefined

---

## Array

    var a = [ 1, 2, 3 ];
    delete a[ 1 ];

    a[ 1 ]                      //  undefined
    1 in a                      //  false
    a.length                    //  3

---

## Array

    var a = [ 1, 2 ];
    a.push( 3 );
    a.push( 4, 9 );
    a.length                    //  5
    a.pop()                     //  9
    a.length                    //  4
    a.shift( 6 );
    a                           //  [ 6, 1, 2, 3, 4 ]
    a.unshift()                 //  6

---

## Array

Другие полезные методы массива:

    sort
    join
    slice
    splice
    concat
    indexOf
    map

---

## Function

    function add( a, b ) {
        return a + b;
    }

---

## Function

    var add = function( a, b ) {
        return a + b;
    }

    add.foo = 42;
    add.foo                     //  42

---

## Где кто

Как узнать, что за значение у нас есть.
Число это, или строка, или массив или еще что.

    ===
    typeof
    instanceof
    Array.isArray

    Object.prototype.toString.call

---

## Где кто. Number

    typeof x === 'number'

Но:

    typeof NaN === 'number'

---

## Где кто. String, Boolean, Function

    typeof x === 'string'
    typeof x === 'boolean'
    typeof x === 'function'

---

## Где кто. null и undefined

    x === null
    x === undefined

При этом:

    typeof undefined === 'undefined'
    typeof null === 'object'

---

## Где кто. RegExp

    x instanceof RegExp

---

## Где кто. Array

    Array.isArray( x )

При этом `x instanceof Array` работает с проблемами.

---

## Где кто. Object

    typeof x === 'object'

Но:

    typeof null === 'object'
    typeof [] === 'object'
    typeof /foo/ === 'object'

---

## Где кто

    switch ( typeof x ) {
        case 'number': ...
        case 'string': ...
        case 'boolean': ...
        case 'function': ...
        case 'object':
            if ( Array.isArray() ) { ... }
            else if ( x ) { ... }
            else { ... }

---

## Где кто. Foo

    x instanceof Foo

При этом:

    typeof x === 'object'

---

## Где кто

    Object.prototype.toString.call( x )

    '[object Object]'
    '[object Array]'
    ...

---

## Приведение типов

    if ( x ) {
        ...
    }

    x + y

    foo[ x ]

---

## Приведение типов

    [] + {}                     //  '[object Object]'
    {} + []                     //  0

---

## Приведение типов. String

    x.toString()
    String( x )
    '' + x                      //  Не рекомендуется.


    null.toString()
    undefined.toString()

    var y = { toString: function() { return 'Fooooo!' } };

---

## Приведение типов. String

    var x = { foo: 42 };

    String( x )                 //  '[object Object]'
    JSON.stringify( x )         //  '{"foo":42}'

---

## Приведение типов. Boolean

    Boolean( x )
    !!x

    x

---

## Приведение типов. Number

    Number( x )
    +x

    parseInt( x, 10 )
    parseFloat( x )

    Number( '42foo' )           //  NaN
    parseInt( '42foo' )         //  42

---

## JSON

  * Number literal
  * String literal
  * Object literal
  * Array literal
  * `true`, `false`, `null`

---

## JSON

    {
        "foo": 42,
        "bar": {
            "quu": [ "Hello", true ],
            "boo": null
        }
    }

---

## JSON

    JSON.parse( x )
    JSON.stringify( x )

    x.toJSON()

---

## Определение переменных

    var a = 42;
    var b;
    var c;

---

## Определение переменных

    var a = 42, b, c;

    var a = 42,
        b,
        c;

---

## Определение переменных

    var a = 42;
    //  var b = 24;
    var c = a + b;

---

## Определение переменных

    var a;
    typeof a === 'undefined'    //  true
    a === undefined             //  true

    typeof b === 'undefined'    //  true
    b === undefined             //  ReferenceError:
                                //      b is not defined

---

## Определение переменных

    var a = 42;
    b = 24;
    var c = a + b;

    global.b                    //  24

---

## Function

    function add( a, b ) {
        return a + b;
    }

    var c = add( 2, 3 );

---

## Function

    function foo( x ) {
        if ( !x ) {
            return;
        }

        return x + 1;
    }

---

## Function

    function doFoo() {
        doBar();
    }

    var result = doFoo();       //  undefined

    doFoo();

---

## Function

    function foo() {
        return
        {
            foo: 42
        };
    }

---

## Function

Hoisting:

    var c = add( 2, 3 );

    function add( a, b ) {
        return a + b;
    }

---

## Function

    function foo( x ) {
        if ( x ) bar( x - 1 );
    }
    function bar( x ) {
        if ( x ) foo( x - 1 );
    }

    foo( 10 );

---

## Scope

    function foo() {
        var a = 42;

        console.log( a );
    }

    foo();
    console.log( a );           //  ReferenceError

---

## Scope

    var a = 42;

    function foo() {
        console.log( a );       //  42
    }

    foo();
    console.log( a );           //  42

---

## Scope

    function foo() {
        var a = 42;
    }
    function bar() {
        console.log( a );       //  ReferenceError
    }

    foo();
    bar();

---

## Scope

    var a = 42;

    function foo() {
        console.log( a );       //  42
        a = 24;
    }

    foo();
    console.log( a );           //  24

---

## Scope

    var a = 42;

    function foo() {
        var a = 24;
        console.log( a );       //  24
    }

    foo();
    console.log( a );           //  42

---

##  Scope

    var a = 42;

    function foo( a ) {
        console.log( a );       //  24
    }

    foo( 24 );
    console.log( a );           //  42

---

## Scope

    var a = 42;
    function foo() {
        var a = 24;
        function bar() {
            var a = 66;
        }
    }

    foo();

---

## Scope

    var a = 42;
    function foo( a ) {
        console.log( a );       //  24
        var a = 66;
        console.log( a );       //  66
    }

    foo( 24 );
    console.log( a );           //  42

---

## Scope

    var a = 42;
    function foo() {
        var a = 24;
        function bar() {
            var a = 66;
        }
    }

    foo();

## Hoisting

    console.log( a );           //  undefined

    var a;

---

## Hoisting

    console.log( a );           //  undefined

    var a = 42;

---

## Hoisting

    var a;

    console.log( a );           //  undefined

    a = 42;

    console.log( a );           //  42

---

## Hoisting

    var a = 42;
    console.log( a );           //  42
    var a = 24;
    console.log( a );           //  24
    var a;
    console.log( a );           //  24
    a = 66;
    console.log( a );           //  66

---

## Hoisting

    function foo() {
        return 42;
    }

    var bar = function() {
        return 24;
    };

---

## Hoisting

    bar();                      //  TypeError:
                                //      bar is not a function

    var bar = function() {
        return 24;
    }

    bar();

---

## Scope

    var a = 42;
    if ( a ) {
        var b = 24;
    }

    var c = a + b;

---

## Scope

    var a = 42;
    var b;
    if ( a ) {
        b = 24;
    }

    var c = a + b;

---

## Scope

    for ( var i = 0; i < 10; i++ ) {
        doFoo();
    }

    var j = i;

---

## Scope

    var i;
    for ( i = 0; i < 10; i++ ) {
        doFoo();
    }

    var j = i;

---

##  Closures

    var a = 42;
    function foo() {
        return a;
    }

    foo()                       //  42
    a = 24;
    foo()                       //  24

---

##  Closures

    var inc = ( function() {
        var n = 0;
        return function() {
            return n++;
        }
    } )();

    inc()                       //  0
    inc()                       //  1

---

## Closures

    for ( var i = 1; i <= 10; i++ ) {
        setTimeout( function() {
            console.log( i );
        }, i * 1000 );
    }

---

## Closures

    for ( var i = 1; i <= 10; i++ ) {
        setTimeout( function() {
            console.log( i );
        }, i * 1000 );
    }

    console.log( i );

---

## Closures

    for ( var i = 1; i <= 10; i++ ) {
        ( function() {
            var j = i;
            setTimeout( function() {
                console.log( j );
            }, i * 1000 );
        } )();
    }

---

## Closures

    for ( var i = 1; i <= 10; i++ ) {
        ( function( i ) {
            setTimeout( function() {
                console.log( i );
            }, i * 1000 );
        } )( i );
    }

---

## Function

Четыре способа вызвать функцию:

  * Как функцию
  * Как метод
  * `call`, `apply`
  * Как конструктор

---

## Function

    function sum( a, b ) {
        return a + b;
    }

    var c = sum( 2, 3 );

---

## Function

    sum( 1 )                    //  NaN
    //  a === 1, b === undefined

---

## Function

    function sum( a, b ) {
        b = b || 0;
        //  b = ( b === undefined ) ? 0 : b;

        return a + b;
    }

    sum( 1 )                    //  1

---

## || и &&

    var a = b || c || d;

---

## || и &&

    var a;
    if ( b ) {
        a = b;
    } else if ( c ) {
        a = c;
    } else {
        a = d;
    }

---

## || и &&

    var a = b && c && d;

---

## || и &&

    var a;
    if ( !b ) {
        a = b;
    } else if ( !c ) {
        a = c;
    } else {
        a = d;
    }

---

## || и &&

    //  var a = o.foo.bar;
    var a = o && o.foo && o.foo.bar;

---

## && vs if

    foo() && bar();

    if ( foo() ) {
        bar();
    }

---

## Function

    sum( 1, 2, 3, 4, 5 )        //  3
    //  a === 1, b === 2

---

## Function

    function sum() {
        var r = 0;
        for ( var i = 0; i < arguments.length; i++ ) {
            r += arguments[ i ];
        }
        return r;
    }

    sum( 1, 2, 3, 4, 5 )        //  15

---

## Function

    function sum( a, b ) {
        console.log( a, arguments[ 0 ] );
        console.log( b, arguments[ 1 ] );
        console.log( arguments[ 2 ] );
        console.log( arguments[ 3 ] );
    }

    sum( 1, 2, 3 );

---

## Function

    function foo( a ) {
        console.log( a );       //  42
        arguments[ 0 ] = 24;
        console.log( a );       //  24
    }

    foo( 42);

---

## Function

    function sum() {
        var args = Array.prototype.slice.call( arguments );
        //  var args = [].slice.call( arguments );

        //  var args = [].slice.call( arguments, 1 );
        ...
    }

---

## Methods

    var o = {
        foo: 42,
        get_foo: function() {
            return this.foo;
        }
    };

    o.get_foo()                 //  42

---

##  Methods

    var o = {
        set_foo: function( foo ) { this.foo = foo; },
        get_foo: function() { return this.foo; }
    };

    o.set_foo( 42 );
    o.get_foo()                 //  42

    o.foo = 42;

---

##  Methods

    var o = {
        _foo: 0,
        set_foo: function( foo ) { this._foo = foo; },
        get_foo: function() { return this._foo; }
    };

    //  Плохо!
    o._foo = 42;

---

## Methods

    var objs = [];
    for ( var i = 0; i < 10; i++ ) {
        objs[ i ] = {
            foo: i,
            get_foo: function() {
                return this.foo;
            }
        };
    }

---

## Methods

    var o = {
        foo: 42,
        get_foo: function() { return this.foo; }
    };

    o.get_foo()                 //  42

    var get_foo = o.get_foo;
    get_foo()                   //  undefined

---

## Methods

    var get_foo = function() { return this.foo; };

    var a = { foo: 42, get_foo: get_foo };
    var b = { foo: 24, get_foo: get_foo };

    a.get_foo();                //  42
    b.get_foo();                //  24
    get_foo();                  //  undefined

---

## Methods

    var o = {
        foo: {
            foo: { foo: 42, get_foo: get_foo },
            get_foo: get_foo
        },
        get_foo: get_foo
    };

    o.get_foo(), o.foo.get_foo(), o.foo.foo.get_foo()

---

## call

    function get_foo() { return this.foo; }
    function set_foo( foo ) { this.foo = foo; }

    var o = { foo: 42 };
    get_foo.call( o )           //  42
    set_foo.call( o, 24 );
    o.foo                       //  24
    get_foo.call( o )           //  24

---

##  apply

    function sum() {
        var r = 0;
        for ( var i = 0; i < arguments.length; i++ )
            r += arguments[ i ];
        return r;
    }
    var numbers = [ 1, 2, 3, 4, 5 ];
    //  sum( [ 1, 2, 3, 4, 5 ] );
    sum.apply( null, numbers );

---

## apply

    function proxy_to_foo() {
        switch ( arguments.length ) {
            case 0: foo(); break;
            case 1: foo( arguments[0] ); break;
            case 2: foo( arguments[0], arguments[1] ); break;
            default: foo.apply( null, arguments );
        }
    }

---

## apply

    function proxy_to_foo() {
        ...
        switch ( arguments.length ) {
            case 0: foo.call( that ); break;
            case 1: foo.call( that,  arguments[0] ); break;
            ...
            default: foo.apply( that, arguments );
        }
    }

---

## bind

    function get_foo() { return this.foo; }
    var my_get_foo = get_foo.bind( { foo: 42 } );

    get_foo()                   //  undefined
    my_get_foo()                //  42
    my_get_foo.call( { foo: 24 } )
                                //  42
    get_foo === my_get_foo      //  false
    get_foo()                   //  undefined

---

## bind

    Foo.prototype.do_request = function() {
        $.ajax( this.url, ( function( result ) {
            this.result = result;
        } ).bind( this ) );
    };

---

## bind

    Foo.prototype.do_request = function() {
        var that = this;
        $.ajax( this.url, function( result ) {
            that.result = result;
        } );
    };

---

## prototype

    var a = { foo: 42 };

    a.foo                       //  42
    a.bar                       //  undefined
    a.toString                  //  [Function: toString]

---

## prototype

    var a = { foo: 42 };

    a.foo                       //  42
    a.bar                       //  undefined

    var b = { bar: 24 };
    a.__proto__ = b;
    a.bar                       //  24

---

## prototype

    a                   b
    -------------       -------------
    foo: 42             bar: 24
    __proto__

---

## prototype

    'foo' in a                  //  true
    'bar' in a                  //  true

    a.hasOwnProperty( 'foo' )   //  true
    a.hasOwnProperty( 'bar' )   //  false

---

## prototype

    b.bar = 66;
    a.bar                       //  66

---

## prototype

    a                   b
    -------------       -------------
    foo: 42             bar: 66
    __proto__

---

## prototype

    a.bar = 39;

    a.bar                       //  39
    b.bar                       //  66
    a.hasOwnProperty( 'bar' )   //  true

---

## prototype

    a                   b
    -------------       -------------
    foo: 42             bar: 66
    bar: 39
    __proto__

---

## prototype

    delete a.bar;
    a.bar                       //  66
    a.hasOwnProperty( 'bar' )   //  false

---

## prototype

    var c = { quu: 88; }
    b.__proto__ = c;

    b.quu                       //  88
    a.quu                       //  88

---

## prototype

    a                   b                   c
    -------------       -------------       -------------
    foo: 42             bar: 66             quu: 88
    __proto__           __proto__

---

## Object.prototype

    c.__proto__ === Object.prototype

    typeof Object               //  'function'
    Object.prototype

    c.toString === Object.prototype.toString

    Object.prototype.__proto__ === null

---

## Object.prototype

    var a = {};

    Object.prototype.foo = 42;

    a.bar                       //  42
    var b = {};
    b.bar                       //  42

---

## new Foo

    function Foo( foo ) {
        this.foo = foo;
    }
    Foo.prototype.get_foo = function() {
        return this.foo;
    };
    var foo = new Foo( 42 );
    foo instanceof Foo          //  true

---

## new Foo

    var foo = {};
    foo.__proto__ = Foo.prototype;
    Foo.call( foo, 42 );

    foo instanceof Foo          //  true

---

## instanceof

    function instance_of( obj, ctor ) {
        while ( obj ) {
            if ( obj.__proto__ === ctor ) {
                return true;
            }
            obj = obj.__proto__;
        }
        return false;
    }

---

    new Foo             Foo.prototype       Object.prototype
    -------------       -------------       -------------
    foo: 42             get_foo()           __proto__
    __proto__           __proto__

    Foo                 Function.prototype
    -------------       -------------
    prototype           call()
    __proto__           __proto__

---

## Inheritance

    function Foo1( foo ) { this.set_foo( foo ); }

    Foo1.prototype.get_foo = function() {
        return this.foo;
    };
    Foo1.prototype.set_foo = function( foo ) {
        this.foo = foo;
    };

---

## Inheritance

    function Foo2( foo ) { this.set_foo( foo ); }
    //  Foo2.prototype = new Foo1();
    Foo2.prototype.inc_foo = function() {
        this.foo++;
    };
    Foo2.prototype.set_foo = function( foo ) {
        if ( foo < 0 ) { throw Error(); }
        this.foo = foo;
    };

---

## Inheritance

    var foo2 = new Foo2( 42 );
    foo2.get_foo

---

## Inheritance

    Foo2.prototype = { __proto__: Foo1.prototype };

    Foo2.prototype = Object.create( Foo1.prototype );

---

## Inheritance

    function Foo2( foo ) { Foo1.call( this, foo ); }
    ...
    Foo2.prototype.set_foo = function( foo ) {
        if ( foo < 0 ) { throw Error(); }
        Foo1.prototype.set_foo.call( this, foo );
    };

---

## inherit

    function inherit( ctor, base ) {
        var F = function() {};
        F.prototype = base.prototype;
        var proto = ctor.prototype = new F();
        proto.super_ = base.prototype;
        proto.constructor = ctor;
        return ctor;
    }

---

## inherit

    function Foo2( foo ) {
        this.super_.constructor.call( this, foo );
    }
    inherit( Foo2, Foo1 );
    ...
    Foo2.prototype.set_foo = function( foo ) {
        if ( foo < 0 ) { throw Error(); }
        this.super_.set_foo.call( this, foo );
    };

---

## inherit

    Function Foo1( foo ) { this._init( foo ); }
    Foo1.prototype._init = function( foo ) {
        this.foo = foo;
    };

    Function Foo2( foo ) { this._init( foo ); }
    inherit( Foo2, Foo1 );

---

## Статические методы

    function Foo( foo ) { this._init( foo ); }

    Foo.create = function( foo ) {
        return new Foo( foo );
    };

---

## try / catch / throw

    var object;
    try {
        object = JSON.parse( string );
    } catch ( e ) {
        //  Ошибка!
        //  object = {};
    }

---

## try / catch / throw

    try {
        $.ajax( url, function( string ) {
            var object = JSON.parse( string );
        } );
    } catch ( e ) {
        //  Ничего!
    }

---

## nextTick

    var done = false;
    setTimeout( function() {
        done = true;
    }, 1000 );

    while ( !done ) {
        do_something();
    }

---

## nextTick

    <html>
    <body>
    <script>
        var foo = 42;
        do_something();
        function do_something() { do_something_else(); }
        $.ajax( url, function( result ) { ... } );
        ...
    </script>

