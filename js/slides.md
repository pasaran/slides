# Core JavaScript

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
    b.foo: 42;
    b.foo: 24;

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

    String( x )                 //  '[object Object']
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
