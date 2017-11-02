/*§
  ===========================================================================
  Solvenius
  ===========================================================================
  Copyright (C) 2001-2017 Gianluca Costa
  ===========================================================================
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ===========================================================================
*/

var topScoreKey = "topScore"


window.onload = function() {
  if (requiresInteractiveStart()) {
    var loadingMessage = document.getElementById("loadingMessage")
    loadingMessage.parentNode.removeChild(loadingMessage)

    var startButton = document.getElementById("startButton")
    startButton.style.display = "block"
  } else {
    run()
  }
}


function requiresInteractiveStart() {
  var userAgent = navigator.userAgent.toLowerCase()

  var isWebKit = userAgent.indexOf("webkit") > -1

  var isMobile = userAgent.indexOf("android") > -1
    || userAgent.indexOf("mobile") > -1
    || userAgent.indexOf("ipad") > -1
    || userAgent.indexOf("ios") > -1

  return isWebKit && isMobile
}


function run() {
  initElm()
  playMusic()
  hideLoadingBox()

  showAppBox()
}


function initElm() {
  var topScore = getTopScore()

  var appBox = document.getElementById("appBox")

  solvenius = Elm.embed(Elm.Main, appBox, {
    topScoreInput: topScore
  });

  solvenius.ports.topScoreInput.send(topScore)

  solvenius.ports.scoreOutput.subscribe(checkForTopScore)
}


function playMusic() {
  var musicPlayer = document.getElementById("musicPlayer")
  musicPlayer.play()
}


function hideLoadingBox() {
  var loadingBox = document.getElementById("loadingBox")

  loadingBox.parentNode.removeChild(loadingBox)
}


function showAppBox() {
  var appBox = document.getElementById("appBox")

  appBox.style.display = "block"
}


function getTopScore() {
  var topScore = parseInt(localStorage.getItem(topScoreKey))

  if (topScore === null || isNaN(topScore)) {
    return 0
  }

  return topScore
}


function checkForTopScore(score) {
  if (score > getTopScore()) {
    localStorage.setItem(topScoreKey, score)
    alert("Congratulations! ^__^\n\nYou have achieved a new top score!")
  }
}


function interactiveTopScoreReset() {
  if (confirm("Do you really wish to clear your high score?")) {
    localStorage.removeItem(topScoreKey)
    solvenius.ports.topScoreInput.send(0)
  }
}


function openFacebookPage() {
  websiteUrl = "https://www.facebook.com/solvenius"

  window.open(websiteUrl, "_blank");
}


function openGithubPage() {
  gitHubProjectUrl = "https://github.com/giancosta86/solvenius"

  window.open(gitHubProjectUrl, "_blank");
}


function tryToGoBack() {
  var backButton = document.getElementById("backButton")

  if (backButton) {
    backButton.click()
    return "OK"
  } else {
    return null
  }
}