import "../styles/app.scss";

import { createApp } from "vue";
import Example from "./components/Example.vue";

const app = createApp({});
app.component("example", Example);
app.mount("#vue-app");
