*** Settings ***
Library         SeleniumLibrary
Library         Collections  # To work with lists and dictionaries
Library         String
Resource        ../locators/YourCart.robot
Resource        ../locators/Common.robot
Resource        ../keywords/Products.robot

*** Keywords ***
Click "Checkout" Button
    Click Element           ${CHECKOUT_BUTTON}
    Page Should Contain     ${YOUR_INFORMATION_HEADER_TEXT}

Click "Continue Shopping" Button
    Click Element           ${CONTINUR_SHOPPING_BUTTON}
    Page Should Contain     ${PRODUCTS_HEADER_TEXT}

Verify Number Of Shopping Cart Badge
    [Arguments]     ${number_of_shopping_cart_badge}
    Element Text Should Be      ${SHOPPING_CART_BADGE_ICON}       ${number_of_shopping_cart_badge}

Click Shopping Cart Badge
    Click Element           ${SHOPPING_CART_BADGE_ICON}
    Page Should Contain     ${YOUR_CART_HEADER_TEXT}

Retrieve Product Data And Store In Dictionary
    [Arguments]         ${ignore_product_status}=True
    [Documentation]    This keyword retrieves product data from a webpage and stores it in a dictionary. The dictionary contains lists for each of the following keys:
    ...                 - `product_name`: List of product names.
    ...                 - `product_desc`: List of product descriptions.
    ...                 - `product_price`: List of product prices.
    ...                 - `product_status`: List of product button statuses as follows 1. Add to cart 2.Remove.
    ...                 - Can configure {ignore_product_status} if you don't want to retrieve product_status on overview page because it does not has this variable
    # Get all inventory items
    ${items_count}=     Common.Get Length Of Items      ${ITEMS_CART_LOCATOR}
    Log To Console      Get Length Of Items:${items_count}
    ${item_name}    ${item_desc}    ${item_price}    ${item_status}=    Create Items List

    FOR    ${index}    IN RANGE    1    ${items_count + 1}
        Log To Console      YourCartLoop:${index}
        ${name}=                 Common.Retrieve Name Item Text     ${index}        ${CART_ITEM_NAME_LOCATOR}
        Append To List           ${item_name}               ${name}
        ${desc}=                 Common.Retrieve Description Item Text     ${index}     ${CART_ITEM_DESC_LOCATOR}
        Append To List           ${item_desc}                       ${desc}
        ${price}=                Common.Retrieve price Item Text     ${index}       ${CART_ITEM_PRICE_LOCATOR}
        Append To List           ${item_price}                ${price}
        Run Keyword If           ${ignore_product_status}       Append Status To List    ${index}    ${item_status}
    END
    ${product_details_dict}=        Create Product in Dictionary    ${item_name}    ${item_desc}    ${item_price}   ${item_status}
    RETURN      ${product_details_dict}

Append Status To List
    [Arguments]    ${index}    ${item_status}
    ${status}=               Retrieve Status Item Text     ${index}     ${ITEM_STATUS_BUTTON}
    Append To List           ${item_status}               ${status}

Random Indices to Remove Products For Cart Page
    [Arguments]     ${product_selected}     ${number_product_removed}
    ${product_names}=    Get From Dictionary    ${product_selected}    product_name
    ${product_count}=    Get Length    ${product_names}
    Log To Console    Number of products On Your Cart: ${product_count}
    Run Keyword If    ${number_product_removed} > ${product_count}    Fail    Requested count (${number_product_removed}) exceeds available products (len(${product_selected})).
    @{random_indices_to_remove}=    Products.Random Indices To Select Products       ${product_selected}     ${number_product_removed}
    Log To Console    Random: ${random_indices_to_remove}
    RETURN      @{random_indices_to_remove}