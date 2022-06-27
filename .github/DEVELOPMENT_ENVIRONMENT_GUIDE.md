# Development environment guide

## Preparing

Clone `rom-mongodb` repository:

```bash
git clone https://github.com/bestwebua/rom-mongo.git
cd  rom-mongo
```

Configure latest Ruby environment:

```bash
echo 'ruby-3.1.2' > .ruby-version
cp .circleci/gemspec_latest rom-mongodb.gemspec
```

## Commiting

Commit your changes excluding `.ruby-version`, `rom-mongodb.gemspec`

```bash
git add . ':!.ruby-version' ':!rom-mongodb.gemspec'
git commit -m 'Your new awesome rom-mongodb feature'
```
