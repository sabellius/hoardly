import { render } from "@testing-library/react-native";
import { ThemedText } from "@/components/themed-text";

describe("<ThemedText />", () => {
  it("renders its children", async () => {
    const { getByText } = await render(<ThemedText>harness check</ThemedText>);
    expect(getByText("harness check")).toBeTruthy();
  });
});
