export class Utils {
  static urlWithoutTrailingSlashes(url: string): string {
    return new URL(url).toString().replace(/\/{1,10}$/, '');
  }

  static toStringList(value?: string | string[]): string[] {
    if (!value) {
      return [];
    }
    if (Array.isArray(value)) {
      return value;
    }
    return value
      .split(',')
      .map((x) => x.trim())
      .filter((p) => p);
  }

  static toDate(val: Date | string | number | undefined): Date | undefined {
    if (typeof val === 'number') {
      return new Date(val);
    }
    if (!val) {
      return undefined;
    }
    return new Date(val);
  }
}
