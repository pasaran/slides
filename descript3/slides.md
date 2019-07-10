# descript

## descript

Дескрипт — это агрегатор данных.

---

## Чем `descript` не является

  * Это не веб-сервер, принимающий входящие запросы
  * В нем нет роутинга
  * В нем нет шаблонизации
  * Как правило ничего не пишет в response.

Только получает данные и все.

---

## descript-блок

descript-блок это такой объект, описывающий как получать те или иные данные.
Блоки можно переиспользовать, доопределять и расширять, собирать из них более сложные блоки и т.д.
Блоки бывают разных типов (`http`, `file`, ...), но у всех у них одинаковый интерфейс.

---

## descript-блок

    try {
        const result = await block.run();

    } catch ( e ) {
        ...
    }

---

## descript-блок

    const result = await block.run( {
        params,
        context,
        cancel,
        ...
    } );

Блок создается, как правило, один раз и неизменяем (нет стейта).

---

## Виды блоков

Базовые: `http`, `file`, `value`.

Составные: `object`, `array`, `func`.

---

## Определение блока

    const de = require( 'descript' );
    const block = de.<type>( {
        block: {
            ...
        },
        options: {
            ...
        },
    } );

---

## Определение блока

[Примеры](https://github.com/pasaran/descript3/blob/master/docs/examples-01-basics.md)

---

## Жизненный цикл блоков

  * `options.deps`
  * `options.params`
  * `options.guard`
  * `options.before`
  * `options.cache`
  * action
  * `options.after` / `options.error`

---

## `options.deps`

Позволяет выполнить блок после указанных блоков.
Все происходит внутри `de.object` или `de.array` только.

---

## `options.params`

    const params = {
        ...
    };
    block.run( { params } );

---

## `options.params`

Позволяет переопределить параметры, которые приходят в блок:

    options: {
        params: ...
    },

---

## `options.params`

    params: ( { params, context, deps } ) => ( {
        ...params,
        debug: 'true',
    } ),

---

## `options.params`

    params: {
        mark: null,
        page_num: 1,
        debug: ( { context } ) =>
            ( context.config.env === 'development' ),
    },

---

## `options.params`

    params: ( { params, context } ) => ( {
        mark: params.mark,
        page_num: ( params.page_num !== undefined ) ?
            params.page_num : 1,
        debug: ( context.config.env === 'development' ),
    } ),

---

## `options.params`

    parent.parans   ->  child.params

---

## `options.params`

    block( {
        options: {
            params: ( { params } ) => ( {
                ...params,
                id: 42,
            } ),
        },
    } )

---

## `options.guard`

Выполнять или не выполнять блок.

    guard: ( { params } ) => Boolean( params.id ),

Если гард возвращает falsy-значение, то блок не выполняется и результатом его
будет ошибка:

    de.error( {
        id: de.ERROR_ID.BLOCK_GUARDED,
    } );

---

## `options.before`

Можно до запуска экшена или бросить ошибку, или вернуть какое-то значение,
которе и будет использовано как результат экшена. Экшен при этом не вызывается.

Ну или просто сделать что-нибудь (что?).

---

## `options.before`

    before: ( { params } ) => {
        if ( !params.foo ) {
            throw de.error( {
                id: 'INVALID_ERROR',
            } );
        }
    },

---

## `options.before`

    before: ( { params } ) => {
        if ( params.bar ) {
            return {
                bar: params.bar,
            };
        }
    },

---

## `options.before`

    before: () => {
        //  Do something.

        return undefined;
    },

---

## `options.before`

    parent.before   <-  child.before    !?!

---

## `before` vs `guard`

Можно обойтись и before, но guard короче:

    before: ( { params } ) => {
        if ( !params.id ) {
            throw de.error( {
                id: de.ERROR_ID.BLOCK_GUARDED,
            } );
        }
    },

---

## `options.after`

Возможность как-то обработать получившийся результат:

  * Бросить ошибку.
  * Постобработать результат.
  * Выставить куки и т.д.

---

## `options.after`

    after: ( { result } ) => {
        if ( result.status !== 'ok' ) {
            throw de.error( {
                id: 'SOME_ERROR',
            } );
        }
    },

---

## `options.after`

    after: ( { result } ) => {
        return {
            status: 'ok',
            data: result.data,
        };
    },

---

## `options.after`

    after: ( { context, result } ) => {
        const session_id = result.session.id;

        context.res.cookie( 'session_id', session_id );

        return undefined;
        //  return result;
    },

---

## `options.after`

    parent.after    ->  child.after

---

## `before` vs `after`

Если `before` что-то возвращает (или throws), то прекращение цепочки останавливается.
Поэтому, когда мы переопределеяем before, имеет смысл выполнять его до родительского.

А если `after` что-то возвращает, то результат отправляется в следующий элемент цепочки.
И здесь наоборот.

---

## Аргументы у `options.*`

    options: {
        after: ( { ... } ) => {
            //  Do something.
        },
    },

---

## Аргументы у `options.*`

    { params, context, cancel } //  всегда
    { get_id }                  //  в de.func
    { deps }                    //  если есть
    { result }                  //  после успешного action
    { error }                   //  после ошибки
    { ??? }                     //  в query, headers, body (?)

---

## Жизненный цикл у потомка

    deps
    parent.params   ->  child.params
    parent.guard    ->  child.guard
    parent.before   <-  child.before    !?!
    action
    parent.after    ->  child.after

    parent.error    ->  child.error

---

## Не наследуется

    options.id
    options.deps
    options.required
    options.priority

---

## Моржится

    block.query         options.params
    block.headers       options.guard ???
                        options.before
                        options.after
                        options.error

---

## Перезатирается

    block.*             options.name
                        options.timeout
                        options.key
                        options.maxage
                        options.cache

---

## no options

[no options](https://github.com/pasaran/descript3/blob/master/docs/examples-02-no-options.md)

---

## `de.http`

[de.http](https://github.com/pasaran/descript3/blob/master/docs/examples-03-http-block.md)

---

## Иерархия http-блоков

  * Ресурсы
  * Методы
  * Блоки
  * Еще блоки

---

## Иерархия http-блоков

    resources
        ...
        public_api
            methods
                do_something.js
                ...
            get_resource.js
        ...

---

## Иерархия http-блоков. Ресурс

Условно, ресурс — это комбинация protocol, host и port.
Все такие запросы должны использовать de-блок ресурса в качестве предка.
Такой блок должен быть единственным.
Не должно быть `public_api` и `public_api_card`.

---

## Иерархия http-блоков. Ресурс

    //  get_resource.js
    module.exports = de.http( {
        block: {
            protocol: 'http:',
            host: 'api.auto.ru',
            port: 9000,
        },
        options: ...
    } );

---

## Иерархия http-блоков. Ресурс

    block.protocol      options.after
    block.host          options.error
    block.port          options.cache
    block.headers
    block.auth
    block.agent

    block.ca, ...

---

## Иерархия http-блоков. Метод

Метод — это комбинация path и method (GET, POST, ...) внутри определенного ресурса.
Все такие запросы должны использовать de-блок метода в качестве предка.
Такой блок должен быть единственным.

Метод не должен переопределять protocol, host, protocol.

---

## Иерархия http-блоков. Метод

    //  methods/do_something.js
    module.exports = require( '../get_resource' );
    const method = resource( {
        block: {
            method: 'POST',
            path: '/1.0/do_something',
        },
        options: ...
    } );

---

## Иерархия http-блоков. Метод

    block.method        options.key
    block.path          options.maxage
    block.query         options.is_error
    block.body          options.after
    block.headers       options.error
    block.timeout

---

## Иерархия http-блоков. Блок

Ни ресурсы, ни методы не должны напрямую запускаться. Для этого есть блоки.
Блок наследуюется от метода (или нет). При этом может быть много блоков, которые ходят в один метод.

Так же блоки используются для комбинации нескольких методов.

---

## Иерархия http-блоков. Блок

    //  blocks/do_something.js
    module.exports = require( '.../methods/do_something' );

---

## Иерархия http-блоков. Блок

    const method = require( '.../methods/do_something' );
    module.exports = method( {
        options: {
            params: ( { params } ) => {
                ...params,
                debug: true,
            },
        }
    } );

---

## Чего не должны быть в блоке

    options.params (*)
    options.id
    options.deps
    options.guard
    options.required

---

## Иерархия http-блоков. Блок

    blocks/
        session.js
        index/
            presets.js
            ...
        listing/
            listing.js
            ...

---

## Иерархия http-блоков. Блок

    www-desktop/server/blocks
    auto-core/server/blocks


`session`, `index/presets`, `listing/listing` ... — это block-id.

---

## Универсальная аякс-ручка

    get_blocks( [
        {
            block_id: 'session',
        },
        {
            block_id: 'listing/listing',
            block_params: { ... },
        },
    ] )

---

## Иерархия http-блоков. Блок

**Вопрос.** Где хранить мета-информацию типа списка всех параметров и флага `need_auth`?

**Ответ.** ХЗ

---

## Cookbook

---

## Результат блока как параметр другого блока?

    module.exports = async function( args ) {
        const result = await block1.run( args );
        const params = {
            id: result.id,
        };
        return block2.run( { ...args, params } );
    };

---

## Как неправильно делать редирект

    after: ( { context } ) => {
        context.res.statusCode = 302;
        context.res.setHeader( 'Location', '...' );
        context.res.end();
    },

Вообще никогда не нужно делать `res.end()` изнутри дескрипта.

---

## Как правильно делать редирект

    after: ( { cancel } ) => {
        cancel( de.error( {
            id: de.ERROR.REDIRECT,
            location: '...',
            status_code: 302,
        } );
    },

---

## Как правильно делать редирект

    try {
        const result = await block.run( params, context );
    } catch ( e ) {
        if ( de.is_error( e ) ) {
            if ( e.error.id === de.ERROR.REDIRECT ) {
                ...
            }
        }
    }

---

## Как считать ошибку не ошибкой

    is_error: ( error, request_options ) => {
        const status_code =
            no.jpath( '.error.status_code', error );
        if ( status_code === 404 ) { return false; }

        return de.request.DEFAULT_OPTIONS.is_error( error, request_options );
    },

---

## Как писать в лог кастомные сообщения

    console.log

---

## `no.jpath`

[jpath](https://github.com/pasaran/nommon/blob/master/docs/jpath.md)

---

## `v2 -> v3`

  * Работа с зависимостями и стейтом.
  * Работа с параметрами.

[Миграция v2 -> v3](https://github.com/pasaran/descript3/blob/master/docs/examples-04-v2-v3.md).

