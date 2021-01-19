<template lang="pug">
  #app
    Camera
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

#app {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}
</style>
