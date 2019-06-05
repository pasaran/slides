# Async JavaScript


  * Callbacks

  * Promises

  * `async`, `await`

  * Generators

[Faster async functions and promises](https://v8.dev/blog/fast-async)

---

## `async`

    async function foo( ... ) {
        ...
    }

Всегда возвращает `Promise`.

---

## `async`

    async function foo() {
        return 42;
    }

    const r = foo();

---

## `async`

    function foo() {
        return Promise.resolve( 42 );
    }

    const r = foo();

---

## `async`

    async function foo() {
        return promise;
    }

    const r = foo();

---

## `async`

    function foo() {
        //  return promise;
        return Promise.resolve( promise );
    }

    const r = foo();

---

## `async`

    async function foo() {
        throw Error( ... );
    }

    const r = foo();

---

## `async`

    function foo() {
        return Promise.reject( Error( ... ) );
    }

    const r = foo();

---

## `async`

    function asyncify( f ) {
        return function( ...args ) {
            try {
                return Promise.resolve( f( ...args ) );
            } catch ( e ) {
                return Promise.reject( e );
            }
        };
    }

---

## `await`

    const r = await foo();

---

## `await`

    function foo() {
        return 42;
    }

    const r = await foo();

    //  const r = await 42;

---

## `await`

    async function foo() {
        return 42;
    }

    const r = await foo();

---

## `await`

    const p = new Promise( ... );

    const r = await p;

---

## `async` и `await`

    async function() {
        //  Только внутри async-функций.
        const r = await foo();

        ...
    }

---

## `async`

    /* eslint require-await: "error" */

    async function foo() {
        return 42;
    }

    const r = await foo();

---

## `async`

    /* eslint require-await: "error" */

    // Не одно и то же.
    function foo() {
        return 42;
    }

    //  А тут пофигу.
    const r = await foo();

---

## `async`

    /* eslint no-return-await: "error" */

    async function foo() {
        return await bar();
    }

    const r = await foo();

---

## `async`

    /* eslint no-return-await: "error" */

    function foo() {
        return bar();
    }

    const r = await foo();

---

## `async`

    /* eslint no-return-await: "error" */

    async function foo() {
        const r = await bar();

        return r;
    }

    const r = await foo();

---

## Последовательное выполнение

    const r1 = await fetch( url1 );
    const r2 = await fetch( url2 );

---

## Параллельное выполнение

    const [ r1, r2 ] = await Promise.all( [
        fetch( url1 ),
        fetch( url2 ),
    ] );

---

## Параллельное выполнение

    const p1 = fetch( url1 );
    const p2 = fetch( url2 );

    const r2 = await p2;
    ...
    const r1 = await p1;

---

## Параллельное выполнение

    const p1 = fetch( url1 );
    const p2 = fetch( url2 );

    do_something( await p1, await p2 );

---

## Сложное выполнение

    const p1 = fetch( url1 );
    const p2 = fetch( url2 );

    const r2 = await p2;

    const [ r1, r3 ] = await Promise.all( [
        p1,
        fetch( r2.url ),
    ] );

---

## Обработка ошибок

    try {
        await do_something();

    } catch ( e ) {
        ...
    }

---

## Обработка ошибок

    try {
        await do_something();
        await do_something_else();
        ...

    } catch ( e ) {
        ...
    }

---

## Pause

    await do_something();
    //  wait 1 second
    await do_something_else();

---

## Pause

    function resolve_after( timeout, value ) {
        return new Promise( ( resolve ) => {
            setTimeout( resolve, timeout, value );
        } );
    }

---

## Pause

    await do_something();
    await resolve_after( 1000 );
    await do_something_else();

---

## Timeout

    setTimeout( () => {
        //  ?!!
    }, 500 );

    const r = await do_something();

---

## Timeout

    function reject_after( timeout, value ) {
        return new Promise( ( resolve, reject ) => {
            setTimeout( reject, timeout, value );
        } );
    }

---

## Timeout

    try {
        const r = await Promise.race( [
            do_something(),
            reject_after( 500, Error( 'TIMEOUT' ) ),
        ] );

    } catch ( e ) {
        //  Timeout! (or error)
    }

---

## Timeout

    await do_something();
    await do_something_else();
    ...

---

## Timeout

    await Promise.race( [
        ( async function() {
            await do_something();
            await do_something_else();
            ...
        } )(),
        reject_after( 500, Error( 'TIMEOUT' ) ),
    ] );

---

## Timeout

    await Promise.race( [
        Promise.all( [
            do_something(),
            do_something_else(),
            ...
        ] ),
        reject_after( 500, Error( 'TIMEOUT' ) ),
    ] );

---

## Cancel

    await Promise.race( [
        ( async function() {
            await do_something();
            await do_something_else();
            ...
            //  Выполняются до конца!
        } )(),
        reject_after( 500, Error( 'TIMEOUT' ) ),
    ] );

---

## Cancel

`fetch` vs `xhr`

    xhr.abort();

    const p = fetch( url );
    //  p.abort()

---

## Cancel

    function request( url ) {
        const p = no.promise();
        ...
        p.on( 'cancel', ... );
        return p;
    }
    const p = request( ... );
    ...
    p.trigger( 'cancel', ... );

---

## Cancel

    //  Всегда возвращает Promise.
    async function() {
        return 42;
    }

    //  Вообще нет никакого промиса.
    const r = await fetch( url );

---

## Cancel

[tc39/proposal-cancellation](https://github.com/tc39/proposal-cancellation/tree/master/stage0)

  * Stage 1

---

## Cancel

    const cancel = new Cancel();

    setTimeout( () => {
        //  Чуваки, хорошо бы тормознуться!
        cancel.cancel( Error( 'TIMEOUT' ) );
    }, 500 );

    await do_something( ..., cancel );

---

## Cancel

    async function do_something( ..., cancel ) {
        ...
        cancel.subscribe( ( reason ) => {
            //  Пытаемся отменить что-нибудь.
        } );
        ...
    }

---

## Cancel

    async do_something( cancel ) {
        await do_foo();
        await do_bar();
        ...
    }

---

## Cancel

    async do_something( cancel ) {
        await do_foo();
        cancel.throw_if_cancelled();

        await do_bar();
        cancel.throw_if_cancelled();

        ...
    }

---

## Cancel

    function cancel_after( timeout, reason ) {
        const cancel = new Cancel();
        setTimeout( () => {
            cancel.cancel( reason );
        }, timeout );
        return cancel;
    }

---

## Cancel

    const cancel = cancel_after( 500, Error( 'TIMEOUT' ) );
    await Promise.race( [
        ( async function() {
            await do_something();
            cancel.throw_if_cancelled();
            ...
        } )(),
        cancel.get_promise(),
    ] );

---

## Cancel

    async do_something( cancel ) {
        await do_foo( cancel );
        await do_bar( cancel );
        ...
    }

---

## Cancel

    async do_something( parent_cancel ) {
        const cancel = parent_cancel.create();

        return Promise.all( [
            do_foo( cancel ),
            do_bar( cancel ),
            ...
        ] );
    }

---

## Иерархия cancel-токенов

    de.Context
        de.object
            de.http
            de.http
            ...

---

## Идеи про Cancel

  * Токен не возвращается, а передается сверху вниз.
  * Есть дерево токенов.
  * Можно подписаться на "событие" `cancel`.
  * Можно кинуть исключение, если токен отменен.
  * Можно использовать промис, который зарежектится после отмены.

---

## Cancel API

    cancel.cancel( reason )
    cancel.throw_if_cancelled();
    cancel.get_promise();
    cancel.create();
    cancel.close();

---

## `for-await-of`

    for await ( const item of iterator ) {
        ...
    }

---

## `for-await-of`

    let s = '';
    res.on( 'data', ( chunk ) => {
        s += chunk;
    }
    res.on( 'end', () => {
        console.log( s );
    }

---

## `for-await-of`

    let s = '';
    for await ( const chunk of res ) {
        s += chunk;
    }
    console.log( s );

---

## `for-await-of`

    for await ( const chunk of res ) {
        cancel.throw_if_cancelled();
        s += chunk;
    }
    console.log( s );

