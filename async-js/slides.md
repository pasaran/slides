# Async JavaScript


  * Callbacks

  * Promises

  * `async`, `await`

  * Generators

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

    r = foo();

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

## `await`

    try {
        r = await foo();

    } catch ( e ) {
        ...
    }

---

## `async` и `await`

    async function() {
        //  Только внутри async-функций.
        r = await foo();

        ...
    }

---

## `async`

    /* eslint require-await: "error" */

    async function foo() {
        return 42;
    }

    r = await foo();

---

## `async`

    /* eslint require-await: "error" */

    // Не одно и то же.
    function foo() {
        return 42;
    }

    //  А тут пофигу.
    r = await foo();

---

## `async`

    /* eslint no-return-await: "error" */

    async function foo() {
        return await bar();
    }

    r = await foo();

---

## `async`

    /* eslint no-return-await: "error" */

    function foo() {
        return bar();
    }

    r = await foo();

---

## `async`

    /* eslint no-return-await: "error" */

    async function foo() {
        const r = await bar();

        return r;
    }

    r = await foo();

---

## Последовательное выполнение

    r1 = await fetch( url1 );
    r2 = await fetch( url2 );

---

## Параллельное выполнение

    [ r1, r2 ] = await Promise.all( [
        fetch( url1 ),
        fetch( url2 ),
    ] );

---

## Смешанное выполнение

    p1 = fetch( url1 );
    p2 = fetch( url2 );

    r2 = await( p2 );

---

## Timeout

    setTimeout( () => {
        //  ?!!
    }, 500 );

    const r = await do_something();

---

## Timeout

    function reject_after( timeout, reason ) {
        return new Promise( ( resolve, reject ) => {
            setTimeout(
                () => reject( reason ),
                timeout
            );
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

    function do_something() {
        const p = no.promise();
        ...
        p.on( 'cancel', ... );
        return p;
    }
    const p = do_something();
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

    const cancel = Cancel();

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
        const cancel = Cancel();
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

