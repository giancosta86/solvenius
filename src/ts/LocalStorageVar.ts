export class LocalStorageVar<T> {
  constructor(private readonly key: string) {}

  get value(): T | null {
    const storedJson = localStorage.getItem(this.key);

    if (!storedJson) {
      return null;
    }

    return JSON.parse(storedJson) as T;
  }

  set value(newValue: T | null) {
    if (newValue != null) {
      localStorage.setItem(this.key, JSON.stringify(newValue));
    } else {
      localStorage.removeItem(this.key);
    }
  }
}
