# descript2

## Что такое `descript`

`descript` — агрегатор данных из разных источников.

---

## Чем `descript` не является

  * Это не веб-сервер, принимающий входящие запросы
  * В нем нет роутинга
  * В нем нет шаблонизации
  * Как правило ничего не пишет в response.

Только получает данные и все.

---

## Блоки

---

## Блоки

У каждого блока есть:

  * Тип (`http`, `file`, ...)

  * Набор свойств (своих для каждого типа), например, для `http`-блока
    это может быть `url`, а для `file`-блока — `filename`.

  * Набор необязательных опций (единый для всех типов), разным образом
    меняющих поведение блока.

---

## Блоки

    const de = require( 'descript2' );
    const block = de.http( {
        block: {
            url: 'http://foo.com',
        },
        options: {
            id: 'foo',
        }
    } );

---

## Типы блоков

  * `http`
  * `file`
  * `value`
  * `array`
  * `object`
  * `func`

---

## Запуск блока

    block + params + context -> promise -> result

---

## Запуск блока

    const block = de.http( ... );
    const context = new de.Context( ... );

    context.run( block, params )
        .then( result => {
            //  Do something.
        } )

---

## `Promise` vs `no.Promise`

    promise.then(
        result => {
            //  Success.
        },
        error => {
            //  Error.
        }
    );

---

## `Promise` vs `no.Promise`

    promise.then( result => {
        if ( de.is_error( result ) ) {
            //  Error.
        } else {
            //  Success.
        }
    );

---

## `de.http`

Основные параметры блока: `protocol`, `port`, `host`, `path`, `method`, `query`, `body`, `headers`, `with_meta`.

---

## `de.http`

    const public_api = de.http( {
        block: {
            host: 'autoru-api-01-sas.test.vertis.yandex.net',
            port: 2600,
            headers: ...,
        },
        options: ...
    } );

---

## `de.http`

    const login = public_api( {
        block: {
            path: '/1.0/auth/login',
            method: 'POST',
            body: ( params ) => {
                login: params.login,
                password: params.password
            }
        }
    } );

---

## "Наследование"

    const block1 = de.http( { block: ..., options: ... } );
    const block2 = block1( { block: ..., options: ... } );
    const block3 = block2( { block: ..., options: ... } );
    ...

---

## `context.config`

    const public_api = de.http( {
        block: {
            host: 'autoru-api-01-sas.test.vertis.yandex.net',
            port: 2600,
        },
    } );

---

## `context.config`

    const public_api = de.http( {
        block: {
            host: datasource.get(
                'autoru_frontend.publicapi.host' ),
        },
    } );

---

## `context.config`

    const public_api = de.http( {
        block: {
            host: (IS_DEV) ?
                'zvez-01-sas.dev.vertis.yandex.net' :
                datasource.get(
                    'autoru_frontend.publicapi.host' ),
        },
    } );

---

## `context.config`

    const ctx_options = {
        config: {
            public_api: {
                host: datasource.get(
                    'autoru_frontend.publicapi.host' ),
            },
        }
    };
    const context = new de.Context( req, res, ctx_options );

---

## `context.config`

    const public_api = de.http( {
        block: {
            host: de.jexpr(
                'context.config.public_api.host' ),
        },
    } );

---

## `de.jexpr`

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

## `de.jstring`

    const social_login_auth_url = public_api( {
        block: {
            path: de.jstring(
                '/1.0/auth/login-social/auth-uri/\
                    { params.provider }'
            ),
            ...
        }
    } );

---

    const social_login_auth_url = public_api( {
        block: {
            path: function( params, context, state ) {
                return `/1.0/auth/login-social/\
                    auth-uri/{ params.provider }`;
            },
        }
    } );

---

## Сигнатуры descript-функций

    function( params, context, state [, result ] ) {
        ...
    }

---

## `block.headers`

    de.http( {
        block: {
            headers: {
                'x-request-id': de.jexpr( 'context.req.requestId' ),
                'x-real-ip': de.jexpr( 'context.req.clientIp' ),
                ...
            }

---

    headers: function( params, context, state ) {
        return {
            'x-device-uid': context.get_cookie('autoruuid') || '',
            'x-session-id': context.get_cookie('autoru_sid') || '',
            'x-authorization':
                no.jpath('.config.public_api.key', context),
            'content-type': 'application/json',
            ...
        };

---

##  headers extend

    const block1 = de.http( {
        block: {
            headers: headers1,
            ...

    const block2 = block1( {
        block: {
            headers: headers2,
            ...

---

##  headers extend

    const headers = Object.assign(
        {},
        headers1(),
        headers2()
    );

---

## `block.query`

Сейчас все параметры, попавшие в блок, уходят в query, если `block.query` не задано.
Для post/put/patch-запросов это, видимо, не очень удачное решение, будет изменено.

    block: {
        ...
        method: 'POST',
        query: {},
    }

---

## `block.body`

    block: {
        body: function( params, context, state ) {
            return {
                login: params.login,
                password: params.password,
            };
        }

---

## `block.body`

Что можно вернуть из `block.body`:

  * `Buffer` -> `application/octet-stream`
  * `String` -> `text/plain`
  * `Object` + `application/json` -> `JSON.stringify`
  * `Object` -> `application/x-www-form-urlencoded` + `querystring.stringify`

---

## `block.with_meta`

Результат будет вида:

    {
        status_code: ...,
        headers: ...,
        result: result,
    }

---

## `block.is_error`

    block: {
        is_error: function( status_code, headers ) {
            return ( status_code >= 400 );
        }

---

## `block.agent`

    block: {
        agent: {
            keepAlive: true,
            maxSockets: 16
        }

---

## `block.extra`

    block: {
        extra: {
            name: 'public_api'
        }

---

## Retries

    block: {
        max_retries: 1,
        is_retry_allowed: function( status_code, headers ) {
            return true;
        },
        retry_timeout: 500,
        ...
    }

---

## `de.object` и `de.array`

    const block = {
        session: public_api.session,
        chat_list: chat.chat_list,
        ...
    };

---

## `{}` vs `de.object`

    const block = de.object( {
        block: {
            session: public_api.session,
            ...
        },
        options: {
            timeout: 1000,
        }
    } );

---

## `de.value`

    const block = {
        session: public_api.session,
        some_static_data: {
            foo: 42,
            bar: 24,
            ...
        }
    };

---

## `de.value`

    const block = {
        session: public_api.session,
        some_static_data: de.value( {
            block: {
                foo: 42,
                bar: 24,
                ...
            }
        } ),
    };

---

## `de.file`

    const block = de.file( {
        block: {
            filename: 'dicts/categories.json',
        }
    } );

---

## `de.func`

    const block = de.func( {
        block: function( params, context, state ) {
            return de.http( {
                block: {
                    url: `${ base_url }/?id=${ params.id }`
                }
            } );
        }
    } );

---

## `de.func`

Можно вернуть:

  * Значение

  * no.Promise

  * Другой блок

---

## `options`

  * Набор параметров, управляющих поведением блока до и после action'а.

  * Этот набор — общий для всех типов блоков.

Более-менее актуальное [описание](https://github.com/pasaran/descript2/blob/master/docs/options.md).
Плюс [порядок применения](https://github.com/pasaran/descript2/blob/master/docs/phases.md) разных options.

---

  * `options.deps`
  * `options.guard`
  * `options.before`
  * `options.key`, `options.maxage`
  * `options.params`, `options.valid_params`
  *  action
  * `options.error`
  * `options.select`
  * `options.after`
  * `options.result`

---

## State

    context.run( block, params, state )
        .then( ... );

---

## `options.id`

    options: {
        id: 'some-block'
    }

---

## `options.id`

    {
        foo: block,
        bar: block,
    }

---

## `options.id`

    {
        foo: block( {
            options: 'id1'
        } ),
        bar: block( {
            options: 'id2'
        } )
    }

---

## `options.deps`

Возможность управлять порядком выполнения блоков. Три способа:

  * Список id блоков, после выполнения которых можно запускать блок.
  * Условие, после выполнения которого можно запускать блок.
  * Приоритеты.

---

    options: {
        deps: 'block-1'
    }

    options: {
        deps: [
            'block-1',
            'block-2',
        ]
    }

---

    const block_1 = ...;
    const block_2 = ...;
    const block_3 = de.block( {
        options: {
            deps: [
                block_1,
                block_2
            ]
        }
    } )

---

    const block_3 = de.object( {
        block: {
            foo: block_1( ... )
        },
        options: {
            deps: block_1
        }
    } )

---

    const block_1 = de.block( {
        options: {
            select: {
                foo: de.jexpr( '.foo' )
            }
        ...

    const block_2 = de.block( {
        options: {
            deps: de.jexpr( 'state.foo' )
        ...

---

    {
        foo: block_1( {
            options: {
                priority: 10
            }
        } ),
        bar: block_2,
        quu: block_3
    }

---

## `options.guard`

    options: {
        guard: function( params, context, state ) {
            return ( params.id && state.auth );
        }
    }

---

## `options.guard`

    options: {
        guard: de.jexpr( 'params.id && state.auth' )
    }

---

## `options.before`

    options: {
        before: function( params, context, state ) {
            if ( !params.id ) {
                return de.error( {
                    id: 'INVALID_PARAMS'
                } )
            }
            state.foo = 42;
        },

---

## `options.guard` vs `options.before`

  * `options.guard` синхронный и без side effects.

  * `options.before` может вернуть промис или ошибку,
    может сделать редирект и т.д.

---

## `options.key` и `options.maxage`

    options: {
        key: de.jstring( '{ params.mark }-{ params.model }' ),
        maxage: 86400
    }

---

## Cache

    const cache = {
        get: function( key ) { ... },
        set: function( key, value, maxage ) { ... },
    };

    const context = new de.Context( req, res, {
        cache: cache
    } );

---

## `options.cache`

Пока нет, но можно и сделать. Конкретно этот блок кэшировать как-то иначе.
Например, все в memcache, а этот блок в памяти.

---

## `options.params`

    options: {
        params: function( params, context, state ) {
            return {
                offer_id: `${ params.sale_id }-${ params.sale_hash }`
            };
        }
    }

---

## `options.params`

    options: {
        params: {
            foo: 42,
            bar: de.jexpr( 'state.bar' ),
            quu: function( params, context, state ) {
                return params.quu;
            }
        }
    }

---

## `options.valid_params`

    options: {
        valid_params: {
            id: null,
            category: 'cars'
        }
    }

---

## `options.error`

    options: {
        error: function( params, context, state, error ) {
            const id = no.jpath( '.error.id', error );
            if ( id === 'NOT_REALLY_ERROR' ) {
                return {
                    status: 'ok'
                };
            }
        },

---

## `options.after`

    options: {
        after: function( params, context, state, result ) {
            //  Do something.
        }
    }

---

## `options.select`

    options: {
        select: {
            foo: de.jexpr( '.foo' )
        }
    }

---

## `options.select`

    options: {
        after: function( params, context, state, result ) {
            state.foo = de.jexpr( '.foo' )
                ( params, context, state, result );
        }
    }

---

## `options.result`

    options: {
        result: function( params, context, state, result ) {
            return {
                id: result.foo.bar.id,
            }
        }
    }

---

## `options.result`

    options: {
        result: {
            id: de.jexpr( '.foo.bar.id' )
        };
    }

---

## `options.result`

    options: {
        result: {
            foo: {
                bar: de.jexpr( '.foo.bar' )
            }
        };
    }

