package task5;

import java.math.BigDecimal;
import java.text.NumberFormat;

public class Gold {
  private String country;
  private GoldColor color;
  private int karat;
  private BigDecimal price;

  public Gold(String country, GoldColor color, int karat, BigDecimal price) {
    this.country = country;
    this.color = color;
    this.karat = karat;
    this.price = price;
  }

  public String getCountry() {
    return country;
  }

  public GoldColor getColor() {
    return color;
  }

  public int getKarat() {
    return karat;
  }

  public BigDecimal getPrice() {
    return price;
  }

  @Override
  public String toString() {
    return String.format(
        "Gold from %s of %s color with purity %oK for for %s per 1 gram",
        country,
        color,
        karat,
        NumberFormat.getCurrencyInstance().format(price));
  }
}

enum GoldColor {
  yellow("yellow"),
  white("white"),
  rose("rose"),
  green("green");

  private final String name;

  private GoldColor(String s) {
    name = s;
  }

  public boolean equalsName(String otherName) {
    return name.equals(otherName);
  }

  public String toString() {
    return this.name;
  }
}
