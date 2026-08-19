import { formatQuantity } from "@/shared/lib/format-quantity";

describe("formatQuantity", () => {
  it("formats integers", () => {
    expect(formatQuantity(2, "pc")).toBe("2 pc");
  });

  it("formats fractions", () => {
    expect(formatQuantity(0.5, "bunch")).toBe("0.5 bunch");
    expect(formatQuantity(1.25, "kg")).toBe("1.25 kg");
  });

  it("formats zero", () => {
    expect(formatQuantity(0, "ml")).toBe("0 ml");
  });
});
