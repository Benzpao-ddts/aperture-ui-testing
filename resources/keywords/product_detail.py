import random
from robot.api.deco import keyword
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.ui import Select


@keyword
def get_product_names(driver, product_expected, get_from):
    """
    Get the list of product names from the cart.

    :param driver: The WebDriver instance.
    :return: A list of product names found in the cart.
    """
    cart_items = driver.find_elements(By.XPATH, "//div[@class='cart_list']/div[contains(@class, 'cart_item')]")
    print(f"Total cart items found: {len(cart_items)}")

    product_names = []
    more_detail_list = []
    for item in cart_items:
        product_name_element = item.find_element(By.CLASS_NAME, "inventory_item_name")
        product_name = product_name_element.text
        product_names.append(product_name)

        # Extract the item name
        item_name = item.find_element(By.CLASS_NAME, "inventory_item_name").text

        # Extract the item description
        item_desc = item.find_element(By.CLASS_NAME, "inventory_item_desc").text

        # Extract the item price
        item_price = item.find_element(By.CLASS_NAME, "inventory_item_price").text
        if (get_from == 'Cart'):
            # Extract the button name (e.g., "Add to cart")
            button_name = item.find_element(By.CLASS_NAME, "cart_button").text
            assert button_name == 'Remove', "The button doesn't display Remove"

        # Add the item details to the list
        more_detail_list.append({
            'item_name': item_name,
            'item_desc': item_desc,
            'item_price': item_price,
        })

    assert set(product_names) == set(product_expected), (
        f"Products do not match! Expected: {product_expected}, but got: {product_names}."
    )
    print('more_detail_list', more_detail_list)
    return more_detail_list

@keyword
def get_product_names_from_cart(driver, product_expected, get_from='Cart'):
    return get_product_names(driver, product_expected, get_from)

@keyword
def get_product_names_from_overview(driver, product_expected, get_from='Overview'):
    return get_product_names(driver, product_expected, get_from)

@keyword
def check_item_total(driver, total_expected):
    # Locate the element
    subtotal_label = driver.find_element(By.CLASS_NAME, "summary_subtotal_label")

    # Get the text content of the element
    subtotal_text = subtotal_label.text
    subtotal = round(float(subtotal_text.split('$')[-1]), 2)
    str_total_price_expected = (sum(float(item['item_price'].strip('$')) for item in total_expected))

    print(subtotal)
    print(str_total_price_expected)

    assert subtotal == str_total_price_expected, (
        f"Subtotal do not match! Expected: {str_total_price_expected}, but got: {subtotal_text}."
    )

    tax_label = driver.find_element(By.CLASS_NAME, "summary_tax_label")
    tax_label_text = tax_label.text
    tax_total = round(float(tax_label_text.split('$')[-1]), 2)

    summary_total_label = driver.find_element(By.CLASS_NAME, "summary_total_label")
    summary_total_label_text = summary_total_label.text
    summary_total = round(float(summary_total_label_text.split('$')[-1]), 2)

    summary_expected = round(float(subtotal + tax_total), 2)

    assert summary_total == summary_expected, (
        f"Summary Total do not match! Expected: {summary_expected}, but got: {summary_total}."
    )

@keyword
def get_inventory_list(driver):
    """
    Retrieve a structured inventory list from the page.

    :param driver: Selenium WebDriver instance
    :return: List of dictionaries containing inventory details
    """
    inventory_list = []

    # Find all inventory items
    inventory_items = driver.find_elements(By.CLASS_NAME, "inventory_item_description")

    for index, item in enumerate(inventory_items, start=1):
        # Extract the item name
        item_name = item.find_element(By.CLASS_NAME, "inventory_item_name").text

        # Extract the item description
        item_desc = item.find_element(By.CLASS_NAME, "inventory_item_desc").text

        # Extract the item price
        item_price = item.find_element(By.CLASS_NAME, "inventory_item_price").text

        # Extract the button name (e.g., "Add to cart")
        button_name = item.find_element(By.CLASS_NAME, "btn_inventory").text

        # Add the item details to the list
        inventory_list.append({
            'item_number': index,
            'item_name': item_name,
            'item_desc': item_desc,
            'item_price': item_price,
            'button_name': button_name,
        })

    return inventory_list


@keyword
def select_random_product_and_compare(driver, num_products):
    # Get the inventory list from the page
    inventory_list = get_inventory_list(driver)
    selected_index = random.sample(range(len(inventory_list)), int(num_products))

    return selected_index

@keyword
def click_cart_button(driver, selected_index, action, status_expected, remove_index=None):
    # Locate the inventory container
    inventory_container = driver.find_element(By.CLASS_NAME, "inventory_container")

    # Find all inventory items within the container
    inventory_items = inventory_container.find_elements(By.CLASS_NAME, "inventory_item_description")
    print(f"Total inventory items found: {len(inventory_items)}")

    # Validate the indices
    if any(index < 0 or index > len(inventory_items) for index in selected_index):
        raise IndexError(f"Some indices are out of range. Valid range is 0 to {len(inventory_items)}.")

    # Track product names for logging
    product_names = []

    if action == "Remove" and remove_index is not None:
        print('selected_index Original', selected_index)
        selected_index = random.sample(selected_index, int(remove_index))
        print('selected_index Remove', selected_index)

    for index in selected_index:
        print('selected_index', selected_index)
        # Re-fetch the inventory container and items in each iteration
        inventory_container = driver.find_element(By.CLASS_NAME, "inventory_container")
        inventory_items = inventory_container.find_elements(By.CLASS_NAME, "inventory_item_description")

        # Validate the index
        if index < 0 or index > len(inventory_items):
            raise IndexError(f"Index {index} is out of range. There are only {len(inventory_items)} items.")

        # Access the inventory item by index
        item = inventory_items[index]

        # Find the "Add to Cart" or "Remove" button based on action
        cart_button = item.find_element(By.CLASS_NAME, "btn_inventory")

        # Click the button
        cart_button.click()

        # Get the item name for logging
        item_name = item.find_element(By.CLASS_NAME, "inventory_item_name").text
        product_names.append(item_name)
        print('product_names', product_names)

        # Wait for the button text to change to "Remove"
        WebDriverWait(driver, 10).until(
            lambda d: item.find_element(By.CLASS_NAME, "btn_inventory").text == status_expected
        )

    return product_names

@keyword
def click_add_to_cart(driver, selected_index):
    return click_cart_button(driver, selected_index, "Add to cart", "Remove")

@keyword
def click_remove_from_cart(driver, selected_index, remove_index=None):
    return click_cart_button(driver, selected_index, "Remove", "Add to cart", remove_index)

@keyword
def check_and_get_cart_badge(driver, expected_count):
    """
    Checks if the shopping cart badge exists and retrieves its text.

    """

    # Locate the cart container
    cart_container = driver.find_element(By.ID, "shopping_cart_container")

    # Check if the span with the class "shopping_cart_badge" exists
    badge = cart_container.find_element(By.CLASS_NAME, "shopping_cart_badge")

    # Retrieve the badge text
    badge_text = badge.text

    # Compare with the expected count
    assert str(expected_count) == badge_text, f"Badge text mismatch: {badge_text} != {expected_count}"
    print(f"Badge text matches expected count: {badge_text}")

@keyword
def verify_product_sorting_by_text(driver, sort_text):
    """
    Verifies the product sorting on the webpage based on dropdown option text.

    :param driver: The WebDriver instance.
    :param sort_text: The visible text of the sorting option to select.
                      Options: "Name (A to Z)", "Name (Z to A)", "Price (low to high)", "Price (high to low)".
    :return: True if sorting is correct, raises an AssertionError otherwise.
    """

    # Locate the sorting dropdown and select the desired option by visible text
    sort_dropdown = Select(driver.find_element(By.CLASS_NAME, "product_sort_container"))
    sort_dropdown.select_by_visible_text(sort_text)

    # Wait for the page to refresh or the sort action to complete
    WebDriverWait(driver, 10).until(
        lambda d: d.find_element(By.CLASS_NAME, "inventory_list")
    )

    # Fetch all product names or prices based on the selected option
    inventory_items = driver.find_elements(By.CLASS_NAME, "inventory_item_description")
    if sort_text in ["Name (A to Z)", "Name (Z to A)"]:
        product_names = [item.find_element(By.CLASS_NAME, "inventory_item_name").text for item in inventory_items]
        if sort_text == "Name (A to Z)":
            assert product_names == sorted(product_names), "Products are not sorted alphabetically (A to Z)."
        elif sort_text == "Name (Z to A)":
            assert product_names == sorted(product_names, reverse=True), "Products are not sorted alphabetically (Z to A)."
    elif sort_text in ["Price (low to high)", "Price (high to low)"]:
        product_prices = [
            float(item.find_element(By.CLASS_NAME, "inventory_item_price").text.replace("$", ""))
            for item in inventory_items
        ]
        if sort_text == "Price (low to high)":
            assert product_prices == sorted(product_prices), "Products are not sorted by price (low to high)."
        elif sort_text == "Price (high to low)":
            assert product_prices == sorted(product_prices, reverse=True), "Products are not sorted by price (high to low)."

    print(f"Products are sorted correctly for the option: {sort_text}.")
    return True



