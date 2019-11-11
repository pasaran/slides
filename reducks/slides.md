# reducks

## Что не нравится в redux

  * Нет явной связи между компонентами,
    экшенами, редьюсерами и данными.

  * Много boilerplate-кода. Особенно в typescript'е.

  * Один стор превращается в помойку.

---

## Нет связи ...

    const actions = require( 'actions' );
    const getFoo = require( 'selectors/getFoo' );
    class Foo extend React.Component {
        ... this.props.dispatch( actions.doFoo() );
    }

    module.exports = connect( state => ( {
        foo: getFoo( state ),
    } ), Foo );

---

## Boilerplate в typescript

    enum ActionTypes {
        DO_FOO = 1,
        ...
    }

---

## Boilerplate в typescript

    interface ActionDoFoo {
        type: ActionTypes.DO_FOO,
        payload: { ... }
    }

    type Action =
        ActionDoFoo |
        ...
    ;

---

## Boilerplate в typescript

    function action_do_foo(): ActionDoFoo {
        ...
    }

---

## Boilerplate в typescript

    function reducer_do_foo(
        state: State,
        action: ActionDoFoo
    ): State {
        ...
    }

---

## Boilerplate в typescript

    function reducer(
        state: State,
        action: Action
    ): State {
        switch ( action.type ) {
            case ActionTypes.DO_FOO: {
                ...
            }

---

## redux -> reducks

  * Стор разбивается на несколько сторов.

  * Компоненты коннектятся к конкретным сторам
    и получают весь стор целиком в виде пропса.

  * Стор содержит в себе экшены/редьюсеры/селекторы.

  * SPA из коробки

---

## Store

    import { BlockStore } from 'auto-core/reducks';
    impoty { TOfferListing } from 'auto-core/types/TOfferListing';

    const initialState: TOfferListing = { ... };

    const store = new BlockStore( initialState, {
        //  Selectors/Actions.
    } );

---

## Selectors

    getTotalOffersCount() {
        return this.state.pagination.total_offers_count;
    },

    getFiltereOrTotalOffersCount() {
        return this.state.filteredOffersCount ||
            this.actions.getTotalOffersCount();
    },

---

## Selectors

    const count = this.props.listing.getTotalOffersCount();

---

## Actions

    fetchCount() {
        this.update( {
            ...this.state,
            pendingCount: true,
        } );

        ...

---

## Actions

        ...

        return this.request( ... )
            .then( ( result ) => {
                this.update( {
                    ...this.state,
                    pendingCount: false,
                    filteredOffersCount: ...
                } );
            } );

---

## Actions

    onFilterChange() {
        ...

        this.props.listing.fetchCount();
    }

---

## Blocks

reducks-блок состоит из:

  * id
  * Стора
  * Набора параметров
  * Каких-то флагов
  * Дескриптового блока

---

## Blocks

    //  auto-core/reducks/blocks/id.ts

    export enum BLOCK_ID {
        BANKS = 'getBankConfig',
        BREADCRUMBS_PUBLICAPI = 'breadcrumbsPublicApi',
        BUNKER = 'bunker',
        ...

Хорошо бы этот enum генерить автоматически.

---

## Blocks

    //  auto-core/reducks/blocks/listing/index.ts

    const Store = ( initialState: TOfferListing ) =>
        new BlockStore( initialState, {
            ...
        } );

---

## Blocks

    //  auto-core/reducks/blocks/listing/index.ts

    export default {
        blockId: BLOCK_ID.LISTING,
        BlockStore: Store,
        blockParams: validPublicApiSearchParams,
        //  server: false,
        //  cache: true,
    };

---

## Pages

    //  www-mobile/reducks/pages/listing/index.ts

    import favoritesLocalCacheBlock from
        'auto-core/reducks/blocks/favoritesLocalCache';
    import listingBlock from
        'auto-core/reducks/blocks/listing';
    ...

---

## Pages

    ...
    export default {
        blocks: [
            { block: favoritesLocalCacheBlock },
            {
                block: listingBlock,
                required: true,
            },
            ...

---

## Components

    import listingBlock from 'auto-core/reducks/blocks/listing';
    import pageBlock from 'auto-core/reducks/blocks/page';

    const blocks = {
        listing: listingBlock,
        page: pageBlock,
        ...
    };

---

## Components

    import { connect, ConnectedProps } from
        'auto-core/reducks';

    interface OwnProps { ... };
    type Props = ConnectedProps<typeof blocks> & OwnProps;

    class PageListing extends React.Component<Props> {
        ...
    }

---

## Components

    export default connect(blocks, PageListing)
        as unknown
        as React.ComponentClass<OwnProps>;

---

## Async blocks (Lazy?!)

    import { asyncBlock } from 'auto-core/reducks';

    import indexReviewsBlock from
        'auto-core/reducks/blocks/indexReviews';
    const blocks = {
        indexReviews: asyncBlock(indexReviewsBlock),
    };
    type Props = ConnectedProps<typeof blocks>;

---

## Async blocks

    connect( blocks, Component, {
        //  loader: null,
        loader: <Spinner/>,
    } )

---

## Request

    fetchCount() {
        return this.request( {
            blockId: BLOCK_ID.LISTING,
            blockParams: { ... },
        } )
            .then( ( result ) => {

            } );
    }

---

## Request

    this.request( [
        {
            blockId: BLOCK_ID.FOO,
            blockParams: { ... },
        },
        {
            blockId: BLOCK_ID.BAR,
            blockParams: { ... },
        },
        ...

---

## Выбираем название:

  * `reducks`
  * `ducks`
  * `regoose`
  * ...

