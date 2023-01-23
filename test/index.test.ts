import * as sut from "../src";

describe("utils", () => {
  test("trim trailing slashes from url", () => {
    const f = sut.Utils.urlWithoutTrailingSlashes;
    expect(() => f("abc")).toThrow("Invalid URL");
    expect(f("https://example.com")).toEqual("https://example.com");
    expect(f("https://example.com/")).toEqual("https://example.com");
    expect(f("https://example.com//")).toEqual("https://example.com");
    expect(f("https://example.com///")).toEqual("https://example.com");
  });

  test("parse date", () => {
    expect(sut.Utils.toDate("")).toBeUndefined();
    expect(sut.Utils.toDate(0)).toEqual(new Date("1970-01-01T00:00:00.000Z"));
    expect(sut.Utils.toDate("2021-06-04T02:24:57.000Z")?.getTime()).toEqual(
      1622773497000
    );
    expect(sut.Utils.toDate(1622773497000)).toEqual(
      new Date("2021-06-04T02:24:57.000Z")
    );
  });
});
