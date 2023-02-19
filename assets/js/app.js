// assets/js/app.js
// import "../styles/app.scss"

import { createApp } from "vue"
import Hello from "./components/Hello.vue"

const app = createApp({
  components: {
    Hello
  }
})

console.log(app)

app.mount("#vue-app")
