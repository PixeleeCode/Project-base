# Composants Vue

La création d'un composant se fera dans le dossier `assets/js/components`. Par convention, le fichier doit être écrit 
en UpperCamelCase.

Structure de base d'un composant :

```vue
<template>
  <div>
    <!-- Code -->
  </div>
</template>

<script>
export default {
  name: "NameComponent"
}
</script>

<style lang="scss" scoped>

</style>
```

## Déclarer le composant

La déclaration du composant se fera dans le fichier `assets/js/app.js`.

```js
// assets/js/app.js
import "../styles/app.scss";

import { createApp } from "vue"
import Example from "./components/Example.vue";
import Example2 from "./components/Example2.vue";

const app = createApp({});
app.component("example", Example);
app.component("example2", Example2);
app.mount("#vue-app");
```

## Utilisation du composant

Utiliser le composant comme vous utiliseriez un élément HTML :

```html
<example></example>
```
