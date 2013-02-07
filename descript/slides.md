descript
========

descript
--------

Замена xscript'а, написанная на `node.js`.

  * Агрегация данных из разных источников в одно json-дерево.

  * Опциональная шаблонизация (включая "перблочную").

---

`descript` состоит из трех частей:

  * DSL для описания источников данных и того, как их нужно
    скомпоновать в результирующее дерево
    (аналог xml-файлов для `xscript`-а).

  * js-библиотека, разбирающая этот DSL и исполняющая его.

  * Простое приложение, принимающее http-запросы и исполняющее их.

---

DSL
---

Представляет собой обычный js-объект, в котором специальным образом
размечены разные "блоки": `http`, `file` и т.д.

Точно так же, как в `xscript`-е отдельные xml-теги имели специальное значение.

---

Пример:

    {
        //  Подключаем common.
        common: 'common.jsx',

        data: {
            foo: 'http://www.data.com/?',
            bar: '{ config.dir }/bar.{ .id }.json'
        }
    }

---

`http`
------

Если строка начинается с `http://`, то это `http`-блок:

    'http://some.domain.com/some/path'
    'http://some.domain.com/some/path?id=42'

    'http://some.domain.com/some/path?'
    'http://some.domain.com/some/path?id=42&'

    'http://{ config.host }/?id={ .id }'

---

`http`
------

"Функциональная" форма:

    de.http('http://{ config.host }?id={ .id }')


    de.http('http://{ config.host }?id={ .id }', {
        ...
    })

---

`file`
------

Строка, заканчивающаяся на `.json` --- это `file`-блок.

    'data.json'
    'data.{ .id }.json'

    de.file('data.json', {
        ...
    })

---

`include`
---------

Строка, заканчивающаяся на `.jsx` --- это подключение другого файла.

    'common.jsx'
    'page.{ .name }.jsx'

    de.include('common.jsx', {
        ...
    })

---

`value`
-------

Строки, не являющиеся специальными, числа, `true`, `false`, `null`
выводятся как есть.

    {
        foo: 42,
        bar: de.value('http://some.domain.com')
    }

---

`call`
------

Вызов "метода" некоторого "серванта".
На самом деле, это просто возможность создавать шоткаты для громоздких конструкций.

    'foo()'

    de.call('mail:foo()', {
        ...
    })

---

`call`
------

Например, некий "сервант" принимает запросы вида:

    'http://some.domain.com/getFoo?__uid=2345676&id=345&...'

т.е. `getFoo` это название метода, есть служебные параметры `__uid` и т.д.
Чтобы не писать все это каждый раз, можно сделать шоткат:

    'getFoo()'

---

`func`
------

    function(params, context) {
        return (params.foo) ? 'getFoo()' : 'getBar()';
    }

    de.func(function(params, context) { ... }, {
        ...
    })

---

`array` и `object`
------------------

Если нужно задать какие-то опции:

    de.array([ ... ], {
        ...
    })

    de.object({ .... }, {
        ...
    })

---

`block`
-------

Блок общего назначения. Тип будет определен автоматически:

    de.block('http://foo.bar.com')

---

Приоритеты
----------

По-дефолту все блоки запускаются параллельно. Но можно явно задать порядок выполнения блоков.

    'file.json' +10
    'common.jsx' +20
    'foo()' +30

    de.http('http://foo.bar.com') +40

---

Приоритеты
----------

    [
        de.http('http://foo.bar.com', {
            select: {
                'id': '.data.id'
            }
        }) +10,

        de.file('data.{ state.id }.json')
    ]

---

Приоритеты
----------

    {
        a: de.object({
            b: 'file.json' +10,
            c: 'foo()'
        }) +20,
        d: de.array([
            'bar()' +10, 'boo()' +30
        ])
    }

---

context
-------

На каждый запрос создается объект, к которому имеют доступ все блоки
из этого запроса.

    context = {
        request: { ... },
        response: { ... },
        state: { ... },
        config: { ... }
    }

---

options
-------

Во все `de.*()` вторым аргументом можно передать объект с дополнительными опциями.

В частности, там можно указать поля: `guard`, `before`, `after`, `select`, `result`,
`key`, `maxage`, `params`, `timeout`, `datatype`.

---

options.guard
-------------

Возможность не выполнять вызов блока, если не выполняется некое условие.

Может быть задан строкой, содержащей `jpath`-выражение или же функцией.

Если гвард не срабатывает, блок не выполняется, а результатом блока будет `null`.

---

options.guard
-------------

    guard: '.id != 0 && !state.foo'

    guard: function(params, context) {
        return !!params.foo;
    }

---

options.before и options.after
------------------------------

Возможность совершить какое-нибудь действие (например, положить
что-нибудь в стейт) до и после вызова блока.

В `before` приходит `params` и `context`, в `after` --- `result` и `context`.

---

options.before и options.after
------------------------------

    before: function(params, context) {
        context.state.foo = 42;
    }

    after: function(result, context) {
        context.state.bar = result.bar;
    }

---

options.select
--------------

Достает из результата блока значения jpath'ов
и складывает в стейт под соответствующими именами.

    select: {
        id: '.data.id',
        title: '.data.items[0].title'
    }

---

options.result
--------------

    result: '.foo.bar'

    result: {
        foo: '.foo',
        bar: [ '.bar' ]
    }

---

options.key и options.maxage
----------------------------

Закэшировать блок на заданное время:

    key: '{ .id }-{ .album-id }',
    maxage: '+1h'

    key: function(params, context) {
        return 'foo-' + params.id;
    }

---

options.params
--------------

По-дефолту в блок приходят параметры из реквеста.
Иногда нужно изменить эти параметры на другие.

    params: function(params) {
        return {
            id: params.id,
            foo: 42
        };
    }

---

options.timeout
---------------

Таймаут блоков можно задать либо глобально в конфиге,
либо по-блочно. Если таймаут не задан никак, то берется
дефолтный --- 5 секунд.

    timeout: 3000

Задается в миллисекундах.

---

options.datatype
----------------

http-ответы и содержимое файлов может содержать json или же просто текст.

    datatype: 'json'

---

options.template
----------------

Пока что нет, но будет что-то вроде:

    template: 'page.yate'

    template: 'page.js'

---

Приложение descript
-------------------

    descript --port 2000


