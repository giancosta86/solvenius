const pkg = require("./package.json");

const path = require("path");

const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin");
const FaviconsWebpackPlugin = require("favicons-webpack-plugin");
const WorkboxPlugin = require("workbox-webpack-plugin");

const moduleDirs = [/elm-stuff/, /node_modules/];

const userFriendlyVersion = pkg.version.replace(/\.0/g, "");
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
    path: path.resolve(__dirname, "dist", "solvenius"),
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
      patterns: [{ from: "static", to: "" }]
    }),
    new WorkboxPlugin.GenerateSW({
      clientsClaim: true,
      skipWaiting: true
    }),
    new FaviconsWebpackPlugin({
      manifest: "./src/manifest-extra.json",
      logo: "logo.svg",
      logoMaskable: "maskable.svg",
      cache: true,
      favicons: {
        appName: "Solvenius",
        appShortName: "Solvenius",
        appDescription:
          "💡Logic game in modern Elm: guess as many random 🧮digit sequences as you can, before the ⏱️time expires!",
        dir: "auto",
        lang: "en-US",
        background: "#fff",
        theme_color: "#fff",
        appleStatusBarStyle: "black-translucent",
        display: "fullscreen",
        orientation: "portrait",
        scope: "/solvenius/",
        start_url: "/solvenius/",
        version: pkg.version,

        icons: {
          android: true,
          appleIcon: true,
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
          filename: `${route}.html`,
          meta: {
            author: "Gianluca Costa",
            version: pkg.version,
            ogTitle: {
              property: "og:title",
              content: `Solvenius ${userFriendlyVersion}`
            },
            ogUrl: { property: "og:url", content: pkg.homepage },
            ogDescription: {
              property: "og:description",
              content: pkg.description
            },
            ogImage: {
              property: "og:image",
              content: `${pkg.homepage}/preview.png`
            }
          }
        })
    )
  )
};
