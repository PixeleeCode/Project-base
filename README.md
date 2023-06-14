# Projet de base sous Symfony 6.3

## Sommaire

* [Composants Vue](docs/components.md)
* [Mercure](docs/mercure.md)

## Composants pré-installés :
* PHP v.8.2 ;
* PostgresSQL v.15 ;
* Redis v.3.17 :
    * Gestion du cache Symfony ;
    * Gestion des sessions ;
* Caddy v.2.7 ;
* RabbitMQ v.3.12 ;
* TailwindCSS v.3.3.2 avec Webpack Encore.

D'autres éléments comme `ESLint`, `Prettier`, `PHPStan`, `PHPUnit` et `Rector PHP` sont installés.  
Un fichier `make` est présent avec des commandes de bases pour gérer le projet. Pour connaitre les commandes, taper `make help` dans un terminal.

## Installation

```shell
make start
make install-cs-fixer
yarn install --force && yarn build
```

## Docker

Compiler et lancer le serveur Docker :
```shell
make build ## compile les containers
make up ## Lance les containers
make down ## Arrête les containers
# make start ## Regroupe les commandes "make build" et "make up"
```

## Base de données

Il n'y a pas d'interface pour la gestion de la base de données. Passer par son IDE.

```shell
make reset-db ## Installe la basse de données et les migrations
make fixtures ## Remplis la base de données de... donneés
```

## Serveur

Les URLs générées :
```shell
https://localhost ## Projet Symfony
https://localhost/.well-known/mercure ## Mercure Hub
```

Les interfaces :
```shell
http://localhost:15672 ## RabbitMQ
http://localhost:1080 ## MailCatcher
```

Identifiants de l'interface RabbitMQ :
```text
Username: guest
Password: guest
```

Supprimer le cache Symfony & Redis :
```shell
make cc
```

## Assets

Les fichiers `CSS` et `JS` se situent dans le dossier `assets` à la racine du projet.  
Il est possible d'utiliser Stimulus UX si besoin.

Lancer le serveur Webpack de dev :
```shell
yarn watch
```

Ne pas oublier de build pour la prod. :
```shell
yarn build
```

## Qualité du code

La commande ci-dessous permet de tester le code avec : PHP-CS-Fixer, PHPStan et PHP Security Checker

```shell
make quality ## Lance des tests de qualités
```

## Rector PHP

Rector PHP permet de simplifier la maintenance et la mise à jour des projets PHP. 
Il s'appuie sur la bibliothèque de parsing PHP-Parser pour effectuer des analyses de code et des transformations automatisées.
Il peut appliquer des règles de codage spécifiques et corriger automatiquement les erreurs de codage courantes.

```shell
make rector c=dry-run ## Lance Rector PHP, mais ne modifie rien. Mon simplement les potentiels corrections
make rector ## Lance Rector PHP et applique les modifications
```
