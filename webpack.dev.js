const { merge } = require("webpack-merge");
const common = require("./webpack.common.js");

module.exports = merge(common, {
  mode: "development",

  devtool: "inline-source-map",

  devServer: {
    historyApiFallback: {
      rewrites: [{ from: /^\/solvenius\/.+/, to: "/solvenius/" }]
    },

    overlay: true,

    host: "0.0.0.0",

    publicPath: "/solvenius/",
    openPage: "solvenius/"
  }
});
