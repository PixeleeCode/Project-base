# Fixtures

Les fixtures sont gérées avec le bundle `zenstruck/foundry` ainsi que le bundle `doctrine/doctrine-fixtures-bundle`.

Dans un premier temps, générer une `factory` et ensuite une fixture :

```bash
php bin/console make:factory

> Entity class to create a factory for:
> Post

created: src/Factory/PostFactory.php

Next: Open your new factory and set default values/states.
```

Ensuite :

```bash
php bin/console make:fixtures
```

## Documentation

Plus d'information sur `Foundry` : https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html
