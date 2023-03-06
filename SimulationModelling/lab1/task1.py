import numpy as np
import copy

def unit_vector(vector):
    """ Returns the unit vector of the vector.  """
    return vector / np.linalg.norm(vector)

def angle_between(v1, v2):
    """ Returns the angle in degrees between vectors 'v1' and 'v2'::

            >>> angle_between((1, 0, 0), (0, 1, 0))
            1.5707963267948966
            >>> angle_between((1, 0, 0), (1, 0, 0))
            0.0
            >>> angle_between((1, 0, 0), (-1, 0, 0))
            3.141592653589793
    """
    v1_u = unit_vector(v1)
    v2_u = unit_vector(v2)
    return np.rad2deg(np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0)))

def is_scalene(triangle):
    for i in range(len(triangle)):
        trig = copy.deepcopy(triangle)
        origin = trig[i]
        side1 = trig[i - 1]
        side2 = trig[(i + 1) % len(triangle)]

        # Move vectors to origin
        side1 -= origin
        side2 -= origin

        angle = angle_between(side1, side2)

        if angle > 90:
            return True
    return False

def main():
    iters = 100000
    count = 0

    for _ in range(iters):
        # Generate a triangle
        triangle = []
        for _ in range(3):
            x = np.random.uniform(0, 1)
            y = np.random.uniform(0, 1)
            triangle.append(np.array([x, y]))
        if is_scalene(triangle):
            count += 1
    print(count / iters)


if __name__ == "__main__":
    main()
