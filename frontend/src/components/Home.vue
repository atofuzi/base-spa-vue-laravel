<script setup>
import { useStore } from 'vuex'
const store = useStore();
const helloWorld =  store.getters.getHelloWorld;

</script>

<template>
  <div>
    <h1 class="text-3xl font-bold underline">
      {{ helloWorld }}
    </h1>
    <img alt="Vue logo" src="@/assets/logo.png" class="mx-auto">
    <HelloWorld msg="Welcome to Your Vue.js App"/>
  </div>
</template>

<script>
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
