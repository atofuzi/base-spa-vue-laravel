const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    client: {
      webSocketURL: {
        hostname: '0.0.0.0',
        pathname: '/ws',
        port: 8088,
        protocol: 'ws',
      },
    }
  }
})
