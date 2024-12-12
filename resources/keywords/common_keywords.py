from robot.api.deco import keyword
from selenium.webdriver.common.by import By
from robot.libraries.BuiltIn import BuiltIn
from PIL import Image, ImageChops
import cv2
import numpy as np

@keyword
def extract_text_by_class_name(driver, class_name, text_expected):
    # Locate the element and get the text
    header_element = driver.find_element(By.CLASS_NAME, class_name)
    header_text = header_element.text

    assert header_text == text_expected, (
        f"Header do not match! Expected: {text_expected}, but got: {header_text}."
    )

@keyword
def get_element_text(driver, locator_type, locator_value):
    """
    Retrieve the text of a web element on a webpage.

    :param driver: WebDriver instance used to interact with the webpage.
    :param locator_type: Type of the locator (e.g., 'id', 'xpath', 'css', 'name').
    :param locator_value: Value of the locator to find the element.
    :return: Text content of the web element.
    """
    try:
        # Define the locator strategy
        locator_strategy = {
            "id": By.ID,
            "xpath": By.XPATH,
            "css": By.CSS_SELECTOR,
            "name": By.NAME,
            "class": By.CLASS_NAME,
            "tag": By.TAG_NAME,
            "link": By.LINK_TEXT,
            "partial_link": By.PARTIAL_LINK_TEXT
        }

        if locator_type not in locator_strategy:
            raise ValueError(f"Unsupported locator type: {locator_type}")

        # Find the element and retrieve its text
        element = driver.find_element(locator_strategy[locator_type], locator_value)
        return element.text
    except Exception as e:
        print(f"Error occurred while retrieving text: {e}")
        return ""


@keyword
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

@keyword
def get_webdriver():
    # Retrieve the WebDriver instance from SeleniumLibrary
    selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')
    return selenium_lib.driver


def get_list_difference(list1, list2):
    """
    Get the difference between two lists using Python's set operations.

    :param list1: The first list.
    :param list2: The second list.
    :return: A list of items that are in list1 but not in list2.
    """
    return list(set(list1) - set(list2))