# Base Symfony 6.1

Composants pré-installés :
* PHP v.8.1;
* PostgresSQL v.14;
* Redis v.3.16 :
    * Gestion du cache Symfony;
* Caddy v.2;
* RabbitMQ v.3.7;
* TailwindCSS v.3.2.4 avec Webpack Encore;

D'autres éléments comme `ESLint`, `Prettier`, `PHPStan` et `PHPUnit` sont installés.  
Un fichier `make` est présent avec des commandes de bases pour gérer le projet. Pour connaitre les commandes, taper `make help` dans un terminal.

## Installation

```shell
make start
make composer c=install
make install-cs-fixer
npm install
```

## Docker

Compiler et lancer le serveur Docker :
```shell
make build
make up
# make start ## Regroupe les deux commandes ci-dessus
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
https://localhost # Projet Symfony
https://localhost/.well-known/mercure # Mercure Hub
```

Les interfaces :
```shell
http://localhost:50622 # RabbitMQ
http://localhost:1080 # MailCatcher
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
npm run watch
```

## Qualité du code

La commande ci-dessous permet de tester le code avec : PHP-CS-Fixer, PHPStan et PHP Security Checker

```shell
make quality ## Lance des tests de qualités
```
