import argparse

import numpy as np
from PIL import Image

# Define your color palettes (from_palette and to_palette) with 4 colors each
from_palette = [
    "#051f39",
    "#4a2480",
    "#c53a9d",
    "#ff8e80",
]  # Input palette (hex colors)

to_palette = [
    "#000000",
    "#555555",
    "#aaaaaa",
    "#ffffff"
]  # Output palette (hex colors)


# Convert hex colors to RGBA tuples
def hex_to_rgba(hex_color):
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4)) + (255,)


# Create mappings from source to target colors
color_mapping = {
    hex_to_rgba(from_color): hex_to_rgba(to_color)
    for from_color, to_color in zip(from_palette, to_palette)
}


# Function to map colors in an image and handle transparency
def map_image_colors(input_path, output_path):
    img = Image.open(input_path).convert(
        "RGBA"
    )  # Ensure we work with an image with alpha channel
    img_array = np.array(img)

    # Apply the color mapping
    for from_color, to_color in color_mapping.items():
        # Find all pixels that match the from_color and replace with to_color
        mask = np.all(
            img_array[:, :, :3] == from_color[:3], axis=-1
        )  # Ignore alpha in comparison
        img_array[mask] = to_color

    # Set pixels with alpha < 255 (not fully opaque) to fully transparent
    img_array[img_array[:, :, 3] < 255] = [0, 0, 0, 0]  # Make them fully transparent

    # Save the new image
    new_img = Image.fromarray(img_array, "RGBA")
    new_img.save(output_path)
    print(f"Image saved to {output_path}")


# Argument parsing setup
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Map an image's colors from one palette to another, respecting transparency."
    )

    parser.add_argument("input_image", type=str, help="Path to the input image file.")
    parser.add_argument(
        "output_image", type=str, help="Path to save the output image file."
    )

    args = parser.parse_args()

    # Call the function with parsed arguments
    map_image_colors(args.input_image, args.output_image)
