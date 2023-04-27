// Дана  целочисленная  матрица A(N,M). 
// Определить, встречается ли заданное целое K среди максимальных элементов столбцов этой матрицы.

package task3;

import java.util.Arrays;
import java.util.stream.IntStream;

// Programm accepts arguments from command line
// The first argumen is the numbe K
// 2nd and 3rd are width and height of the matrix
// everything after is the matrix itsel
// e.g. 10 3 2 1 2 3 4 5 6 => Matrix = 1 2 3; K = 10
//                                     4 5 6
public class App {

  public boolean isKinMaxInColums(int k, int width, int height, int[] matrix) {
    int[] maxInColumns = new int[width]; // Max element in every column
    Arrays.fill(maxInColumns, Integer.MIN_VALUE);

    for (int i = 0; i < width * height; i++) {
      int columnIndex = i % width;

      if (matrix[i] > maxInColumns[columnIndex]) {
        maxInColumns[columnIndex] = matrix[i];
      }
    }

    return IntStream.of(maxInColumns).anyMatch(x -> x == k);
  }

  public static void main(String[] args) {
    if (args.length < 3) {
      System.err.println("Not enough arguments");
      return;
    }

    int k = Integer.parseInt(args[0]);
    int width = Integer.parseInt(args[1]);
    int height = Integer.parseInt(args[2]);

    if (width * height != args.length - 3) {
      System.err.println("Matrix data differs from dimensions");
      return;
    }

    boolean res = new App()
        .isKinMaxInColums(
            k,
            width,
            height,
            // Select only matrix data from the input args
            Arrays.stream(
                Arrays
                    .copyOfRange(
                        args,
                        3,
                        args.length))
                .mapToInt(Integer::parseInt)
                .toArray());

    System.out.println(
        "Is value k = " + k + " one of the column maximums?\n"
            + res);

  }
}
