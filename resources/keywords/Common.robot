*** Settings ***
Library         SeleniumLibrary
Library         BuiltIn
Resource        ../locators/Common.robot

*** Keywords ***
Verify Product Selected On Product With Your Cart Page Ignoring Sorting
    [Arguments]    ${products_selected_product_page}    ${products_selected_your_cart_page}
    ${is_equal}=    Run Keyword And Return Status    Compare Dicts Ignoring Order    ${products_selected_product_page}    ${products_selected_your_cart_page}
    Should Be True      ${is_equal}     Products was selected on Product Page is not equal with Your Cart Page!
    Run Keyword If    not ${is_equal}    Fail    Dicts do not match (ignoring order)

Compare Dicts Ignoring Order
    [Arguments]    ${products_selected_product_page}    ${products_selected_your_cart_page}
    ${is_match}=    Evaluate    ${products_selected_product_page['product_name']} == ${products_selected_your_cart_page['product_name']} and ${products_selected_product_page['product_desc']} == ${products_selected_your_cart_page['product_desc']} and ${products_selected_product_page['product_price']} == ${products_selected_your_cart_page['product_price']} and ${products_selected_product_page['product_status']} == ${products_selected_your_cart_page['product_status']}
    RETURN    ${is_match}

Verify Product Selected
    [Arguments]    ${products_selected_product_page}    ${products_selected_your_cart_page}
    Should Be Equal     ${products_selected_product_page}       ${products_selected_your_cart_page}

Verify Product Selected On Your Cart With Overview Page Ignoring Product Status
    [Arguments]    ${products_selected_your_cart_page}    ${products_selected_overview_page}
    Remove From Dictionary    ${products_selected_your_cart_page}    product_status
    Remove From Dictionary    ${products_selected_overview_page}     product_status
    Should Be Equal           ${products_selected_your_cart_page}    ${products_selected_overview_page}

Create Items List
    @{item_name}=       Create List
    @{item_desc}=       Create List
    @{item_price}=      Create List
    @{item_status}=     Create List
    RETURN      ${item_name}       ${item_desc}     ${item_price}       ${item_status}


Get Length Of Items
    [Arguments]     ${locator}
    # Get all inventory items
    ${items}=    Get WebElements    ${locator}
    # Get the length of the list of items
    ${items_count}=    Get Length    ${items}
    RETURN      ${items_count}

Retrieve Name Item Text
    [Arguments]         ${index}        ${locator}
    ${item_locator}=    Set Variable      ${locator.replace('{index}', str(${index}))}
    ${item_text}=                 Get Text          ${item_locator}
    RETURN      ${item_text}

Retrieve Description Item Text
    [Arguments]         ${index}        ${locator}
    ${item_locator}=    Set Variable      ${locator.replace('{index}', str(${index}))}
    ${item_text}=                 Get Text          ${item_locator}
    RETURN      ${item_text}

Retrieve Price Item Text
    [Arguments]         ${index}        ${locator}
    ${item_locator}=    Set Variable      ${locator.replace('{index}', str(${index}))}
    ${item_text}=                 Get Text          ${item_locator}
    RETURN      ${item_text}

Retrieve Status Item Text
    [Arguments]         ${index}        ${locator}
    ${item_locator}=    Set Variable      ${locator.replace('{index}', str(${index}))}
    ${item_text}=                 Get Text          ${item_locator}
    RETURN      ${item_text}

Verify Status Button Text Is "Remove"
    ${status_button_text}=      Get Text          ${ITEM_STATUS_BUTTON}
    Should Be Equal     ${status_button_text}     ${REMOVE_TEXT_BUTTON}

Verify Status Button Text Is "Add to cart"
    ${status_button_text}=      Get Text          ${ITEM_STATUS_BUTTON}
    Should Be Equal     ${status_button_text}     ${ADD_TO_CART_TEXT_BUTTON}