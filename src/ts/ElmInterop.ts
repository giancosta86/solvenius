export type JsPortListener<T> = (value: T) => void;

export type ToJsPort<T> = {
  subscribe: (listener: JsPortListener<T>) => void;
};

export type ElmSystem = {
  ports: any;
};

export class ElmApp {
  private readonly elmSystem: ElmSystem;

  constructor(elmModule: any, flags: any, appNode?: HTMLElement) {
    let actualAppNode: HTMLElement;
    if (appNode) {
      actualAppNode = appNode;
    } else {
      actualAppNode = document.createElement("div");
      document.body.append(actualAppNode);
    }

    this.elmSystem = elmModule.init({
      node: actualAppNode,
      flags
    }) as ElmSystem;
  }

  private ensurePort(portName: string) {
    if (!Reflect.has(this.elmSystem.ports, portName)) {
      throw new Error(`Port '${portName}' was not published by the Elm system`);
    }
  }

  listenOnJsPort<T>(portName: string, portListener: JsPortListener<T>): this {
    this.ensurePort(portName);
    this.elmSystem.ports[portName].subscribe(portListener);
    return this;
  }

  sendToPort<T>(portName: string, value: T) {
    this.ensurePort(portName);
    this.elmSystem.ports[portName].send(value);
    return this;
  }
}
