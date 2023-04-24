package task1;

// ан  массив  ненулевых  целых  чисел  размераN.
// Проверить,  образуют  ли  его элементы геометрическую прогрессию.
// Если образуют, то вывести знаменатель прогрессии, если нет –вывести 0.
public class App {

  public static void main(String[] args) {
    if (args.length < 2) {
      System.err.println("Not enough arguments");
      return;
    }
    boolean is_geometric = true;
    int n0 = Integer.parseInt(args[0]);
    int n1 = Integer.parseInt(args[1]);
    int denom = n1 / n0;
    for (int i = 2; i < args.length; i++) {
      int n = Integer.parseInt(args[i]);
      int tmpDenom = n / n1;
      if (tmpDenom != denom) {
        is_geometric = false;
        break;
      }
      n1 = n;
    }

    if (is_geometric) {
      System.out.println("This sequence is a geometric progression with denominator " + String.valueOf(denom));
    } else {
      System.out.println("This sequence is not a geometric progression");
    }
  }
}
