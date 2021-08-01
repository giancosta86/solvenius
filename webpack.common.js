const pkg = require("./package.json");

const path = require("path");

const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin");
const FaviconsWebpackPlugin = require("favicons-webpack-plugin");
const WorkboxPlugin = require("workbox-webpack-plugin");

const moduleDirs = [/elm-stuff/, /node_modules/];

const routes = ["index", "game", "top-score", "settings", "about", "help"];

module.exports = {
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: moduleDirs,
        use: "elm-webpack-loader"
      },

      {
        test: /\.tsx?$/,
        exclude: moduleDirs,
        use: "ts-loader"
      },

      {
        test: /\.s[ac]ss$/i,
        exclude: moduleDirs,
        use: ["style-loader", "css-loader", "sass-loader"]
      }
    ]
  },

  entry: "./src/ts/main.ts",

  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "solvenius.[contenthash].js"
  },

  resolve: {
    extensions: [".ts", ".tsx", "..."]
  },

  performance: {
    assetFilter: (asset) => {
      return asset.match(`\.js$`);
    }
  },

  plugins: [
    new CleanWebpackPlugin(),
    new CopyPlugin({
      patterns: [{ from: "audio", to: "" }]
    }),
    new WorkboxPlugin.GenerateSW({
      clientsClaim: true,
      skipWaiting: true
    }),
    new FaviconsWebpackPlugin({
      logo: "logo.svg",
      cache: true,
      favicons: {
        appName: "Solvenius",
        appShortName: "Solvenius",
        appDescription: pkg.description,
        developerName: "Gianluca Costa",
        developerURL: "https://gianlucacosta.info/",
        dir: "auto",
        lang: "en-US",
        background: "#fff",
        theme_color: "#fff",
        appleStatusBarStyle: "black-translucent",
        display: "fullscreen",
        orientation: "portrait",
        scope: "/",
        start_url: "/",
        version: pkg.version,

        icons: {
          android: true,
          appleIcon: false,
          appleStartup: false,
          coast: false,
          favicons: true,
          firefox: false,
          windows: false,
          yandex: false
        }
      }
    })
  ].concat(
    routes.map(
      (route) =>
        new HtmlWebpackPlugin({
          title: "Solvenius",
          filename: `${route}.html`
        })
    )
  )
};
