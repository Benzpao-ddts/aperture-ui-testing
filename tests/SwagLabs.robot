*** Settings ***
Library             SeleniumLibrary
Resource            ../resources/SwagLabsApp.robot
Resource            ../resources/LoginApp.robot
Resource            ../resources/variables/Login.robot
Resource            ../resources/variables/YourInformation.robot
Resource            ../resources/variables/filters.robot
Test Setup          LoginApp.Login And Navigate To Product Page
Test Teardown       Close Browser

*** Test Cases ***
Verify Error Message on Login with Different Users
    [Tags]          functional Login
    [Setup]         NONE
    [Teardown]      Close Browser
    [Template]      LoginApp.Verify Error Messages
    ${BROWSER}      ${EMPTY}                        ${PASSWORD}     ${ERROR_WITHOUT_INFO}
    ${BROWSER}      ${USERNAME_SUCCESS}             ${EMPTY}        ${ERROR_WITHOUT_PASSWORD}
    ${BROWSER}      ${USERNAME_LOCKED_OUT_USER}     ${PASSWORD}     ${ERROR_LOCKED_OUT_USER}
    ${BROWSER}      ${USERNAME_DOES_NOT_MATCH}      ${PASSWORD}     ${ERROR_DOES_NOT_MATCH}

Verify Product Selection Updates Cart Icon
    [Tags]    functional    product
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Verify Cart Icon Updates Correctly              ${NUMBER_PRODUCTS_SELECTED}

Verify Product Status Change On Selection
    [Tags]    functional    product
    @{random_products}=     SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Verify Product Status Changes To Remove     @{random_products}

Verify Product Sorting By Default
    [Tags]    functional    filters
    SwagLabsApp.Verify Filter Options Text Displayed        ${SORTING_BY_DEFAULT}
    SwagLabsApp.Verify Products Are Sorted Correctly        ${SORTING_BY_DEFAULT}

Verify Product Sorting By Name Z To A
    [Tags]    functional    filters
    SwagLabsApp.Select Filter Option By Condition           ${SORTING_BY_NAME}
    SwagLabsApp.Verify Filter Options Text Displayed        ${SORTING_BY_NAME}
    SwagLabsApp.Verify Products Are Sorted Correctly        ${SORTING_BY_NAME}

Verify Product Sorting By Price Low To High
    [Tags]    functional    filters
    SwagLabsApp.Select Filter Option By Condition           ${SORTING_BY_PRICE_LOW_TO_HIGH}
    SwagLabsApp.Verify Filter Options Text Displayed        ${SORTING_BY_PRICE_LOW_TO_HIGH}
    SwagLabsApp.Verify Products Are Sorted Correctly        ${SORTING_BY_PRICE_LOW_TO_HIGH}

Verify Product Sorting By Price High To Low
    [Tags]    functional    filters
    SwagLabsApp.Select Filter Option By Condition           ${SORTING_BY_PRICE_HIGH_TO_LOW}
    SwagLabsApp.Verify Filter Options Text Displayed        ${SORTING_BY_PRICE_HIGH_TO_LOW}
    SwagLabsApp.Verify Products Are Sorted Correctly        ${SORTING_BY_PRICE_HIGH_TO_LOW}

Verify Product Removal Updates Cart
    [Tags]    functional    product
    @{random_products}=     SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Verify Product Status Changes To Remove     @{random_products}
    ${random_products_removed}=     SwagLabsApp.Remove Products To Your Cart By Random Indices      ${random_products}      ${NUMBER_PRODUCTS_REMOVED}
    ${remaining_products}=    Evaluate    ${NUMBER_PRODUCTS_SELECTED} - ${NUMBER_PRODUCTS_REMOVED}
    SwagLabsApp.Verify Cart Icon Updates Correctly      ${remaining_products}
    SwagLabsApp.Verify Product Status Changes To Add To Cart

Verify Navigation To Your Cart Page Using Icon
    [Tags]    functional    navigation
    SwagLabsApp.Navigate To Your Cart Page
    Sleep       3s

Verify Selected Products Appear In Your Cart Page
    [Tags]    functional    cart
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    ${selected_product_details_filtered}=   SwagLabsApp.Retrieve Products Selected
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Verify Product Details Matches Cart Ignoring Sorting        ${selected_product_details_filtered}

Verify Navigation To Product Page From Cart
    [Tags]    functional    navigation    cart
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate to Product Page From Your Cart

Verify Navigation To Your Information Page
    [Tags]    functional    navigation    cart
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate to Your Information Page

Verify Navigation To Overview Page
    [Tags]    functional    navigation    cart
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate to Your Information Page
    SwagLabsApp.Navigation To Overview Page