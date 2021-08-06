import { ElmApp } from "./ElmInterop";
import { LocalStorageVar } from "./LocalStorageVar";
import { Elm } from "../elm/Main.elm";
import { ConditionalPlayer } from "./ConditionalPlayer";
import SemVer from "semver/classes/semver";

import pkg from "../../package.json";

import "../scss/main.scss";

type Score = number;

type Settings = { musicEnabled: boolean; soundsEnabled: boolean };

type Flags = {
  initialTopScore: Score;
  initialSettings: Settings;
  version: string;
};

function checkAppVersion() {
  const previousVersionStorage = new LocalStorageVar<string>("previousVersion");

  const previousVersion = new SemVer(
    previousVersionStorage.value ?? pkg.version
  );
  const currentVersion = new SemVer(pkg.version);

  if (currentVersion.compare(previousVersion) == 1) {
    alert(
      `Solvenius just got an automatic update and is ready to run! ^__^\n\nYour new version: ${currentVersion}`
    );
  }

  previousVersionStorage.value = currentVersion.format();
}

function runApp(): void {
  const topScoreStorage = new LocalStorageVar<Score>("topScore");
  const settingsStorage = new LocalStorageVar<Settings>("settings");

  const initialSettings = settingsStorage.value ?? {
    musicEnabled: true,
    soundsEnabled: true
  };

  const flags: Flags = {
    initialTopScore: topScoreStorage.value ?? 0,
    initialSettings,
    version: pkg.version
  };

  const musicPlayer = new ConditionalPlayer(true);
  musicPlayer.enabled = initialSettings.musicEnabled;

  const soundsPlayer = new ConditionalPlayer(false);
  soundsPlayer.enabled = initialSettings.soundsEnabled;

  const app = new ElmApp(Elm.Main, flags);

  app
    .listenOnJsPort("saveTopScore", (topScore: Score) => {
      topScoreStorage.value = topScore;
    })
    .listenOnJsPort("resetTopScore", () => {
      if (confirm("Reset the top score?")) {
        topScoreStorage.value = null;

        app.sendToPort("topScoreChanged", 0);
      }
    })
    .listenOnJsPort("saveSettings", (settings: Settings) => {
      musicPlayer.enabled = settings.musicEnabled;
      soundsPlayer.enabled = settings.soundsEnabled;
      settingsStorage.value = settings;
    })
    .listenOnJsPort("playMusic", (musicPath: string) => {
      musicPlayer.play(musicPath);
    })
    .listenOnJsPort("playSound", (soundPath: string) => {
      soundsPlayer.play(soundPath);
    });
}

function registerServiceWorker(): void {
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker
      .register("service-worker.js")
      .then((registration) => {
        console.log("Service worker registered:", registration);
      })
      .catch((registrationError) => {
        console.log("Service worker registration failed:", registrationError);
      });
  }
}

checkAppVersion();
registerServiceWorker();
runApp();
