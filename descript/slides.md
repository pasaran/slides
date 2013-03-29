descript
========

descript
--------

  * [pasaran.github.com/slides/descript](http://pasaran.github.com/slides/descript) — слайды.

  * [git.io/descript](http://git.io/descript) — репозиторий на github'е.

  * [git.io/nop](http://git.io/nop) — все мои проекты.

Сергей Никитин  
[nop@yandex-team.ru](mailto:nop@yandex-team.ru)

---

Коротко о главном
-----------------

  * Замена `xscript`-у, написанная на `node.js`.

  * Агрегация данных из разных источников в одно json-дерево.

  * Опциональная шаблонизация (включая "перблочную").

  * JS API и отдельное приложение.

---

План доклада
------------

  * Долго рассказывать про `xscript`.

  * Упоминуть, что `descript` это почти тоже самое.

  * ???

  * Profit

---

xscript
-------

  > Дальше не придумали, импровизируй.

---

xscript
-------

  * Аггрегация данных.

  * Обычный xml плюс специальные "блоки".

  * (А)синхронность.

  * (Перблочная) шаблонизация.

---

descript
--------

Установка:

    npm install descript

---

`descript` состоит из трех частей:

  * DSL для описания источников данных и того, как их нужно
    скомпоновать в результирующее дерево
    (аналог xml-файлов для `xscript`-а).

  * js-библиотека, разбирающая этот DSL и исполняющая его.

  * Простое приложение, принимающее http-запросы и исполняющее их.

---

Приложение descript
-------------------

    descript --port 2000 --rootdir jsx
    descript --socket descript.sock --rootdir jsx
    descript --config config.js

    http://127.0.0.1:2000/hello.jsx

Будет исполнен файл `jsx/hello.jsx`.

---

    //  hello.jsx
    de.block(
        { username: 'nop' },
        { template: 'hello.js' }
    )

    //  hello.js
    function(data) {
        return 'Hello, ' + data.username;
    }

---

JS API
------

    var de = require('descript');

    de.Block.compile({
        data: 'http://www.data.com?'
    })
        .run({ id: 42 })
            .then(function(result) {
                console.log( result.object() );
            });

---

`.jsx`-файлы
------------

Внутри обычный javascript, в котором специальным образом
размечены разные "блоки": `http`, `file` и т.д.

Точно так же, как в `xscript`-е отдельные xml-теги имели специальное значение.

---

    {
        common: 'common.jsx',
        auth: 'ya:auth()',
        data: {
            foo: [
                'http://www.foo.com/?',
                'http://www.bar.com/?
            ],
            bar: '{ config.static-dir }/{ .id }.json'
        }
    }

---

Интерполяция в строках
----------------------

Во многих местах, где используются строки, в них возможна подстановка параметров и выражений.

    'http://{ config.host }/foo/bar?id={ .id }'

Внутри `{ ... }` — jpath-выражение. Либо отложенное от одной из предопределенных
переменных (`config`, `state`, `request`, ...), либо же от параметров блока.

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

    de.http('{ config.url }?id={ .id }')


    de.http('{ config.url }?id={ .id }', {
        ...
    })

---

`file`
------

Строка, заканчивающаяся на `.json`, `.txt`, `.html`, `.xml` — это `file`-блок.

    'data.json'
    'data.{ .id }.json'

    de.file('data.{ .ext }', {
        ...
    })

---

`include`
---------

Строка, заканчивающаяся на `.jsx` — это подключение другого файла.

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

    de.call('ya:auth()', {
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

    de.block('http://foo.bar.com', {
        ...
    })

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

    [
        de.array([
            'a()' +10, 'b()' +30
        ]),
        de.array([
            'c()' +10, 'd()'
        ]) +20
    ]

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

В частности, там можно указать поля: `guard`, `params`, `before`, `after`, `select`, `result`,
`key`, `maxage`, `timeout`, `template`, ...

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

options.params
--------------

    params: {
        'id': '.id',
        'version': 42
    }

---

options.params
--------------

    params: function(params, context) {
        return {
            id: params.id,
            version: 42
        };
    }

---

options.before и options.after
------------------------------

Возможность совершить какое-нибудь действие (например, положить
что-нибудь в стейт, выставить куку, ...) до и после вызова блока.

---

options.before и options.after
------------------------------

    before: function(params, context) {
        context.state.foo = 42;
    }

    after: function(result, context, params) {
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

options.timeout
---------------

Прервать выполнение блока, если оно заняло больше указанного времени:

    timeout: 3000

Задается в миллисекундах.

---

options.template
----------------

Наложить на результат шаблон из указанного файла:

    template: 'hello.js'

---

options.template
----------------

    //  hello.js
    function(data) {
        return 'Hello, ' + data.username;
    }

---

options.template
----------------

    //  hello.js
    (function() {
        var username = 'John';

        return function(data) {
            return 'Hello, ' + (data.username || username);
        }
    })();

---

options.template
----------------

Хочется уметь так:

    template: 'hello.yate'

Для `yate`, `mustache`, ...
Плюс возможность написать свой модуль.

---

Что дальше
----------

  * Работающее JS API.

  * Шаблонизация из коробки.

  * Контролируемое кэширование.

  * Обработка ошибок.

  * Тесты!

---

Всё
---

  * [pasaran.github.com/slides/descript](http://pasaran.github.com/slides/descript) — слайды.

  * [git.io/descript](http://git.io/descript) — репозиторий на github'е.

  * [git.io/nop](http://git.io/nop) — все мои проекты.

Сергей Никитин  
[nop@yandex-team.ru](mailto:nop@yandex-team.ru)

