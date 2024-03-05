import random
import math

# radius of the circle
circle_r = 1
circle_x = 0
circle_y = 0

for _ in range(50):
    # random angle
    alpha = 2 * math.pi * random.random()
    # random radius
    u = random.random() + random.random()
    r = circle_r * (2 - u if u > 1 else u)

    # calculating coordinates
    x = r * math.cos(alpha) + circle_x
    y = r * math.sin(alpha) + circle_y



    print(f"({x:.4f}, {y:.4f}),")