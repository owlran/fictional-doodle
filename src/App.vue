<template lang="pug">
  #app
    Camera
    img(alt="Vue logo" src="./assets/logo.png")
</template>

<script>
import Camera from "@/components/Camera";

export default {
  name: 'App',
  components: {
    Camera,
  }
}
</script>

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
</style>
