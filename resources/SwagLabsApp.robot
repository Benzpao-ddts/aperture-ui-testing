*** Settings ***
Resource        ../resources/keywords/Filters.robot
Resource        ../resources/keywords/Products.robot
Resource        ../resources/keywords/ShoppingCartBadge.robot
Resource        ../resources/keywords/YourCart.robot
Resource        ../resources/keywords/YourInformation.robot
Resource        ../resources/keywords/Overview.robot
Resource        ../resources/variables/TopNav.robot
Library         ../resources/keywords/Common.py

*** Keywords ***
Verify Your Information Value After Input
    [Arguments]     ${first_name}       ${last_name}        ${post_code}
    YourInformation.Fill Information        ${first_name}       ${last_name}        ${post_code}
    YourInformation.Verify First Name Field Value After Input       ${first_name}
    YourInformation.Verify Last Name Field Value After Input        ${last_name}
    YourInformation.Verify Post Code Field Value After Input        ${post_code}

Verify the Correctness of Webpage Layout
    Compare Images       ${HEADER_LABEL_EXPECTED_PATH}       ${HEADER_LABEL_ACTUAL_PATH}        ${HEADER_LABEL_DIFF_PATH}

Verify Filter Options Text Displayed
    [Arguments]     ${text_expected}
    Filters.Verify Filter Options Displayed     ${text_expected}

Verify Products Are Sorted Correctly
    [Arguments]     ${condition_to_sort}
    ${product_details_by_default_dict}=     Products.Retrieve Product Data And Store In Dictionary
    ${is_sorted}=       Filters.Verify Product Sorting       ${product_details_by_default_dict}     ${condition_to_sort}
    ${error_message}=   Filters.Set Sorting Error Message    ${condition_to_sort}
    Should Be True      ${is_sorted}    ${error_message}

Select Filter Option By Condition
    [Arguments]     ${condition_to_sort}
    Filters.Select Filter Option By Text        ${condition_to_sort}

Retrieve Products Selected
    ${products_dict}=          Products.Retrieve Product Data And Store In Dictionary
    ${selected_product_details_filtered}=     Products.Filter Products By Status       ${products_dict}   'Remove'
    RETURN      ${selected_product_details_filtered}

Retrieve Products Selected On Your Cart
    ${products_dict_selected}=          YourCart.Retrieve Product Data And Store In Dictionary
    RETURN      ${products_dict_selected}

Add Products To Your Cart By Random Indices
    [Arguments]     ${number_to_selected}
    ${product_details_sorted_dict}=        Products.Retrieve Product Data And Store In Dictionary
    @{random_products}=         Products.Random Indices To Select Products        ${product_details_sorted_dict}      ${number_to_selected}
    Products.Add Products To Your Cart        @{random_products}
    RETURN      @{random_products}

Verify Product Status Changes To Remove
    [Arguments]     @{random_products}
    FOR    ${item}    IN    @{random_products}
    Element Text Should Be      ${ITEM_STATUS_BUTTON.replace('{index}', str(${item}))}       ${REMOVE_TEXT_BUTTON}
    END

Verify Product Status Changes To Add To Cart
    [Arguments]     @{random_products}
    FOR    ${item}    IN    @{random_products}
    Element Text Should Be      ${ITEM_STATUS_BUTTON.replace('{index}', str(${item}))}       ${ADD_TO_CART_TEXT_BUTTON}
    END

Verify Cart Icon Updates Correctly
    [Arguments]     ${number_to_selected}
    ShoppingCartBadge.Verify Number Of Shopping Cart Badge      ${number_to_selected}

Navigate To Your Cart Page
    YourCart.Click Shopping Cart Badge

Nevigate To Product Page From Your Cart
    YourCart.Click "Continue Shopping" Button

Nevigate To Your Information Page
    YourCart.Click "Checkout" Button


Navigation To Overview Page
    YourInformation.Fill Information       ${FIRST_NAME}       ${LAST_NAME}        ${POST_CODE}
    YourInformation.Click "Continue" Button

Nevigate To Thank You Page
    Overview.Click "Finish" Button

Remove Products To Your Cart By Random Indices
    [Arguments]     ${product_list}     ${number_to_selected}
    Log To Console      product_list:${product_list}
    @{random_to_remove_products}=         Products.Random Indices to Remove Products        ${product_list}      ${number_to_selected}
    Products.Remove Products From Your Cart       @{random_to_remove_products}
    RETURN      @{random_to_remove_products}

Should Be Nevigate to Your Information Page
    YourCart.Click "Checkout" Button

Should Be Nevigate to Overview Page
    YourInformation.Fill Information        ${FIRST_NAME}       ${LAST_NAME}        ${POST_CODE}
    YourInformation.Click "Continue" Button

Should Be Nevigate to Your Cart Page
    YourInformation.Click "Cancel" Button



# Use to be [Setup] to verify information detail on the page
Prepare Test Environment For Overview Page Details
    LoginApp.Login Successfully
    Add Products To Your Cart By Random Indices
    Navigate To Overview Page

Verify Product Details Matches Cart Ignoring Sorting
    [Arguments]     ${product_details_your_cart}        ${selected_product_details_filtered}
    Common.Verify Product Selected On Product With Your Cart Page Ignoring Sorting        ${selected_product_details_filtered}        ${product_details_your_cart}

#Verify Cart Updates Correctly
#    [Arguments]     ${selected_product_details_filtered}    ${number_expected}
#    ${number_of_products}=      Count Product Name Length       ${selected_product_details_filtered}
#    Should Be Equal     ${number_of_products}       ${number_expected}

Count Product Name Length
    [Arguments]     ${product_details}
    ${product_names}=    Get From Dictionary    ${product_details}    product_name
    ${product_count}=    Get Length    ${product_names}
    Log To Console    Number of products: ${product_count}
    RETURN      ${product_count}

Verify Subtotal Without Tax
    [Arguments]     ${product_selected}
    ${products_prices}=     Overview.Sum Product Prices      ${product_selected}
    Overview.Verify Total Of Products Without Tax            ${products_prices}

Verify Total Including Tax
    Overview.Verify Total Of Products Incould Tax

Verify Cart Updates Correctly
    [Arguments]     ${number_of_items_expected}
    ${number_of_items_actual}=      YourCart.Get Number of Products in Cart
    ${value_actual}=    Convert To String    ${number_of_items_actual}
    Should Be Equal     ${number_of_items_expected}       ${value_actual}

Remove Products From Your Cart By Random Indices
    [Arguments]     ${number_product_removed}
    ${product_in_your_cart}=         YourCart.Retrieve Product Data And Store In Dictionary
    ${number_all_product}=           Count Product Name Length       ${product_in_your_cart}
    YourCart.Remove Products From Your Cart                ${number_product_removed}
    ${number_product_expected}=       Evaluate             ${number_all_product} - ${number_product_removed}
    ${number_product_expected}=       Convert To String    ${number_product_expected}
    Verify Cart Updates Correctly       ${number_product_expected}

Verify Number Of Cart Icon Should Not Be Visible
    Element Should Not Be Visible       ${NUMBER_SHOPPING_CART_BADGE_LOCATOR}

