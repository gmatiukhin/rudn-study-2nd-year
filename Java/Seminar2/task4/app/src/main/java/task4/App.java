// Дана матрица размера NxM.
// Преобразовать матрицу, поменяв  местами  минимальный  имаксимальный элемент в каждой строке.

package task4;

import java.util.Arrays;

// Programm accepts arguments from command line
// 1st and 2nd arguments are width and height of the matrix
// everything after is the matrix itsel
// 
// e.g. 3 2 1 2 3 4 5 6 => Matrix = 1 2 3
//                                  4 5 6
// for purposes of this task matrix should contain at least two elements
public class App {
  public void transformMatrix(int width, int height, int[] matrix) {
    for (int i = 0; i < height; i++) {
      int min = Integer.MAX_VALUE;
      int minIndex = -1;
      int max = Integer.MIN_VALUE;
      int maxIndex = -1;

      for (int j = 0; j < width; j++) {
        int index = i * width + j;
        if (matrix[index] < min) {
          min = matrix[index];
          minIndex = index;
        }

        if (matrix[index] > max) {
          max = matrix[index];
          maxIndex = index;
        }
      }

      matrix[minIndex] = max;
      matrix[maxIndex] = min;
    }
  }

  public static String prettyPrintMatrix(int width, int height, int[] matrix) {
    StringBuilder outputBuilder = new StringBuilder();
    for (int i = 0; i < matrix.length; i++) {
      if (i % width == 0) {
        outputBuilder.append("\n");
      }
      outputBuilder.append(matrix[i] + " ");
    }
    return outputBuilder.toString();
  }

  public static void main(String[] args) {
    if (args.length < 4) {
      System.err.println("Not enough arguments");
      return;
    }

    int width = Integer.parseInt(args[0]);
    int height = Integer.parseInt(args[1]);
    int[] matrix = Arrays.stream(
        Arrays
            .copyOfRange(
                args,
                2,
                args.length))
        .mapToInt(Integer::parseInt)
        .toArray();

    System.out.println("Initial matrix:\n" + prettyPrintMatrix(width, height, matrix));
    new App().transformMatrix(width, height, matrix);
    System.out.println("New matrix:\n" + prettyPrintMatrix(width, height, matrix));
  }
}
