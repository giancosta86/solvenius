if(!self.define){const e=e=>{"require"!==e&&(e+=".js");let r=Promise.resolve();return s[e]||(r=new Promise((async r=>{if("document"in self){const s=document.createElement("script");s.src=e,document.head.appendChild(s),s.onload=r}else importScripts(e),r()}))),r.then((()=>{if(!s[e])throw new Error(`Module ${e} didn’t register its module`);return s[e]}))},r=(r,s)=>{Promise.all(r.map(e)).then((e=>s(1===e.length?e[0]:e)))},s={require:Promise.resolve(r)};self.define=(r,i,a)=>{s[r]||(s[r]=Promise.resolve().then((()=>{let s={};const c={uri:location.origin+r.slice(1)};return Promise.all(i.map((r=>{switch(r){case"exports":return s;case"module":return c;default:return e(r)}}))).then((e=>{const r=a(...e);return s.default||(s.default=r),s}))})))}}define("./service-worker.js",["./workbox-15dd0bab"],(function(e){"use strict";self.skipWaiting(),e.clientsClaim(),e.precacheAndRoute([{url:"about.html",revision:"3373ecab8e55a9975178589ad5f4fadb"},{url:"assets/android-chrome-144x144.png",revision:"f18463e476eeb99b9e25c773e8177543"},{url:"assets/android-chrome-192x192.png",revision:"01a3bcf7ec83c2c5292321e640164679"},{url:"assets/android-chrome-256x256.png",revision:"564dd07b4bbd1ca925a834864f64abd5"},{url:"assets/android-chrome-36x36.png",revision:"e9145831532fd088f988cff7179b6ee7"},{url:"assets/android-chrome-384x384.png",revision:"2968c5821ab3fd6e563403bc6d1a69cc"},{url:"assets/android-chrome-48x48.png",revision:"e754bc834f5aee0a85b73fd477d61ac3"},{url:"assets/android-chrome-512x512.png",revision:"b8540a630e421b4b541c62f70eafc318"},{url:"assets/android-chrome-72x72.png",revision:"efd9f696687238f40b4fed2bf3b2b438"},{url:"assets/android-chrome-96x96.png",revision:"e6580a6b9cba15cc5b952973de9b3e1c"},{url:"assets/favicon-16x16.png",revision:"0c5dbcf26e6963e0922f328971351652"},{url:"assets/favicon-32x32.png",revision:"3e2a3505c6d5f03ac7089c4c6c80773f"},{url:"assets/favicon-48x48.png",revision:"e754bc834f5aee0a85b73fd477d61ac3"},{url:"assets/favicon.ico",revision:"c771e745e03b0868361391b257b22e4e"},{url:"assets/manifest.json",revision:"1419e404897884112fa2b4f86c54449c"},{url:"game.html",revision:"3373ecab8e55a9975178589ad5f4fadb"},{url:"game.mp3",revision:"634f29cfd8464e54935fdfb23d567169"},{url:"help.html",revision:"3373ecab8e55a9975178589ad5f4fadb"},{url:"index.html",revision:"3373ecab8e55a9975178589ad5f4fadb"},{url:"perfectMatch.mp3",revision:"f48d6c9b61ca5fffbc3538cfab7ea48f"},{url:"settings.html",revision:"3373ecab8e55a9975178589ad5f4fadb"},{url:"solvenius.45efebe6ca93691fe8de.js",revision:null},{url:"title.mp3",revision:"2bdadd4db8dc85928ab90a2931fec487"},{url:"top-score.html",revision:"3373ecab8e55a9975178589ad5f4fadb"}],{})}));
