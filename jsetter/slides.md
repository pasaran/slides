# jsetter

## jsetter — что такое и зачем

  * Аналог [immutability-helper](https://github.com/kolodny/immutability-helper), но в более-менее [jpath синтаксисе](./jpath.md).

---

## Сперва немного про jpath

  * Отрефакторил все ненужное.
  * Сделал собранный и готовый к использованию в вебе бандл.
  * Добавил пару новых фич.
  * `nommon@0.0.52`.

---

## `dist/nommon.min.js`

  * Теперь в `dist` лежит собранный `nommon`,
    только самое необходимое.

  * Попутно переделал сборку бандла `libs.min.js`.

  * `//yastatic.net/autoru-frontend-react/0.0.20/libs.min.js`

---

## Динамический шаг. Было

    key1 = 'foo';
    key2 = 'bar';
    no.jpath( `.${ key1 }.${ key2 }`, data )

---

## Динамический шаг. Стало

    no.jpath( '.[ key1 ][ key2 ]', {
        key1: 'foo',
        key2: 'bar',
    }, data )

    no.jpath( '.[ key ]', {
        key: '😀',
    }, data )

---

## Функции

    data = {
        item: [ 1, 2, 3 ],
    }

    no.jpath( '.item[ length( . ) - 1 ]', data )
    //  3

---

## Функции

    de.jstring( '/foo/bar/{ params.id }/' )

    params: {
        id: '../../quu/',
    }

---

## Функции

    //  enc === encodeURIComponent

    de.jstring( '/foo/bar/{ enc( params.id ) }/' )
    //  '/foo/bar/..%2F..%2Fquu'

    de.jstring( '/foo/bar/{ encodeURIComponent( params.id ) }/' )

---

## Функции

    no.jpath( 'add( .foo, .bar )', {
        add: ( a, b ) => a + b,
    }, data )

---

## jsetter

    data = {
        foo: {
            bar: 42,
        }
    }

    new_data = no.jsetter( '.foo.bar' )( data, null, 24 )

---

    data = {
        foo: {
            bar: 42,
            quu: { ... },
        },
        boo: { ... },
    }

---

    data === jsetter( '.foo.bar' )( data, null, 42 )
    //  true

---

## Было

    const old_chat = get_chat( state.chat_list, chat_id )!;
    const new_chat: ModelChat = {
        ...old_chat,
        muted: true
    };
    return {
        ...state,
        chat_list: set_chat( state.chat_list, new_chat )
    };

---

## Стало

    return jsetter( '.chat_list{ .id === chat_id }.muted' )
        ( state, { chat_id: chat_id }, true );

---

## Было

    case actions.OFFER_UPDATE:
        const index = offerIndexById( action.payload.offerID, state );
        return Update( state, {
            offers: {
                [ index ]: {
                    $set: action.payload.offer
                }
            }
        } );

---

## Стало

    case actions.OFFER_UPDATE:
        return jsetter( '.offers{ .id === id || .saleId === id }' )(
            state,
            {
                id: action.payload.offerID
            },
            action.payload.offer
        );

---

## Было

    case actions.DELETE_OFFER:
        const index = offerIndexById( action.payload.offerID, state );
        return Update( state, {
            offers: {
                $splice: [
                    [ offerIndex, 1 ]
                ]
            }
        } );

---

## Стало

    case actions.DELETE_OFFER:
        return jsetter.delete( '.offers{ .id === id || .saleId === id }' )(
            state,
            {
                id: action.payload.offerID,
            }
        );

---

## Было

    case actions.OFFER_LOADING:
        const index = offerIndexById( action.payload.offerID, state );
        if ( index === -1 ) { return state; }
        return Update( state, {
            offers: {
                [offerIndex]: {
                    loading: { $set: true }
                }
            }
        } );

---

## Стало (на самом деле нет)

    case actions.OFFER_LOADING:
        return jsetter( '.offers{  .id === id || .saleId === id }.loading' )
            ( state, { id: action.payload.offerID }, true );

---

## Было

    case 'ACTIVATE':
        const index = offerIndexById( action.payload.offerID, state );
        if ( offerIndex === -1 ) { return state; }
        return Update( state, {
            offers: {
                [offerIndex]: {
                    isActive: {
                        $set: !state.offers[offerIndex].isActive
            ...

---

## Стало бы

    case 'ACTIVATE':
        return jsetter( '.offers{  .id === id || .saleId === id }.isActive' )(
            state,
            { id: action.payload.offerID },
            value => !value
        );

---

## API

    no.jsetter
    no.jsetter.delete
    no.jsetter.push
    no.jsetter.pop
    no.jsetter.shift
    no.jsetter.unshift
    no.jsetter.splice
    no.jsetter.sort

---

    jsetter.delete( '.offers{ !.isActive }' )
    jsetter.push( '.offers' )
        ( state, null, offer1, offer2, offer3 )
    jsetter.sort( '.offers' )
        ( state, null, ( a, b ) => a.foo - b.foo )
    jsetter.splice( '.offers' )
        ( state, null, 2, 1, new_offer )

