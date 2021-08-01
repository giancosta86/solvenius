export class ConditionalPlayer {
  private readonly audioElement: HTMLAudioElement;

  constructor(loop: boolean) {
    this.audioElement = document.createElement("audio");
    this.audioElement.style.display = "none";
    document.body.append(this.audioElement);

    this.audioElement.loop = loop;
  }

  get enabled(): boolean {
    return !this.audioElement.muted;
  }

  set enabled(newValue: boolean) {
    this.audioElement.muted = !newValue;
  }

  play(resource: string) {
    this.audioElement.src = resource;
    this.audioElement.play();
  }
}
