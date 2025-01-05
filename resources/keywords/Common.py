from PIL import Image, ImageChops
import cv2
import numpy as np

def compare_images(img1_path, img2_path, output_path):
    # Open the images
    img1 = Image.open(img1_path)
    img2 = Image.open(img2_path)

    # Find the differences
    diff = ImageChops.difference(img1, img2)
    # Convert the images to arrays for OpenCV processing
    img1_array = np.array(img1)
    img2_array = np.array(img2)
    diff_array = np.array(diff)

    # Convert the diff array to grayscale
    gray_diff = cv2.cvtColor(diff_array, cv2.COLOR_BGR2GRAY)

    # Threshold the grayscale diff image
    _, thresh_diff = cv2.threshold(gray_diff, 30, 255, cv2.THRESH_BINARY)

    # Find contours of the differences
    contours, _ = cv2.findContours(thresh_diff, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Draw bounding boxes around the differences on the first image
    diff_count = 0
    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)
        cv2.rectangle(img1_array, (x, y), (x + w, y + h), (255, 0, 0), 2)  # Blue bounding box
        diff_count += 1
    if diff_count != 0:
        # Save the result
        result_img = Image.fromarray(img1_array)
        result_img.save(output_path)
    print(f"Total number of differences: {diff_count}")
    assert diff_count == 0, (
        f"Image do not match!."
    )
