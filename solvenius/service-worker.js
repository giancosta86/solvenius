if(!self.define){const e=e=>{"require"!==e&&(e+=".js");let s=Promise.resolve();return a[e]||(s=new Promise((async s=>{if("document"in self){const a=document.createElement("script");a.src=e,document.head.appendChild(a),a.onload=s}else importScripts(e),s()}))),s.then((()=>{if(!a[e])throw new Error(`Module ${e} didn’t register its module`);return a[e]}))},s=(s,a)=>{Promise.all(s.map(e)).then((e=>a(1===e.length?e[0]:e)))},a={require:Promise.resolve(s)};self.define=(s,r,c)=>{a[s]||(a[s]=Promise.resolve().then((()=>{let a={};const i={uri:location.origin+s.slice(1)};return Promise.all(r.map((s=>{switch(s){case"exports":return a;case"module":return i;default:return e(s)}}))).then((e=>{const s=c(...e);return a.default||(a.default=s),a}))})))}}define("./service-worker.js",["./workbox-15dd0bab"],(function(e){"use strict";self.skipWaiting(),e.clientsClaim(),e.precacheAndRoute([{url:"about.html",revision:"4dfe704cabdda7f5d2cd824d5a194fe3"},{url:"assets/android-chrome-144x144.png",revision:"f18463e476eeb99b9e25c773e8177543"},{url:"assets/android-chrome-192x192.png",revision:"01a3bcf7ec83c2c5292321e640164679"},{url:"assets/android-chrome-256x256.png",revision:"564dd07b4bbd1ca925a834864f64abd5"},{url:"assets/android-chrome-36x36.png",revision:"e9145831532fd088f988cff7179b6ee7"},{url:"assets/android-chrome-384x384.png",revision:"2968c5821ab3fd6e563403bc6d1a69cc"},{url:"assets/android-chrome-48x48.png",revision:"e754bc834f5aee0a85b73fd477d61ac3"},{url:"assets/android-chrome-512x512.png",revision:"b8540a630e421b4b541c62f70eafc318"},{url:"assets/android-chrome-72x72.png",revision:"efd9f696687238f40b4fed2bf3b2b438"},{url:"assets/android-chrome-96x96.png",revision:"e6580a6b9cba15cc5b952973de9b3e1c"},{url:"assets/apple-touch-icon-1024x1024.png",revision:"fa6f5a22a44aa0855d961a656de7929e"},{url:"assets/apple-touch-icon-114x114.png",revision:"18e773c31d614c37b656ce639d78b883"},{url:"assets/apple-touch-icon-120x120.png",revision:"ac21d3f9eb8969b7168b706c122f7719"},{url:"assets/apple-touch-icon-144x144.png",revision:"35c392b6015859945a7a945b5434c158"},{url:"assets/apple-touch-icon-152x152.png",revision:"fcc04540b790355f23523a5a027d4703"},{url:"assets/apple-touch-icon-167x167.png",revision:"c67960b897c3660fa8df6f9a0a30a6d8"},{url:"assets/apple-touch-icon-180x180.png",revision:"e3ce17737f47d883ed95771733a65118"},{url:"assets/apple-touch-icon-57x57.png",revision:"9b6ea6865c19a3cbb58d345a36afb9ed"},{url:"assets/apple-touch-icon-60x60.png",revision:"b242e5b16a0963013bf38e9744080078"},{url:"assets/apple-touch-icon-72x72.png",revision:"65a046f126838cfd1c6928a81eb30abd"},{url:"assets/apple-touch-icon-76x76.png",revision:"7cf037bc80a175a6cbdea64b9637ca76"},{url:"assets/apple-touch-icon-precomposed.png",revision:"e3ce17737f47d883ed95771733a65118"},{url:"assets/apple-touch-icon.png",revision:"e3ce17737f47d883ed95771733a65118"},{url:"assets/favicon-16x16.png",revision:"0c5dbcf26e6963e0922f328971351652"},{url:"assets/favicon-32x32.png",revision:"3e2a3505c6d5f03ac7089c4c6c80773f"},{url:"assets/favicon-48x48.png",revision:"e754bc834f5aee0a85b73fd477d61ac3"},{url:"assets/favicon.ico",revision:"c771e745e03b0868361391b257b22e4e"},{url:"assets/manifest.json",revision:"1419e404897884112fa2b4f86c54449c"},{url:"game.html",revision:"4dfe704cabdda7f5d2cd824d5a194fe3"},{url:"game.mp3",revision:"634f29cfd8464e54935fdfb23d567169"},{url:"help.html",revision:"4dfe704cabdda7f5d2cd824d5a194fe3"},{url:"index.html",revision:"4dfe704cabdda7f5d2cd824d5a194fe3"},{url:"perfectMatch.mp3",revision:"f48d6c9b61ca5fffbc3538cfab7ea48f"},{url:"settings.html",revision:"4dfe704cabdda7f5d2cd824d5a194fe3"},{url:"solvenius.18479fab31e1ca2b2d1d.js",revision:null},{url:"title.mp3",revision:"2bdadd4db8dc85928ab90a2931fec487"},{url:"top-score.html",revision:"4dfe704cabdda7f5d2cd824d5a194fe3"}],{})}));
