Ещё один шаблонизатор
---------------------

  * Это шаблонизатор
  * Шаблонизатор общего назначения
  * В первую очередь для client side
  * Удобный и читаемый синтаксис
  * Похожий на `XSLT`
  * Безопасность

---

Шаблоны
-------

Аналог `xsl:template match="..."`:

    match .page title {
        <h1>Hello, { .username }</h1>
    }

---

Шаблоны
-------

То же самое в `XSLT`:

    <xsl:template match="page mode="title">
        <h1>
            <xsl:text>Hello, </xsl:text>
            <xsl:value-of select="username"/>
        </h1>
    </xsl:template>

---

JPath
-----

  * Аналог `XPath` в `XSLT`.
  * Более `js`-подобный синтаксис.
  * Нет осей, кроме `self`, `child` и `parent`.

---

JPath. Примеры
--------------

    .foo                        foo
    .foo.bar                    foo/bar
    .                           .
    .*                          *
    ..                          ..
    ...                         ../..
    ...foo.bar                  ../../foo/bar

---

JPath. Предикаты
----------------

    .item[ index() < 3 ]        item[ position() &lt; 4 ]
    .item[ .count || .title ]   item[ count or title ]
    .item[ .selected ]          item[ selected ]
    .item[ .count > 5 ]         item[ count &gt; 5 ]
    .item[ !.selected ]         item[ not(selected) ]
    .*[ name() == 'item' ]      *[ name() = 'item' ]

---

Шаблоны. Выражения
------------------

  * `xml`-строки
  * Текстовые строки
  * Значения
  * `xml`-атрибуты
  * `if`, `for`, `apply`

---

Выражения. XML-строки
---------------------

    match / {
        <h1>Hello, { .username }</h1>
        <div class="content" id="id-{ .id }">
            .content
        </div>
    }

---

Выражения. Текстовые строки
---------------------------

Аналог `xsl:text` с интерполяцией:

    match / {
        "Hello"
        "Hello, { .username }"
    }

Одинарные кавычки и двойные — одно и тоже.

---

Выражения. Значения
-------------------

Аналог `xsl:value-of`:

    match / {
        <div class="content">
            .content
        </div>
    }

Это может быть `jpath`, значение переменной,
и вообще произвольное инлайновое выражение.

---

Выражения. Значения
-------------------

    answer = 42

    match / {
        .content
        .count + 1
        answer
        getTitle()
    }

---

Выражения. XML-атрибуты
-----------------------

Неполный аналог `xsl:attribute`:

    match / {
        <div>
            @class = "hello"
            "Hello"
        </div>
    }

---

Выражения. XML-атрибуты
-----------------------

    match / {
        <div class="hello">
            if .title {
                @title = .title
            }
        </div>
    }

---

Выражения. XML-атрибуты
-----------------------

    match / {
        <div>
            apply . class
        </div>
    }

    match / class {
        @class = "hello"
    }

---

Выражения. XML-атрибуты
-----------------------

    match / {
        <div class="hello">
            if .username {
                @class += " username"
                //  @class = "{ @class } username"
            }
        </div>
    }

Временный синтаксис.

---

Выражения. XML-атрибуты
-----------------------

    match / {
        attrs = (
            @width = 42
            @height = 24
        )

        <img src="logo.png">
            attrs
        </img>
    }

---

Выражения. `if`
---------------

Аналог `xsl:if` и `xsl:choose`:

    <span class="count">
        if .count > 5 {
            .count
        } else {
            5
        }
    </span>

---

Выражения. `for`
----------------

Аналог `xsl:for-each`:

    <ul>
        for .items.item {
            <li>{ .title }</li>
        }
    </ul>

---

Выражения. `apply`
------------------

Аналог `xsl:apply-templates`:

    match / {
        apply .page title
        apply .page
    }

---

Выражения. `apply`
------------------

Первый аргумент `apply` любой `nodeset`,
не обязательно `jpath`:

    match / {
        items = .items.item
        apply items
        apply .title | .subtitle
        apply items()
    }

---

Выражения. `apply`
------------------

Можно передавать параметры:

    match / {
        apply .page title ( .title )
    }

    match .page title ( title = "Hello" ) {
        <h1>{ title }</h1>
    }

---

Выражения
---------

`if`, `for`, `apply` — выражения.

    title = if .title {
        .title
    } else {
        "Hello"
    }

    <h1>{ title }</h1>

---

Определения. Переменные
-----------------------

Аналог `xsl:variable`:

    match / {
        title = <h1>Hello, { .username }</h1>
        hello = "Hello, { .username }"
        count = 42
        items = .items.item
        isValid = .count > 5 && .title
        class = @class = "hello"
    }

---

Определения. Переменные
-----------------------

    content = (
        <h1>Hello, { .username }</h1>
        <ul>
            for .item {
                <li>{ .title }</li>
            }
        </ul>
    )

---

Определения. Переменные
-----------------------

Переменные — **неизменяемы**:

    match / {
        a = 42
        a = "Hello" // Ошибка!
    }

В одном scope не могут быть определены
две переменные с одинаковым именем.

---

Определения. Переменные
-----------------------

В каждом блоке `{ ... }` и `( ... )` свой scope:

    a = 42
    a
    if .username {
        a = 24
        a
    }
    a

---

Определения. Функции
--------------------

Аналог одновременно `xsl:template name="..."` и `func:function`:

    func add(a, b) {
        a + b
    }
    add(42, 24)

Тело функции является её возвращаемым значением.

---

Определения. Функции
--------------------

    func title(title = "Hello") {
        <h1>{ title }</h1>
    }

    match / {
        title(.title)
        title()
    }

---

Определения. Функции
--------------------

Функция может возвращать не только `xml`:

    func items() {
        .items.item
    }

    func isValid() {
        .count > 5 && .title
    }

---

Определения. Функции
--------------------

Вложенные функции:

    match / {
        fact(4)

        func fact(n) {
            if n == 1 { 1 } else { n * fact(n - 1) }
        }
    }

---

Определения. Ключи
------------------

В `XSLT` ключ определяется так:

    <xsl:key name="items" match="items/item" use="id"/>

    <xsl:value-of select="key('items', 'first')/title"/>

---

Определения. Ключи
------------------

Некий аналог `xsl:key`:

    key items( .items.item, .id ) {
        .
    }

    items("first").title

---

Определения. Ключи
------------------

Ключ может возвращать не только соответствующую ноду,
но и произвольное выражение вычисленное по этой ноде:

    key labels( .labels.label, .id ) {
        <div class="label">
            <a href="/label/{ .id }">{ .title }</a>
        </div>
    }

    labels("42")

---

Разное. `include`
-----------------

    include "common.yate"
    match / {
        //  include "common.yate"
        "Hello, { username }"
    }

и в `common.yate`:

    username = "nop"

---

Разное. `external`
-----------------

Можно подключать внешние функции, реализованные отдельно
на обычном `javascript`:

    external nodeset reverse(nodeset)

    match / {
        apply reverse(.items.item)
    }

---

Разное. `external`
-----------------

В отдельно подключаемом js-файле:

    Yater.externals.reverse = function(....., nodeset) {
        return nodeset.reverse();
    };

---

Будущее. `elem` и `attr`
-------------------------

    elem = "div"
    attr = "class"

    <{ elem }>
        @{ attr } = "hello"
        "Hello"
    </>

---

Будущее. `JSON`
---------------

    tree = {
        "title": "Hello, { .username }"
        if .total > 5 {
            "total": .total
        }
        "ids": [ 1, 2, 3 ]
    }

    apply tree

---

Будущее. `JSON`
---------------

    attrs = {
        "class": "hello"
        "params": {
            "author-login": .username
            "image-id": .id
        }
    }
    <div>
        attrs
    </div>

---

Будущее. `JSON`
---------------

И на выходе получится такой `html`:

    <div class='hello'
        params='{ "author-login": "nop", "image-id": 42 }'>
    </div>

---

Будущее. Модули
---------------

Нужна возможность разбивать код шаблонов на модули.

  * Возможность загрузить один модуль и потом подгрузить другой,
    использующий первый.
  * `module "name"`.
  * `import "name"`.
  * `apply-imports`.

---

Всё
---

  * [git.io/yate](http://git.io/yate) — проект `yate` на github'е.
  * [git.io/nop](http://git.io/nop) — все мои проекты.

