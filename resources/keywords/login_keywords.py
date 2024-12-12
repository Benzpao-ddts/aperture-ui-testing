from robot.api.deco import keyword

@keyword
def check_error_message(driver, locator, error_expected):
    error_element = driver.find_element("css selector", locator)
    error_text = error_element.text
    assert error_text == error_expected, (
        f"Header do not match! Expected: {error_expected}, but got: {error_text}."
    )