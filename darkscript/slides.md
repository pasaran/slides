# Dark Magic of Typescript

## TypeScript = JavaScript + ???

    type Foo = ...

---

## Array vs Tuple

    function foo( x: string, y: number ) {
        return [ x, y ];
    }

    const [ x, y, z ] = foo( 'hello', 42 );

---

## Array vs Tuple

    function foo( x: string, y: number ) {
        return [ x, y ];
    }

    const [ x, y, z ] = foo( 'hello', 42 );
    //  string | number

---

## Array vs Tuple

    let a: Array< string >;
    let i: number;

    const x = a[ i ];
    //  string

[#13778](https://github.com/microsoft/TypeScript/issues/13778)

---

## Array vs Tuple

    function foo( x: string, y: number ): [ string, number ] {
        return [ x, y ];
    }

    const [ x, y, z ] = foo( 'hello', 42 );

---

## Array vs Tuple

    function foo( x: string, y: number ) {
        return [ x, y ] as const; //  TS 3.4
    }

    const [ x, y, z ] = foo( 'hello', 42 );

[TS 3.4](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-4.html#const-assertions)

---

## `typeof`

    const x = { foo: 'hello', bar: 42 };

    type T = typeof x;
    //  { foo: string, bar: number }

    let y: T;

---

## `keyof`

    type Foo = { foo: string, bar: number };

    type Keys = keyof Foo; //  It's a type, not an array!
    //  "foo" | "bar"

    type Values = Foo[ Keys ];
    //  string | number

---

## `keyof`

    type Foo = Array< string >;

    type Keys = keyof Foo;
    //  number | "length" | "toString" ...

---

## `keyof`

    type Foo = [ string, number, boolean ];

    type Keys = keyof Foo;
    //  number | "0" | "1" | "2" | "length" ...

---

## Generics

    type Pair< T > = { x: T, y: T };

Generic isn't a type:

    let pair1: Pair; //  ❌
    let pair2: Pair< number >; //  ✅

---

## Problems

    type Block< Params, Result > = ...;

---

## Problems

    const b = de.http( ... );
    type B = typeof b;
    //  Block< P, R >

    B -> P
    B -> R

---

## Problems

    type B1 = Block< P1, R1 >;
    type B2 = Block< P2, R2 >;
    ...

    const A = de.array( {
        block: [ b1, b2, ... ] as const,
    } );
    //  Block< P1 & P2 & ..., [ R1, R2, ... ] >

---

## Problems

    [ B1, B2, ... ] -> P1 & P2 & ...
    [ B1, B2, ... ] -> [ R1, R2, ... ]

---

## Problems

    const O = de.object( {
        block: { k1: b1, k2: b2, ... },
    } );
    //  Block<
    //      P1 & P2 & ...,
    //      { k1: R1, k2: R2, ... }
    //  >

---

## Problems

    { k1: B1, k2: B2, ... } -> P1 & P2 & ...
    { k1: B1, k2: B2, ... } -> { k1: R1, k2: R2, ... }

---

## Problems

How to:

  * Invert generic
  * Map tuple
  * Reduce tuple
  * Map interface
  * Reduce interface
  * ...and more

---

## Type is a set

    let a: string;
    let b: number;
    let c: { x: string };

    type A = X | Y;
    type B = X & Y;

---

## Type Y extends type X

Y — subtype (subset) of X:

    let x: X; //  x ∈ X
    let y: Y; //  y ∈ Y

    x = y; //  ✅ Y ⊂ X, y ∈ Y ⟹ y ∈ X
    y = x; //  ❌ X ⊄ Y

---

## `any` and `never`

    let x: X;
    let a: any;
    let n: never; //  ∅
    a = x; //  ✅  X ⊂ any
    x = n; //  ✅  never ⊂ X
    a = n; //  ✅  never ⊂ any
    n = x; //  ❌  X ⊄ never
    n = a; //  ❌  any ⊄ never
    x = a; //  ✅  any ⊂ X // WTF?!

---

## `any` and `never`

    ∅ ⊂ X ⊂ any
    X ⊄ ∅

Но:

    any ⊂ X
    any ≠ ∅

---

## `extends`

    interface X {
        x: string;
    }

    interface Y extends X {
        y: string;
    }

    Y ⊂ X

---

## `extends`

    interface X {
        x: string;
    }

    interface Y extends X {
        x: number;
    }

    Y ⊄ X

---

## Conditional types

    type X = A extends B ? C : D;

[TS 2.8](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#conditional-types)

---

## Invert generic

    type ArrayOf< T > = T extends Array< infer X >
        ? X : never;

    type S = ArrayOf< Array< string > >;
    //  string

---

## Invert generic

    type BlockParams< B > =
        B extends Block< infer P, infer R > ? P : never;

    type BlockResult< B > =
        B extends Block< infer P, infer R > ? R : never;

---

## Map interface

    type O = {
        k1: Block< P1, R1 >,
        k2: Block< P2, R2 >,
        ...
    };

---

## Map interface

    type ObjectResult< O > = {
        [ K in keyof O ]: BlockResult< O[ K ] >
    };

    type R = ObjectResult< O >;
    //  { k1: R1, k2: R2, ... }

[Mapped types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)

---

## Map tuple

    type A = [
        Block< P1, R1 >,
        Block< P2, R2 >,
        ...
    ];

---

## Map tuple

    type First< T extends Array< any > > =
        T extends [ infer First, ...infer Rest ]
        ? First : never;

    type Last< T extends Array< any > > =
        T extends [ ...infer Rest, infer Last ]
        ? Last : never;

---

## Map tuple

    type Head< T extends Array< any > > =
        T extends [ ...infer Rest, infer Last ]
        ? Rest : never;

    type Tail< T extends Array< any > > =
        T extends [ infer First, ...infer Rest ]
        ? Rest : never;

---

## `extends` vs `extends`

    type Foo< T extends Array< any > > = Expr< T >;

    type Bar< T > = T extends Array< any >
        ? Expr< T > : never;

---

## `extends` vs `extends`

    ... Foo< string > ...
    //  assert

    ... Bar< string > ...
    //  conditional expression

---

## Recursive types

    type Tree = {
        value: any;
        left?: Tree;
        right?: Tree;
    }

[TS 3.7](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html#more-recursive-type-aliases)

---

## Recursive types

    type Json =
        string |
        number |
        boolean |
        null |
        { [ property: string ]: Json } |
        Array< Json >;

---

## Map tuple

    type ArrayResult< A > = {
        0: A,
        1: [ BlockResult< First< A > > ],
        2: [
            BlockResult< First< A > >,
            ...ArrayResult< Tail< A > >,
        ],
    }[ A extends [] ? 0 : A extends [ any ] ? 1 : 2 ];

---

## Map tuple

    type ArrayResult< A > =
        A extends [] ?
            [] :
            [
                BlockResult< First< A > >,
                ...ArrayResult< Tail< A > >,
            ];

[TS 4.1?](https://github.com/microsoft/TypeScript/pull/40002)

---

## Reverse tuple

    type ReverseTuple< T extends any[] > > =
        T extends [] ?
            T :
            [ ...Reverse< Tail< T > >, First< T > ];

    type T = ReverseTuple< [ A, B, C ]>
    //  [ C, B, A ]

---

## Tuple to intersection

    type TupleToIntersection< T extends any[] > =
        T extends [] ? never :
        T extends [ any ] ? First< T > :
            First< T > & TupleToIntersection< Tail< T > >;

    type I = TupleToIntersection< [ A, B, C ] >;
    //  A & B & C

---

## Tuple to intersection

    type ArrayParams< A > =
        A extends [] ?
            {} :
            BlockParams< First< A > > &
                ArrayParams< Tail< A > >;

---

## Tuple to union

    type U = [ A, B, C ][ number ];
    //  A | B | C

    type K = keyof [ A, B, C ];
    //  number | "0" | "1" | "2" | "length" | ...

    type U = [ A, B, C ][ 0 | 1 | 2 ];

---

## Distributive conditional types

    type Array1< T > = Array< T >;

    type Array2< T > = T extends any ? Array< T > : never;

---

## Distributive conditional types

    type A1 = Array1< string | number >;

    type A2 = Array2< string | number >;

---

## Distributive conditional types

    type A1 = Array1< string | number >;
    //  Array< string | number >

    type A2 = Array2< string | number >;
    //  Array< string > | Array< number >

---

## `never`

    type IfNever< T, Y = true, N = false > =
        [ T ] extends [ never ] ? Y : N;

    type X = IfNever< never >;
    //  true
    type Y = IfNever< any >;
    // false

---

## `never`

    type IfNever< T, Y = true, N = false > =
        T extends never ? Y : N;

    type X = IfNever< never >;
    //  never ( never === union of zero elements )
    type Y = IfNever< any >;
    //  boolean ( boolean === true | false )

---

## `any`

    type IfAny< T > =
        0 extends ( 1 & T ) ? true : false;

[Why?!](https://stackoverflow.com/questions/49927523/disallow-call-with-any/49928360#49928360)

---

## Union to intersection

    type UnionToIntersection< U > =
        ( U extends any ?
            ( k: U ) => void :
            never
        ) extends
            ( ( k: infer I ) => void ) ? I : never;

    UnionToIntersection< A | B | C >;
    //  A & B & C

---

## Union to intersection

    U extends any ? ( k: U ) => void : never

    U := A | B | C

    ( k: A ) => void |
    ( k: B ) => void |
    ( k: C ) => void

---

## Union to intersection

    ( k: A ) => void |
    ( k: B ) => void |
    ( k: C ) => void

Это а) функция б) от одного параметра.
Параметр какого типа можно передать в любую из этих трех функций?

    A & B & C

---

## Type inference in conditional types

> Multiple candidates for the same type variable in contra-variant positions
> causes an intersection type to be inferred

[Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types).

[Strict function types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html#strict-function-types)

---

## Union to overloads

    type UnionToOverloads< U > =
        UnionToIntersection< U extends any ?
            ( k: U ) => void : never >;

    UnionToOverloads< A | B | C >
    //  ( k: A ) => void &
    //  ( k: B ) => void &
    //  ( k: C ) => void

---

## Union to overloads

    interface {
        ( k: A ): void;
        ( k: B ): void;
        ( k: C ): void;
    }

---

## Last element of union

    type LastOfUnion< U > = UnionToOverloads< U > extends
        ( ( a: infer X ) => void )
            ? X : never;

    LastOfUnion< A | B | C >
    //  C

---

## Last element of union

> When inferring from a type with multiple call signatures
> (such as the type of an overloaded function),
> inferences are made from the last signature
> (which, presumably, is the most permissive catch-all case).

[Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types).

---

## Union to tuple

    type UnionToTuple<
        U,
        R extends any[] = [],
        L = LastOfUnion< U >
    > =
        [ L ] extends [ never ] ?
            R :
            UnionToTuple< Exclude< U, L >, [ L, ...R ] >;

---

## Union to tuple

    type UnionToTuple<
        U,
        R extends any[] = [],
        L = LastOfUnion< U >
    > = IfNever<
        L,
        R,
        UnionToTuple< Exclude< U, L >, [ L, ...R ] >
    >;

---

## Union to tuple

    UnionToTuple< A | B | C >
    //  [ A, B, C ]

---

## Map interface

    type Keys< O > = UnionToTuple< keyof O >;

    Keys< {
        a: A,
        b: B,
        c: C,
    } >
    //  [ "a", "b", "c" ]

---

## Is two types are equal

    type IsEqual< X, Y > =
        ( < T >() => T extends X ? 1 : 2 ) extends
        ( < T >() => T extends Y ? 1 : 2 ) ? true : false;

[Why?!](https://stackoverflow.com/questions/53807517/how-to-test-if-two-types-are-exactly-the-same)

[#27024](https://github.com/Microsoft/TypeScript/issues/27024)

---

## Further reading

  * Changelog

  * [jcalz at SO](https://stackoverflow.com/users/2887218/jcalz)
