import { createStore } from 'vuex';

const store = createStore({
  state () {
    return {
      helloWorld: 'Hello World !!!!'
    }
  },
  getters: {
    getHelloWorld: state => state.helloWorld,
  },
  mutations: {
    setHelloWorld(state, args) {
      state.helloWorld = args
    }
  },
  actions: {
    setHelloWorld(context, args) {
      context.commit('setHelloWorld', args);
    },
  }
});

export default store;