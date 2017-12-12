# TypeScript

## TypeScript vs JavaScript

TypeScript — он как JavaScript, но только нет.

---

## TypeScript vs JavaScript

Что добавилось:

  * Указание типа при определении переменных и параметров функций.

  * Специальные конструкции для декларации новых типов (`type`, `enum`, `interface`, ...).

  * Приведение типов (`as`).

---

## TypeScript vs JavaScript

TypeScript компилируется в JavaScript, поэтому в рантайме они одинаковы.
Если JavaScript чего-то не умеет в рантайме, TypeScript тоже этого не умеет.

Например, function overloading.

---

## Задание типа переменных и т.д.

    let s: string;
    let t: string = null;
    const n: number = 42;

    function foo( s: string ): number {
        if ( s.length > 10 ) {
            return s.length;
        }
    }

---

## `tsconfig.json`

    {
        "compilerOptions": {
            "noImplicitAny": true,
            "strictNullChecks": true
        }
    }

---

## Задание типа переменных и т.д.

    let s: string;
    let t: string | null = null;
    const n = 42;

    function foo( s: string ): number | undefined {
        if ( s.length > 10 ) {
            return s.length;
        }
    }

---

## Задание типа переменных и т.д.

    let s: string;
    let t: string = undefined;

---

## `const`

    const status = 'ok';
    const status: string = 'ok';

    type Status = 'ok' | 'failed';
    const status: Status = 'ok';

---

## `enum`

    enum Status {
        OK,
        FAILED
    }
    const status: Status = Status.OK;
    const status = Status.OK;

---

## `interface`

    interface Point {
        x: number;
        y: number;
    }

---

## `interface`

    const p1: Point = {
        x: 42,
    };
    const p2: Point = {
        x: 42,
        y: 24,
        z: 66,
    };

---

## `interface`

    interface Point {
        x: number;
        y?: number;
    }
    interface PointAndWhatever {
        x: number;
        y: number;
        [key: string]: any;
    }

---

## Вложенные interface'ы

    interface Sale {
        mark: {
            id: string;
            name: string;
        }
        ...
    }

---

## `Array`

    let items: Array<Item>;
    let strings_or_numbers: Array<string | number>;

---

## `Array`

    const Items = Array<Item>;
    let items: Items;

    //  Error!
    let items_copy: Items = [].concat( items );
    //  Ok.
    let items_copy: Items = ( [] as Items ).concat( items );
    let items_copy: Items = items.concat( [] );

---

## `as`

    const data = JSON.parse(response) as MyData;

    function get_something( x: string | number, y?: string ) {
        if ( y ) {
            //  return x.length;
            return ( x as string ).length;
        }
    }

---

## function overload

    function get_something( x: string, y: string ): number;
    function get_something( x: number ): number;

    function get_something( x: string | number, y?: string ) {
        if ( y ) {
            return x.length;
        }
        return x;
    }

---

## Functions

    type Callback = ( error: Error | null, result?: Result ): void;

    function read_file( filename: string, callback: Callback ) {
        ...
    }

---

## Node + React + Redux

    node_modules/@types/node/index.d.ts
    node_modules/@types/react/index.d.ts
    node_modules/@types/react-dom/index.d.ts
    node_modules/@types/react-redux/index.d.ts
    node_modules/redux/index.d.ts
    node_modules/redux-thunk/index.d.ts

---

    interface Props {
        size: 's' | 'm' | 'l';
        theme: string;
    }

    class MyClass extends React.Component<Props> {
        public static defaultProps: Partial<Props> = {
            theme: 'islands'
        }
        ...
    }

---

    interface State {
        loading: boolean;
    }

    class MyClass extends React.Component<null, State> {
        this.state: State = {
            loading: false;
        }

---

    class MyClass extends React.Component<Props, State> {
        ...
    }

---

    //  1.
    import * as React from 'react';
    import { connect, DispatchProp } from 'react-redux';

    import ModelState from './models';

    interface OwnProps { ... }
    interface StateProps { ... }
    type Props = OwnProps & StateProps;
    interface State { ... }

---

    //  2.
    class MyClass extends React.Component<Props
        & DispatchProp<ModelState>, State> {}

    function map_state_to_props( state: ModelState ): StateProps {
        return { ... };
    }
    export connect( map_state_to_props )( MyClass )
        as React.Component<OwnProps>;

---

    import { createStore, applyMiddleware } from 'redux';
    import thunkMiddleware from 'redux-thunk';
    import reducers from './reducers';
    import { ModelState } from './models';

    const init_state = { ... };

    export default createStore( reducers, init_state as ModelState,
        applyMiddleware( thunkMiddleware )
    );

---

    export enum ActionTypes = {
        OPEN_CHAT,
        CLOSE_CHAT,
        ...
    }

---

    export interface ActionOpenChat {
        type: ActionTypes.OPEN_CHAT;
        payload: {
            chat_id: string;
        }
    }
    export type Action =
        ActionOpenChat |
        ActionCloseChat |
        ...
    ;

---

    export function action_open_chat( chat_id: string )
        : ActionOpenChat {
        return {
            type: ActionTypes.OPEN_CHAT,
            payload: {
                chat_id: chat_id
            }
        };
    }

---

    export function action_open_chat( chat_id: string )
        : ActionOpenChat {
        const action: ActionOpenChat = {
            type: ActionTypes.OPEN_CHAT,
            payload: {
                chat_id: chat_id
            }
        };
        return action;
    }

---

    import { ThunkAction as ReduxThunkAction }
        from 'redux-thunk';

    type ThunkAction =
        ReduxThunkAction<void, ModelState, void>;

---

    export function action_open_chat( chat_id: string ): ThunkAction {
        return function( dispatch, get_state ) {
            const action: ActionOpenChat = {
                type: ActionTypes.OPEN_CHAT,
                payload: {
                    chat_id: chat_id;
                }
            }
            dispatch( action );
        };
    }

---

    export function action_resync():
        ReduxThunkAction<Promise<void>, ModelState, void> {
        return function( dispatch, get_state ) {
            const action: ActionResync = { ... };
            dispatch( action );

            const promise = request( ... );
            return promise;
        }
    }

---

    export default function( state: ModelState, action: Action )
        : ModelState {

        switch ( action.type ) {
            case ActionTypes.OPEN_CHAT: {
                return open_chat( state, action );
            }

---

    import { ModelState } from '../models';
    import { ActionOpenChat } from '../actions';

    export default function( state: ModelState,
        action: ActionOpenChat ): ModelState {
        return {
            ...state,
            visible: true,
            chat_id: action.payload.chat_id,
        };
    };

---

    declare global {
        interface Window {
            vertis_chat: VertisChat;
            vertis_chat_callbacks?:
                Array<VertisChatOnReadyCallback>;
        }
    }
    ...

    window.vertis_chat = vertis_chat;

