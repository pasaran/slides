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

JPath. Оператор |
-----------------

Работает не так, как в `XPath`:

    .item[ .selected ] | .item[ .count > 5 ]

Просто склеивает результаты двух (или более) `jpath`-ов:

  * Могут быть дубли.
  * Порядок нод в результате может быть отличным от исходного.

---

    match / {
        <h1>Hello, { .username }</h1>
    }

    match / {
        <h1>
            "Hello, { .username }"
        </h1>
    }

---

    match / {
        <h1>{ .title }</h1>

        apply .items
    }

---

    match .items {
        <ul>
            apply .item
        </ul>
    }

    match .item {
        <li>
            <a href="{ .url }">{ .title }</a>
        </li>
    }

