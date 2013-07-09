# Node.js

## Сборка

    git clone git@github.com:joyent/node.git
    cd node
    git checkout v0.11.3
    ./configure --prefix=`echo $HOME`/local/node
    make -j2
    make install

---

## Сборка

    export PATH=~/local/node/bin:$PATH

    which node
    node --version

---

## Сборка

    cd deps/v8
    make dependencies
    make native

---

## Стандартные модули и классы

В файлах `lib/*.js` находятся все стандартные модули.

---

## EventEmitter

    var EventEmitter = require('events').EventEmitter;

    var o = new EventEmitter();
    o.on('foo', function() {
        ...
    });
    o.emit('foo');

---

## EventEmitter

    var o = extend( {}, EventEmitter.prototype );
    o.on('foo', function() {
        ...
    });
    o.emit('foo');

---

## EventEmitter

    var o = new EventEmitter();
    /*
    o.on('error', function() {
        ...
    });
    */
    o.emit('error', 'Error message');

---

## Buffer

Объект для хранения "сырых" данных:

  * Чтение/запись файлов.
  * Получение/отправка данных по http.

---

## Buffer

    fs.readFile('foo.txt', function(content) {
        //  content — это Buffer.
    });

---

## Buffer

Преобразования `Buffer <-> String` не бесплатные:

    var str = fs.readFileSync('foo.txt', 'utf-8');
    fs.writeFileSync('bar.txt', str, 'utf-8');

    var buf = fs.readFileSync('foo.txt');
    fs.writeFileSync('bar.txt', buf);

---

## Buffer

    http.request(options, function(res) {
        var result = '';
        res.on('data', function (chunk) {
            result += chunk;
        }).on('end', function() {
            ...
        });
    });

---

## Buffer

    http.request(options, function(res) {
        var chunks = [], length = 0;
        res.on('data', function (chunk) {
            chunks.push(chunk);
            length += chunk.length;
        }).on('end', function() {
            var result = Buffer.concat(chunks, length);
        });
    });

---

## Stream

Работа с поточными данными:

  * Работа с `http`.
  * Стандартный ввод-вывод: `process.stdin`, `process.stdout`.
  * gzip-ование.
  * ...

---

## Stream

Похоже на unix-овые пайпы:

    process.stdin.pipe(process.stdout);

---

## Stream

Чтение из потока:

    rs.on('data', function(chunk) {
        ...
    });
    rs.on('end', function() {
        ...
    });

---

## Stream

Запись в поток:

    ws.write(chunk);
    ws.write();

---

## Modules

Классические модули предполагают, что они независимы друг от друга.
И, если модулю нужен другой модуль, он использует `require()`.
Но иногда получаются циклические ссылки.

Например, есть `parser.js` и `ast.js`.

---

## Modules

    var AST = require('./ast.js');

    Parser.prototype.parse = function(...) {
        ...
        return new AST(...);
    };

    module.exports = Parser;

---

## Modules

    var Parser = require('./parser.js');

    AST.include.prototype.init = function() {
        var ast = ( new Parser() ).parse(this.filename);
        ...
    };

    module.exports = AST;

---

## Modules

Общий модуль, экспортирующий неймспейс.

    //  no.base.js

    var no = {};

    module.exports = no;

---

## Modules

    //  no.promise.js

    var no = no || require('./no.base.js');

    no.Promise = function() {
        ...
    };

---

## Modules

    //  index.js

    var no = require('./no.base.js');

    require('./no.promise.js');
    require('./no.events.js');
    ...

    module.exports = no;

---

## Cluster

    if (cluster.isMaster) {
        for (var i = 0; i < numCPUs; i++) {
            cluster.fork();
        }
    } else {
        http.createServer(function(req, res) {
            res.end('Hello');
        }).listen(8000);
    }

---

## Error handling

    try {
        setTimeout(function() {
            throw 'Foo';
        });
    } catch (e) {
        console.log('error');
    }

---

## Error handling

    process.on('uncaughtException', function(e) {
        ...
    });

> Don't use it, use domains instead. If you do use it,
> restart your application after every unhandled exception!

---

## Error handling. Domains

    var d = require('domain').create();
    d.on('error', function(err) {
        console.log('error', err.message);
    });
    d.run(function() {
        require('http').createServer(function(req, res) {
            handleRequest(req, res);
        }).listen(8000);
    });

---

## Domains + Cluster

Правильная схема такая:

  * Используем `cluster`.
  * Если в воркере случается ошибка, то:
      * Ловим ошибку в домене.
      * Отключаем воркер.
      * Ждем, пока все запросы этого воркера закончатся.
      * Убиваем воркер.

---

## Domains + Cluster

    if (cluster.isMaster) {
        ...

        cluster.on('disconnect', function(worker) {
            cluster.fork();
        });
    }

---

## Domains + Cluster

    var server = http.createServer(function(req, res) {
        var d = domain.create();
        d.on('error', function(err) {
            setTimeout(function() { process.exit(1); }, 30000)
                .unref();
            server.close();
            cluster.worker.disconnect();
            res.statusCode = 500;
            res.end('Error');
        });
        ...

## Domains + Cluster

        ...
        d.add(req);
        d.add(res);
        d.run(function() {
            handleRequest(req, res);
        });
    });
    server.listen(8000);

---

## Domains + Cluster

[Подробный пример](http://nodejs.org/api/domain.html#domain_warning_don_t_ignore_errors)

---

## `ref()` и `unref()`

До какого момента работает нодовское приложение?

    var timer = setTimeout(function() {
        ...
    }, 10000);

    timer.unref();

---

## `setTimeout` vs `setImmediate` vs `process.nextTick`

  * Отпустить тред и затем как можно быстрее исполнить код: `process.nextTick`.
  * Разбить длинную операцию на интервалы, чтобы не фризить основной тред: `setImmediate`.
  * Сделать что-то через N ms: `setTimeout`.
  * `setTimeout(callback, 0)` — не используется в ноде никогда.

---

  * VM.

  * Простой профайлинг и оптимизация.

  * Harmony. Generators.

  * Отладка.

