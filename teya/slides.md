# teya

## Почему pattern matching это не очень хорошо

  * Медленнее, чем.

  * Приходится "портить" данные.

  * Сложно оптимизировать (вызовы шаблонов, удаление неиспользуемого кода,
    передача параметров, сборка только нужного и т.д.).

  * Сложно сочетается с другими фичами (json -> json).

---

## Почему вообще мы так любим pattern matching?

  * По историческим причинам. Из-за широкого распространения
    `XSLT` в Яндексе (во всем, конечно, виноват Бацек).

  * В `XSLT` мы его используем из-за технических ограничений.
    Даже там, где это не нужно.

  * `yate` — это `XSLT` в другом синтаксисе, так что и там тоже самое.

---

    <ul>
        <li>First</li>
        <li>Second</li>
        <li>Third</li>
    </ul>

---

    page: {
        list: {
            item: [
                'First',
                'Second',
                'Third'
            ]
        }
    }

---

    match .page
        apply .list

    match .list
        <ul>
            apply .item

    match .item
        <li>{ . }</li>

---

    page: {
        //  list: {
        item: [
            'First',
            'Second',
            'Third'
        ]
        //  }
    }

---

## Относительные jpath'ы

  * Мы не можем использовать абсолютные jpath'ы.

  * Но чтобы использовать относительные jpath'ы,
    нам нужно менять контекст для каждого шаблона.

  * Единственный (почти) способ поменять контекст в `XSLT` —
    это `<apply-templates>`.

---

## Альтернативы

  * `for`.

  * Именованные шаблоны, при вызове которых можно сменить контекст.
    (ни в `XSLT`, ни в `yate` такой возможности нет).

  * Передавать контекст в качестве параметра.

---

    func page()
        for .list list()

    func list()
        <ul>
            for .item item()

    func item()
        <li>{ . }</li>

---

    match .item
        ...

    match .item[ .selected ]
        ...

---

    match .item
        if .selected
            ...
        else
            ...

---

    func page( ctx )
        list( ctx.list )

    func list( ctx )
        <ul>
            for ctx.item item( . )

    func item( ctx )
        <li>{ ctx }</li>

---

В итоге мы используем pattern matching там, где это вовсе не нужно.

Вот если бы мы могли менять контекст при вызове функции
и писать функции с предикатами...

---

## А где нужно?

  * Обработка UGC-контента: письма в Почте, посты в Ярушке.

  * Когда не все знаем про входные данные. Например, список писем,
    в котором могут быть и `<message>` и `<thread>`.
    (в JSON такая ситуация почти исчезла).

  * Когда мы не знаем точно, что должно получиться на выходе.
    Например, по урлу мы строим динамически дерево блоков для этой страницы.

---

## А где не нужно?

  * Там, где мы точно знаем структуру входных данных.

  * И где мы знаем, что мы хотим получить на выходе.

Т.е. примерно в 95% случаев.

---

    match .page
        //  Это не вызов шаблона!
        apply .list

    match .list
        <ul>
            apply .item

---

## "Сверху-вниз" vs "снизу-вверх"

    match .list
        <ul>
            apply .item

Шаблон — это код (в данном случае).
Он знает, как выводить свой контент,
откуда его брать и т.д.

---

    list: {
        item: [ 'First', 'Second', Third' ]
    }

    menu: {
        menu-item: [
            { title: 'First' },
            { title: 'Second' },
            ...

---

## Шаблон с дыркой

Большая часть шаблонов (контролов, компонентов, ...) — это кусок html'я
с дыркой для html-контента:

    <ul>
        <!-- дырка для контента -->
    </ul>

Шаблон-враппер.
Шаблон ничего не знает и не должен знать про свой контент.

---

## Шаблон с несколькими дырками

    <div class="page">
        <div class="left">
            <!-- дырка для контента 1 -->
        </div>
        <div class="right">
            <!-- дырка для контента 2 -->
        </div>
    </div>

---

## Передаем контекст параметром

  * Работает и в `XSLT`, и в `yate`.

  * В `XSLT` не использовалось из-за очень громоздкого синтаксиса.

  * Трудности с переопределением шаблонов.

---

    func list( content )
        <ul>{ content }</ul>

    func item( content )
        <li>{ content }</li>

---

    content = (
        item( 'First' )
        item( 'Second' )
        item( 'Third' )
    )

    list( content )

---

    content = for .item
        item( . )

    list( content )

---

## Передаем контент параметром

  * Чем хорош этот вариант? Всем :)

  * Если мы хотим получить кнопку (список, дропдаун, ...),
    то мы просто вызываем нужный шаблон. Нет оверхеда на pattern matching.

  * Нет двухпроходности и лишних итераций.

  * Шаблон ничего не знает про то, что в нем содержится.
    Что передали — то и вывели.

---

В `yate` вполне можно использовать передачу контента параметром,
но синтаксис немного корявый.

Нужно поправить.

---

    list
        UL ...

    item
        LI ...

---

    list
        item "First"
        item "Second"
        item "Third"

    list
        for .item
            item .

---

    button
        BUTTON.button @type "button" ...

---

    button "Ok"

    button
        icon "ok"
        "Ok"

    button
        "Ok"
        icon "ok"

---

    button
        @id "ok-button"
        //  @class "{ @class } big-button"
        @data {
            block: "button"
            params: {
                id: 42
            }
        }
        "Ok"

---

    button ( attrs attrs )
        BUTTON.button
            attrs
            DIV.wrapper ...

    button
        attrs:
            @id "ok-button"
        "Ok"

---

    dropdown
        item link href: "/first" "First"
        item link href: "/second" "Second"
        divider
        item link href: "/third" "Third"

---

    dropdown
        item
            link
                href: "/first"
                "First"

---

    dropdown
        UL.dropdown-menu ...

    item
        LI ...

    link ( href = "#" )
        A @href href ...

---

    <button type="button" class="btn btn-default
        dropdown-toggle"
        data-toggle="dropdown">
        Dropdown
        <span class="caret"></span>
    </button>

---

    button ( role = "default" )
        BUTTON.btn.btn-{ role } @type "button" ...

    caret
        SPAN.caret

    dropdown-toggle
        @class "{ @class } dropdown-toggler"
        @data-toggle "dropdown"

---

    button
        dropdown-toggle
        "Dropdown "
        caret

---

## Шаблоны

  * Каждый шаблон — это функция.

  * У шаблона есть параметры: явные и неявные (включая контекст).
    Всегда есть параметр `...` (с типом `xml`), означающий контент.

  * Как и в `yate`, есть контекст, в котором вычисляются относительные
    jpath'ы (можно поменять при вызове).

  * Модификаторы.

---

## Именованные параметры

В `yate` параметры позиционные.
А будут именованные, как в `XSLT`.

---

## be(m)-ориентированность

  * Блоки — это и есть шаблоны.

  * Элементы — блоки внутри других блоков.

  * Модификаторы?

---

    list

    item

    dropdown

    //  item уже занят!
    item

---

    list

    list-item

    dropdown

    dropdown-item

---

    list

    list item

    dropdown

    dropdown item

---

    dropdown
        item "First"
        item "Second"
        item "Third"

    list
        item "First"
        item "Second"
        item "Third"

---

    link

    item link

    drodown item link

    dropdown link

---

    content =
        //  Что это за `item`?
        item "First"
        item "Second"
        item "Third"

    list
        content

---

    content =
        list.item "First"
        list.item "Second"
        list.item "Third"

    list
        content

---

    <ul class="list" data-nb="list">
        <li class="list_item">First</li>
        <li class="list_item list_item__selected">Second</li>
        <li class="list_item">Third</li>
    </ul>

---

    list
        UL.list ...

    list item
        LI.list_item
            //  А что делать с модификаторами?!
            if #selected
                @class "{ @class } list_item__selected"

---

    list
        UL() ...

    list item
        LI() ...

---

    list
        item #selected "First"

    <ul class="list" data-nb="list">
        <li class="list_item list_item__selected">First</li>

---

## Остаточный pattern matching

    item [ #selected ]

    item [ .selected ]

    item ( bool selected ) [ selected ]

    item

---

    post
        head -> .head
        subhead -> .subhead

    post head
        H1 .

    post subhead
        H2 .

---

## Function overloading

    link ( node n )
        A @href n.href
            n.text

    link ( href, text )
        A @href href
            text

---

## Управляющие конструкции

  * `for`, `if`
  * `for-in`
  * `with`
  * `when` (`switch`)

---

    with .post
        A @href "/post/{ .id }"
            head -> .head
        html .content

---

    for key, value in object
        "{ key }: { value }"

---

## Фильтры

    page
        :markdown
            # Hello, { .username }

              * First
              * Second
              * Third

`:text`, `:html`, `:markdown`, `:jade`, ...

---

## JSON -> JSON

    data
        {
            id: 42
            if .foo
                foo: .foo
            items: [
                for .item item
            ]
        }

---

## Mutable vs immutable

    o = {}
    o.id = 42

    a = []
    push a, 42
    //  a.push 42

---

## Всё

  * [git.io/teya](http://git.io/teya) — проект `teya` на github'е.
  * [git.io/nop](http://git.io/nop) — все мои проекты.

Сергей Никитин  
[nop@yandex-team.ru](mailto:nop@yandex-team.ru)

