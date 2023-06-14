# Composants Vue

La création d'un composant se fera dans le dossier `assets/js/components`.  
Par convention, le fichier doit être écrit en camelCase ou PascalCase.

Structure de base d'un composant :

```vue
<template>
    <h1>Example component VueJS</h1>
</template>

<script>
export default {
    name: "Example",
}
</script>

<style lang="scss" scoped>
h1 {
   @apply text-3xl;
}
</style>
```

## Déclarer le composant

La déclaration du composant se fera de manière automatique.

## Utilisation du composant

Utiliser le composant comme vous utiliseriez un élément HTML :

```html
<Example></Example>
```
