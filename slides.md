JPath
-----

  * Аналог `XPath` в `XSLT`.
  * Более javascript'овый синтаксис.

---

JPath. Примеры
--------------

    yate                        xpath

    .                           .
    .foo                        foo
    .*                          *
    .foo.bar                    foo/bar
    ..                          ..
    ...                         ../..
    ...foo.bar                  ../../foo/bar

---

JPath. Предикаты
----------------

    yate                        xpath

    .item[ .count || .title ]   item[ count or title ]
    .item[ .selected ]          item[ selected ]
    .item[ .count > 5 ]         item[ count &gt; 5 ]
    .item[ !.selected ]         item[ not(selected) ]

    .*[ name() == 'item' ]      *[ name() = 'item' ]

---

JPath. Операторы
----------------

    yate    xpath               yate    xpath

    <       &lt;                <=      &lt;
    >       &gt;                >=      &gt;
    ==      =
    !=      !=

---

JPath. Операторы
----------------

    yate    xslt                yate    xslt

    +       +                   &&      and
    -       -                   ||      or
    *       *                   !       not()
    /       div
    %       mode                |       |

---

JPath. Оператор `|`
-------------------

Работает не так, как в `XPath`:

    .item[ .selected ] | .item[ .count > 5 ]

Просто склеивает результаты двух (или более) `jpath`-ов:

  * Могут быть дубли.
  * Порядок нод в результате может быть отличным от исходного.

---

Шаблоны
-------

    match / content {
        <h1>Hello, { .username }</h1>
    }

  * Ключевое слово `match`.
  * Селектор: `/` или `jpath`.
  * Мода (опционально).
  * Тело шаблона `{ ... }`.

---

Шаблоны
-------

То же самое в `XSLT`:

    <xsl:template match="/" mode="content">
        <h1>
            <xsl:text>Hello, </xsl:text>
            <xsl:value-of select="username"/>
        </h1>
    </xsl:template>

---

Шаблоны. Селекторы
------------------

    match / { ... }
    match .items.item[ .selected ] { ... }

Неправильно:

    //  FIXME: Сделать абсолютные jpath'ы.
    match /.items { ... }
    match .. { ... }

---

Шаблоны. Содержимое
-------------------

  * Выражения
  * Определения

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

Выражения. XML-строки
---------------------

Длинные строки можно переносить:

    <img src="http://yandex.st/logo.png"
        width="95" height="37"/>

Теги `img`, `br`, `input` и др. выводятся в режиме html.

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
        <div class="hello">
            if .username {
                @class += " username"
            }
        </div>
    }

Временный синтаксис.

---

Выражения. XML-атрибуты
-----------------------

Скорее всего, будет так:

    match / {
        <div class="hello">
            if .username {
                @class = "{ @class } username"
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
        attrs = (
            @width = 42
            @height = 24
        )

        <img src="logo.png">
            attrs
        </img>
    }

---

Выражения. XML-атрибуты
-----------------------

В планах:

    match / {
        name = "class"

        @{ name } = "hello"
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

Можно передать параметр(ы):

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

Всё
---

  * [git.io/yate](http://git.io/yate) — проект `yate` на github'е.
  * [git.io/nop](http://git.io/nop) — все мои проекты.

