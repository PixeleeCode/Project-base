import "../styles/app.scss";
import { createApp } from "vue"

const app = createApp({});
const files = require.context('./components', true, /\.vue$/i)

files.keys().map(key => {
  const name = key.split('/').pop().split('.')[0]
  app.component(name, files(key).default)
})

app.mount("#vue-app");
