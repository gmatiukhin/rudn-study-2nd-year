package task2;

// Дан массив размера N.
// Найти максимальный из егоэлементов, не являющихся ни локальным минимумом, ни локальным максимумом
// (локальный минимум –это элемент, который меньше любого из своих соседей;
// локальный максимум –это элемент,  который  больше  любого  из своих  соседей).
// Если  таких  элементов  в массиве нет, то вывести 0 (как вещественное число).
public class App {
  public static void main(String[] args) {
    if (args.length < 3) {
      System.err.println("Not enough arguments");
      return;
    }

    int res = 0;

    for (int i = 1; i < args.length - 1; i++) {
      int prev = Integer.parseInt(args[i - 1]);
      int curr = Integer.parseInt(args[i]);
      int next = Integer.parseInt(args[i + 1]);

      if (!(curr < prev && curr < next) && !(curr > prev && curr > next) && curr > res) {
        res = curr;
      }
    }

    System.out.println(res);
  }
}
