# jpath

## jpath — что такое и зачем

  * DSL для извлечения из js-объектов каких-то данных.
  * Прямой наследник XPath.

---

## jpath — что такое и зачем

В JS для этого используется:

  * `data.foo.bar`, `data[index]`.
  * `forEach`, `map`, `filter`, `find`, ...
  * Циклы, условия, все остальные конструкции JS.
  * ...

Поэтому ключевое слово: DSL.

---

## React vs teya

    //  React
    <div className="Foo">
        { no.jpath( '.foo.bar', this.props ) }
    </div>

    //  teya
    <div class="Foo">
        .foo.bar

---

## install

    $ npm install nommon

    const no = require( 'nommon' );
    //  const no = require( 'nommon/lib/no.jpath' );

    console.log( no.jpath( '.foo.bar', data ) );

---

## jpath vs javascript vs _.get

    result = no.jpath( '.foo.bar', data );

    result = data.foo.bar;

    result = _.get( data, '.foo.bar' );

---

## jpath vs javascript vs _.get

  * jpath никогда (почти) не фейлится

  * jpath компилируется (лучше, чем)

  * Много разных дополнительных фич

---

## Простейший get

    function get( path, data ) {
        const steps = path.split( '.' );
        for ( let i = 0; i < steps.length; i++ ) {
            if ( data == null ) { return data; }
            data = data[ steps[ i ] ];
        }
        return data;
    }
    console.log( get( 'foo.bar', data ) );

---

## Простой jpath .foo.bar

    result = no.jpath( '.foo.bar', data );
    result = data.foo.bar;

Почти тоже самое, но не совсем.

    result = data && data.foo && data.foo.bar;

Ближе, но все еще нет.

---

## Простой jpath .foo.bar

    data = {
        foo: {
            bar: 42
        }
    };

---

## Простой jpath .foo.bar

    data = [
        { foo: { bar: 42 } },
        { quu: 66 },
        { foo: { bar: 24 } }
    ];

---

## Простой jpath .foo.bar

    data = {
        foo: [
            { bar: 42 },
            { quu: 66 },
            { bar: 24 }
        ]
    };

---

## jpath steps

  * `.foo`
  * `.*`
  * `[ ... ]`
  * `{ ... }`

---

## .foo.bar

    if ( d == null ) return;
    var a = Array.isArray( d );
    if ( a ) { d = as( d , 'foo', []); }
    else {
        d = d[ 'foo' ];
        if ( d == null ) return;
        a = Array.isArray( d )
    }
    return a ? as( d, 'bar', [] ) : d[ 'bar' ]

---

## Тип результата .foo

  * Массив

  * Не массив

---

## .*

Результат всегда массив.

    data = {
        foo: 42,
        bar: 24
    }

    no.jpath( '.*', data )

---

## Индексы: [ ... ]

Индекс — это не обращение к свойству объекта.

    .items[ 2 ]

Не правильно:

    .items.length
    .items[ "foo" ]

---

## Динамический шаг

    no.jpath( `.${ id }`, data )

Можно было бы сделать синтаксис типа:

    no.jpath( '.{ id }', data, { id: "foo" } )

---

## Предикаты: { ... }

    data = {
        item: [
            { id: 1, count: 10 },
            { id: 2, count: 30, selected: true },
            ...
        ]
    };
    no.jpath( '.item{ .count > 20 }', data )
    no.jpath( '.item{ .selected }.id', data )

---

## Предикаты: { ... }

    .count{ . > 20 }

    data = {
        count: 30
    };

---

## absolute vs relative jpath

    .foo
    /.foo

---

## absolute vs relative jpath

    data = {
        count: 42,
        item: [
            { count: 24 },
            { count: 66 },
        ]
    }
    no.jpath( '.item{ .count > /.count }', data )

---

## absolute vs relative jpath

    compiled = no.jpath.expr( '...' );

    compiled( data, root, vars )

---

## jpath expression

  * jpath `.foo.bar`
  * string `"foo"`
  * number `42`
  * variable `foo`
  * function `foo(...)`
  * subexpr `( ... )`
  * jfilter `( ... ).foo.bar`
  * `true`, `false`, `null`, `undefined`

---

## strings

    "foo"
    "id-{ .id }"
    "{ .foo }-{ .bar }"

---

## variables

    no.jpath( '.item{ .id === id }', data, { id: 42 } )

Хуже:

    no.jpath( `.item{ .id === ${ id } }`, data )

---

## jfilter

    config.foo.bar
    ( .foo || .bar ).quu
    foo().bar

---

## functions

**Under construction!**

    no.jpath.defunc( 'encode', {
        type: 'string',
        body: function( s ) { return encodeURIComponent( s ); }
    } );
    no.jpath.string(
        'http://yandex.ru/yandsearch?text={ encode(.text) }',
        { text: 'Привет' }
    )

---

## ternary op

    ( .count > 0 ) ? .count : 0

---

## binary op

  * `+ - * / %`
  * `== === != !==`
  * `< > <= >=`
  * `&& ||`
  * `~~ !~`

---

## ~~ и !~

    marks = [ 'audi', 'bwm' ]
    items = [
        { marks: [ 'opel', 'vaz' ] },
        { marks: [ 'audi', 'kia', 'jeep' ] },
        ...
    ]
    no.jpath( '.{ .marks ~~ marks }', items,
        { marks: marks } )

---

## ~~~ и !~~

Сейчас отсутствуют, надо сделать.

---

## unary op

  * `+ -`
  * `!`

---

## jpath vs jepxr vs no.jpath.expr

    .foo.bar
    .foo + .bar
    .foo && !.bar
    .listing.pager.total_count > 0
    42 + 24

---

## API

    no.jpath
    no.jpath.expr
    no.jpath.string

---

## API

    result = no.jpath( '.foo', data )
    result = no.jpath( '.foo + .bar', data )

    compiled = no.jpath.expr( '.foo' )
    result = compiled( data )
    compiled = no.jpath.expr( '.foo + .bar' )
    result = compiled( data )

    result = no.jpath.expr( '.foo' )( data )

---

## API

    compiled = no.jpath.string( 'Hello, { .username }' )
    result = compiled( { username: 'nop' } )

    no.jpath.string( 'https://{ config.host }/get/{ .id }' )

---

## API

    no.jpath( jpath, data, vars ) ->
        result
    no.jpath.expr( jpath, type ) ->
        ( data, root, vars ) ->
            result
    no.jpath.string( jpath, type ) ->
        ( data, root, vars ) ->
            result_string

---

## de.jexpr

    de.jexpr = function( jpath ) {
        return function( data ) {
            return no.jpath.expr( jpath )( data, data, {
                params: params,
                context: context,
                state: state
            } );
        };
    };

---

## jresult

    jresult = no.jpath.expr( {
        bar: { foo: '.foo.bar' }
    } );

    jresult( {
        foo: { bar: 42 }
    } )

---

## Types

Опциональная типизация:

  * Валидация входных данных (а-ля React.PropTypes)
  * Оптимизация
  * Дополнительный синтаксический сахар

---

## Types

    data = {
        foo: {
            bar: 'Hello'
        }
    };

    no.jpath( '.foo.bar', data )

---

## .foo.bar

    if ( d == null ) return;
    var a = Array.isArray( d );
    if ( a ) { d = as( d , 'foo', []); }
    else {
        d = d[ 'foo' ];
        if ( d == null ) return;
        a = Array.isArray( d )
    }
    return a ? as( d, 'bar', [] ) : d[ 'bar' ]

---

## Types. Оптимизация

    type = no.type( {
        foo: {
            bar: 'string'
        }
    } );
    compiled = no.jpath.expr( '.foo.bar', type );

    var a; d = d[ "foo" ]; return d[ "bar" ]

---

## Types. Syntax sugar

    item = {
        created: 1493557020246
    }
    <div className="created">
        { no.date.format(
            new Date( no.jpath( '.created', item ) ),
            "%H:%M"
        ) }
    </div>

---

## Types. Syntax sugar

Лучше так:

    <div class="created">
        .created.format( "%H:%M ")

---

## Types. Syntax sugar

    TimestampType = no.Type.Number.extend({
        methods: {
            format: ...
        }
    });
    ItemType = no.type( {
        created: TimestampType
    } )

---

## Что внутри? (неонка)

  * Grammar
  * Parser
  * Grammar tokens
  * Grammar rules
  * Code generator
  * Type checker

---

## Grammar

    expr := ternary | binary
    ternary := binary '?' expr ':' expr
    binary := unary ( BIN_OP unary )*
    unary := UN_OP unary | primary
    primary := string | number | var | func | jpath | subexpr
    ...

---

## Parser

    parser = new no.Parser( {
        rules: rules,
        tokens: tokens
    } );
    parser.parse( '.foo.bar', 'jpath' )

---

## Parser

     0             7 = l - 1
    _________________
    |.|f|o|o|.|b|a|r| = s
    -----------------
             ^
             4 = x

---

## Parser

    parser.match( rule_id )
    parser.is_token( token_id )
    parser.token( token_id )
    parser.next_char()
    parser.next_code()
    parser.move( n )
    parser.skip()

---

## Rules

    function r_unary( parser ) {
        var op = parser.next_char();
        if ( op === '+' || op === '-' || op === '!' ) {
            parser.move( 1 );
            return { _id: 'unop', op: op,
                expr: r_unary( parser ) };
        }
        return r_primary( parser );
    }

---

## Rules

    function r_primary( parser ) {
        var c = parser.next_code();
        var expr;
        if ( c === 34 ) { //  "
            expr = r_string( parser );
        } else if ( c === 46 || c === 47 ) { //  ./
            expr = r_jpath( parser );
        } else if ( c === 40 ) { //  (
            expr = r_subexpr( parser );
        ...

---

## Rules

    } else {
        var name = parser.token( 'ID' );
        if ( name === 'true' || name === 'false' || name === 'null' || name === 'undefined' ) {
            expr = { _id: name };
        } else {
            if ( parser.next_code() === 40 ) { //  (
                expr = {
                    _id: 'func',
                    ...

---

## Tokens

    //  /^[a-zA-Z_][a-zA-Z0-9-_]*/
    function t_id( parser ) {
        if ( parser.x >= parser.l ) { return null; }
        var c = parser.s.charCodeAt( parser.x );
        if ( !( c > 96 && c < 123 || c > 64 &&
            c < 91 || c === 95 ) ) {
            return null;
        }
        ...

---

## Tokens. RegExp vs charCodeAt

  * [https://jsperf.com/skip-spaces-regexp-vs-charat](https://jsperf.com/skip-spaces-regexp-vs-charat)
  * [https://jsperf.com/parse-binop-regexp-vs-charcodeat](https://jsperf.com/parse-binop-regexp-vs-charcodeat)
  * [http://jsperf.com/parse-id-regexp-vs-charcodeat](http://jsperf.com/parse-id-regexp-vs-charcodeat)

---

## Code generation

    const compiled = no.jpath.expr( '.item{ .count > 0 }' );

---

## Code generation

    var as=R.as,ss=R.ss,ass=R.ass,f=R.f,c=R.c,ts=R.ts,tn=R.tn,tc=R.tc,e=R.e,M=R.M,j=R.j;
    function e0(d,r,v){if(d==null)return;var a=Array.isArray(d);return a?as(d,"count",[]):d["count"]}
    function e1(d,r,v){return(tc(e0(d,r,v))>0);}
    function e2(d,r,v){if(d==null)return;var a=Array.isArray(d);if(a){d=as(d,"item",[])}else{d=d["item"];if(d==null)return;a=Array.isArray(d)}if(a)return f(d,r,v,e1,[]);if(e1(d,r,v))return d}
    return e2

---

## Code generation

    .item{ .count > 0 }

    e0      .count
    e1      e0 > 0
    e2      .item{ e1 }

---

## Code generation

    var exprs = [];
    var exid = ((ast._id === 'jpath') ? jpath2func : expr2func)
        ( ast, type, type, exprs );
    var js = 'var as=R.as,ss=R.ss,ass=R.ass,f=R.f,c=R.c,ts=R.ts,tn=R.tn,tc=R.tc,e=R.e,M=R.M,j=R.j;\n';
    for ( var i = 0; i <= exid; i++ )
        js += 'function e' + i + '(d,r,v){' + exprs[ i ] + '}\n';
    js += 'return e' + exid;
    compiled = Function( 'R', js )( runtime );

---

## Code generation

    function expr2func( ast, d_type, r_type, exprs ) {
        var js = 'return(' + ast2js( ast, d_type, r_type, exprs ) + ');';

        return exprs.push( js ) - 1;
    }

---

## Code generation

    function jpath2func( ast, d_type, r_type, exprs ) {
        var js = d_type.js_prologue();
        ast.steps.forEach( step => {
            switch ( step._id ) {
                case 'namestep':
                    js += d_type.js_namestep( step.name, is_last );
                    d_type = d_type.type_namestep( step.name );
                    break;

---

## Code generation

    no.Type.Any = no.Type.extend( {
        js_namestep: function( name, is_last ) {
            if ( is_last ) return 'return a?' +
                this.js_array_prop( name ) +
                ':' + this.js_prop( name );
            return 'if(a){d=' + this.js_array_prop( name ) +
                '}else{d=' + this.js_prop( name ) +
                ';if(d==null)return;a=Array.isArray(d)}';
        },

---

## Code generation

    function ast2js( ast, d_type, r_type, exprs ) {
        switch ( ast._id ) {
            ...
            case 'unop':
                js = ast.op + '(' +
                    ast2js( ast.expr, d_type, r_type, exprs ) + ')';
                ast._type = ( ast.op === '!' ) ?
                     type_boolean : type_number;
                break;

---

## Code generation

    case 'binop':
        left_js = ast2js( ast.left, d_type, r_type, exprs );
        right_js = ast2js( ast.right, d_type, r_type, exprs );
        ...
        } else if ( ast.op === '+' || ast.op === '-' ... ) {
            left_js = ast.left._type.js_to_number( left_js );
            right_js = ast.right._type.js_to_number( right_js );
            ast._type = type_number;

---

## Code generation

    case 'var':
        js = 'v["' + ast.name + '"]';
        ast._type = type_default;
        break;
    case 'jpath':
        var exid = jpath2func( ast, d_type, r_type, exprs );
        js = 'e' + exid + '(d,r,v)';
        break;

