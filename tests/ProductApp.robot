*** Settings ***
Resource        ../resources/LoginApp.robot
Resource        ../resources/keywords/Products.robot
Resource        ../resources/keywords/Filters.robot
Resource        ../resources/keywords/YourCart.robot
Resource        ../resources/keywords/Common.robot
Resource        ../resources/keywords/YourInformation.robot
Resource        ../resources/keywords/Overview.robot


*** Variables ***
${BROWSER}=                      chrome
${URL}                           https://www.saucedemo.com/
${USERNAME_SUCCESS}=             standard_user
${PASSWORD}=                     secret_sauce
${NUMBER_PRODUCTS_SELECTED}=     4
${NUMBER_PRODUCTS_REMOVED}=      2
${SORTING_BY_DEFAULT}=           Name (A to Z)
${CONDITION_TO_SORT}=            Name (Z to A)
${FIRST_NAME}=                   Benz
${LAST_NAME}=                    Ddts
${POST_CODE}=                    10310

*** Test Cases ***
Retrieve Product On Web Page
#    Set selenium speed       .2s
    LoginApp.Login Successfully        ${BROWSER}      ${USERNAME_SUCCESS}     ${PASSWORD}
    ${product_details_by_default_dict}=        Products.Retrieve Product Data And Store In Dictionary
    Log To Console    Item names: ${product_details_by_default_dict}
    Filters.Verify Filter Options Displayed        ${SORTING_BY_DEFAULT}
    ${is_sorted}=       Filters.Verify Product Sorting      ${product_details_by_default_dict}     ${SORTING_BY_DEFAULT}
    Log To Console      is_sorted:${is_sorted}
    Should Be True      ${is_sorted}    Sorting by Name A to Z is incorrect!
    Filters.Select Filter Option by Text       ${CONDITION_TO_SORT}
    Filters.Verify Filter Options Displayed        ${CONDITION_TO_SORT}
    ${product_details_sorted_dict}=        Products.Retrieve Product Data And Store In Dictionary
    @{random_products}=         Products.Random Indices To Select Products        ${product_details_sorted_dict}      ${NUMBER_PRODUCTS_SELECTED}
    Log To Console              selected_products:@{random_products}
    ${products_selected}=       Products.Add Products To Your Cart        @{random_products}
    ShoppingCartBadge.Verify Number Of Shopping Cart Badge        ${NUMBER_PRODUCTS_SELECTED}
    ${product_details_dict}=            Products.Retrieve Product Data And Store In Dictionary
    Log To Console                      product_details_dict:${product_details_dict}
    @{random_to_remove_products}=       Products.Random Indices to Remove Products        ${random_products}      ${NUMBER_PRODUCTS_REMOVED}
    Log To Console            random_to_remove_products:${random_to_remove_products}
    Products.Remove Products To Your Cart       @{random_to_remove_products}
    ${remaining_products}=    Evaluate    ${NUMBER_PRODUCTS_SELECTED} - ${NUMBER_PRODUCTS_REMOVED}
    Log To Console      REMAINING_PRODUCTS:${remaining_products}
    ${product_details_remaining_dict}=          Products.Retrieve Product Data And Store In Dictionary
    ${product_details_slected_filted_dict}=     Products.Filter Products By Status       ${product_details_remaining_dict}   'Remove'
    YourCart.Verify Number Of Shopping Cart Badge        ${remaining_products}
    YourCart.Click Shopping Cart Badge
    ${product_details_your_cart}=     YourCart.Retrieve Product Data And Store In Dictionary
    Log To Console      product_details_your_cart:${product_details_your_cart}
    Common.Verify Product Selected On Product With Your Cart Page Ignoring Sorting    ${product_details_slected_filted_dict}    ${product_details_your_cart}
    YourCart.Click "Checkout" Button
    YourInformation.Fill Information        ${FIRST_NAME}       ${LAST_NAME}        ${POST_CODE}
    ${product_details_overview}=        YourCart.Retrieve Product Data And Store In Dictionary      False
    Common.Verify Product Selected On Your Cart With Overview Page Ignoring Product Status      ${product_details_your_cart}    ${product_details_overview}
    ${products_prices}=     Overview.Sum Product Prices     ${product_details_overview}
    Log To Console          products_prices:${products_prices}
    Overview.Verify Total Of Products Without Tax        ${products_prices}
    Overview.Verify Total Of Products Incould Tax

# Daft
#*** Test Cases ***
#
## Functional Tests: Login Page
#Verify Successful Login
#    [Tags]    functional    login
#    Input Credentials And Login
#    Verify User Is Redirected To Product Page
#
#Verify Error Message For Invalid Login
#    [Tags]    functional    login
#    Input Invalid Credentials
#    Verify Login Error Message
#

#

#Verify Removal Of Items From Cart
#    [Tags]    functional    cart
#    Login And Navigate To Product Page
#    Select Multiple Products
#    Navigate To Cart Page
#    Remove A Product
#    Verify Cart Updates Correctly
#


## Functional Tests: Your Information Page
#Verify Validation For Missing Information
#    [Tags]    functional    information
#    Login And Navigate To Your Information Page
#    Click Continue Without Filling Information
#    Verify Validation Message For Missing Information
#


#Verify Navigation Back To Cart Page
#    [Tags]    functional    navigation    information
#    Login And Navigate To Your Information Page
#    Click Cancel
#    Verify User Is Redirected To Cart Page
#
## Functional Tests: Overview Page
#Verify Product Details On Overview Page
#    [Tags]    functional    overview
#    Login And Navigate To Overview Page
#    Verify Product Details Match Selection
#
#Verify Price Breakdown And Total
#    [Tags]    functional    overview
#    Login And Navigate To Overview Page
#    Verify Item Total Matches Sum Of Prices
#    Verify Tax Amount Is Correct
#    Verify Total Price Includes Tax
#
#Verify Navigation Back To Your Information Page
#    [Tags]    functional    navigation    overview
#    Login And Navigate To Overview Page
#    Click Cancel
#    Verify User Is Redirected To Your Information Page
#
#Verify Navigation To Thank You Page
#    [Tags]    functional    navigation    overview
#    Login And Navigate To Overview Page
#    Click Finish
#    Verify User Is Redirected To Thank You Page
#
## End-to-End Tests
#E2E Verify Product Purchase Flow
#    [Tags]    e2e
#    Login As A User
#    Select Multiple Products
#    Navigate To Cart Page
#    Verify Selected Products In Cart
#    Navigate To Your Information Page
#    Fill Information Completely
#    Navigate To Overview Page
#    Verify Price Breakdown And Total
#    Complete Purchase
#    Verify Order Confirmation Page
#
#E2E Verify Cart And Navigation Functionality
#    [Tags]    e2e
#    Login As A User
#    Select Multiple Products
#    Navigate To Cart Page
#    Remove Some Products
#    Verify Cart Updates
#    Navigate To Your Information Page
#    Verify Cancel Navigation To Cart
#    Navigate To Overview Page
#    Verify Cancel Navigation To Information Page
#    Complete Purchase
#
#*** Keywords ***
#
## Login Page Keywords
#Open Browser To Login Page
#    Open Browser    ${URL}    ${BROWSER}
#    Maximize Browser Window
#
#Input Credentials And Login
#    Input Text    id:username    ${USERNAME}
#    Input Text    id:password    ${PASSWORD}
#    Click Button    id:login-button
#
#Input Invalid Credentials
#    Input Text    id:username    invalid_user
#    Input Text    id:password    wrong_password
#    Click Button    id:login-button
#
#Verify Login Error Message
#    Element Text Should Be    id:error-message    Invalid credentials
#
#Verify User Is Redirected To Product Page
#    Wait Until Element Is Visible    id:product-page-title
#
## Product Page Keywords
#Login And Navigate To Product Page
#    Input Credentials And Login
#    Verify User Is Redirected To Product Page
#
#Select A Product
#    Click Element    css:.inventory_item:nth-of-type(1) .btn_primary
#
#Verify Cart Icon Updates Correctly
#    Element Text Should Be    id:cart-badge    1
#
#Verify Product Status Changes To Remove
#    Element Text Should Be    css:.inventory_item:nth-of-type(1) .btn_secondary    Remove
#
#Sort Products By Name A To Z
#    Select From List By Label    id:sort-products    Name (A to Z)
#
#Verify Products Are Sorted Correctly
#    ${products}=    Get WebElements    css:.inventory_item_name
#    FOR    ${product}    IN    @{products}
#        Log To Console    ${product.text}
#    END
#
#Remove A Product
#    Click Element    css:.inventory_item:nth-of-type(1) .btn_secondary
#
## Cart Page Keywords
#Navigate To Cart Page
#    Click Element    id:shopping_cart_container
#
#Click Back To Product Page
#    Click Element    id:back-to-products
#
#Click Next To Your Information Page
#    Click Element    id:next-page
#
## Your Information Page Keywords
#Fill Information Completely
#    Input Text    id:first-name    John
#    Input Text    id:last-name    Doe
#    Input Text    id:postal-code    12345
#    Click Button    id:continue-button
#
## Overview Page Keywords
#Verify Item Total Matches Sum Of Prices
#    ${total_price}=    Get Text    id:item-total
#    ${calculated_total}=    Calculate Sum Of Product Prices
#    Should Be Equal    ${total_price}    ${calculated_total}