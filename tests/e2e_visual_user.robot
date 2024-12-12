*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     ../resources/keywords/login_keywords.py
Library     ../resources/keywords/common_keywords.py
Library     ../resources/keywords/product_detail.py
Resource        ../resources/keywords/common_keywords.robot
Resource        ../resources/locators/common_locators.robot

Resource        ../resources/variables/variables_checkout_info.robot
Resource        ../resources/variables/variables_login.robot
Resource        ../resources/variables/variables_inventory.robot
*** Variables ***
${HEADER_LABEL_EXPECTED_PATH}        compare_images/header_label_expected.png
${HEADER_LABEL_ACTUAL_PATH}        compare_images/header_label.png
${HEADER_LABEL_DIFF_PATH}           compare_images/header_label_diff.png
*** Test Cases ***
Verify Incorrect Webpage Layout But Successful Product Purchase
    Login Successfully      ${URL}      ${USERNAME_VISUAL_USER}     ${PASSWORD}
    Capture Element Screenshot      ${HEADER_LABEL}     ${HEADER_LABEL_ACTUAL_PATH}
    Run Keyword And Ignore Error        Compare Images       ${HEADER_LABEL_EXPECTED_PATH}       ${HEADER_LABEL_ACTUAL_PATH}        ${HEADER_LABEL_DIFF_PATH}
    ${driver}=      Get WebDriver
    Verify Product Sorting By Text      ${driver}       ${SORTING_TYPE}
    ${inventory}=    Get Inventory List    ${driver}
    Log    ${inventory}
    ${inventory_selected}       Select Random Product And Compare       ${driver}       ${NUMBER_SELECTED}
    ${product_add_to_card}=       Click Add To Cart       ${driver}       ${inventory_selected}
    Log     ${product_add_to_card}
    Check And Get Cart Badge    ${driver}   ${NUMBER_SELECTED}
    Log    ${inventory_selected}
    ${product_removed}       Click Remove from Cart       ${driver}       ${inventory_selected}     ${REDUSE_NUMBER_SELECTED}
    Log     ${product_removed}
    Check And Get Cart Badge    ${driver}   ${REDUSE_NUMBER_SELECTED}
    Click Shopping Cart Button
    ${product_selected}=        Get List Difference     ${product_add_to_card}      ${product_removed}
    Log     ${product_selected}
    ${product_detail_from_cart}=        Get Product Names From Cart     ${driver}     ${product_selected}
    ${number_of_product}=       Evaluate        ${NUMBER_SELECTED} - ${REDUSE_NUMBER_SELECTED}
    Check And Get Cart Badge    ${driver}   ${number_of_product}
    Click Checkout Button
    Checkout Your Information       ${FIRSTNAME_INFO}        ${LASTNAME_INFO}        ${POSTAL_CODE_INFO}
    Click Continue Button
    ${product_detail_from_overview}=        Get Product Names From Overview     ${driver}      ${product_selected}
    Log     ${product_detail_from_overview}
    Check Item Total        ${driver}      ${product_detail_from_overview}
    Click Finish button
    Extract Text By Class Name       ${driver}     ${THANKYOU_TEXT}     Thank you for your order!
    Click Back Home Button
    Verify Navigation to Inventory Page
    Close Browser