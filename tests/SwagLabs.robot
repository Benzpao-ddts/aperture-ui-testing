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
    [Tags]          functional      login
    [Setup]         NONE
    [Template]      LoginApp.Verify Error Messages
    ${BROWSER}      ${EMPTY}                        ${PASSWORD}     ${ERROR_WITHOUT_INFO}
    ${BROWSER}      ${USERNAME_SUCCESS}             ${EMPTY}        ${ERROR_WITHOUT_PASSWORD}
    ${BROWSER}      ${USERNAME_LOCKED_OUT_USER}     ${PASSWORD}     ${ERROR_LOCKED_OUT_USER}
    ${BROWSER}      ${USERNAME_DOES_NOT_MATCH}      ${PASSWORD}     ${ERROR_DOES_NOT_MATCH}

Verify Login Page Response Time
    [Tags]          performance     login
    [Setup]         NONE
    [Template]      LoginApp.Login And Navigate To Product Page By Performance User
    ${BROWSER}      ${USERNAME_SUCCESS}              ${PASSWORD}
    ${BROWSER}      ${USERNAME_PERFORMANCE}          ${PASSWORD}

Verify the Correctness of Webpage Layout For Invalid Data
    [Tags]          layout     visual_user
    [Setup]         NONE
    LoginApp.Login And Navigate To Product Page By User        ${USERNAME_VISUAL}      ${PASSWORD}
    SwagLabsApp.Verify the Correctness of Webpage Layout

Verify Field Value After Input
    [Tags]          functional     error_user      your_information
    [Setup]         NONE
    LoginApp.Login And Navigate To Product Page By User         ${USERNAME_ERROR}       ${PASSWORD}
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Verify Your Information Value After Input       ${FIRST_NAME}           ${LAST_NAME}        ${POST_CODE}

Verify Product Selection Updates Cart Icon
    [Tags]    functional    product
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Verify Cart Icon Updates Correctly              ${NUMBER_PRODUCTS_SELECTED}

Verify Cart Icon Does Not Display a Number When No Items Are Selected
    [Tags]          functional     cart_icon
    SwagLabsApp.Verify Number Of Cart Icon Should Not Be Visible

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
    @{random_products_removed}=     SwagLabsApp.Remove Products To Your Cart By Random Indices      ${random_products}      ${NUMBER_PRODUCTS_REMOVED}
    ${remaining_products}=    Evaluate    ${NUMBER_PRODUCTS_SELECTED} - ${NUMBER_PRODUCTS_REMOVED}
    SwagLabsApp.Verify Cart Icon Updates Correctly      ${remaining_products}
    SwagLabsApp.Verify Product Status Changes To Add To Cart       @{random_products_removed}

Verify Navigation To Your Cart Page Using Icon
    [Tags]    functional    navigation     cart
    SwagLabsApp.Navigate To Your Cart Page

Verify Selected Products Appear In Your Cart Page
    [Tags]    functional    cart
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    ${products_selected}=   SwagLabsApp.Retrieve Products Selected
    SwagLabsApp.Navigate To Your Cart Page
    ${products_selected_your_cart}=        Retrieve Products Selected On Your Cart
    SwagLabsApp.Verify Product Details Matches Cart Ignoring Sorting        ${products_selected}        ${products_selected_your_cart}

Verify Navigation To Product Page From Cart
    [Tags]    functional    navigation    product
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Product Page From Your Cart

Verify Navigation To Your Information Page
    [Tags]    functional    navigation    your_information
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Verify Number Of Cart Icon Should Not Be Visible

Verify Navigation To Overview Page
    [Tags]    functional    navigation    overview
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Navigation To Overview Page

Verify Navigation To Thank You Page
    [Tags]    functional    navigation    thank_you
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Navigation To Overview Page
    SwagLabsApp.Nevigate To Thank You Page

Verify Removal Of Items From Cart
    [Tags]    functional    product
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Remove Products From Your Cart By Random Indices        ${NUMBER_PRODUCTS_REMOVED}

Validate That Subtotal Without Tax Matches the Sum of Selected Products
    [Tags]    functional    overview
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    ${products_selected}=   SwagLabsApp.Retrieve Products Selected
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Navigation To Overview Page
    SwagLabsApp.Verify Subtotal Without Tax     ${products_selected}

Validate That Subtotal Including Tax Matches the Sum of Selected Products
    [Tags]    functional    overview
    SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Navigate To Your Cart Page
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Navigation To Overview Page
    SwagLabsApp.Verify Total Including Tax

Validate End-to-End Purchase Flow Completes Successfully
    [Tags]    e2e
    SwagLabsApp.Verify Filter Options Text Displayed        ${SORTING_BY_DEFAULT}
    SwagLabsApp.Verify Products Are Sorted Correctly        ${SORTING_BY_DEFAULT}
    SwagLabsApp.Verify Number Of Cart Icon Should Not Be Visible
    SwagLabsApp.Select Filter Option By Condition           ${SORTING_BY_PRICE_LOW_TO_HIGH}
    SwagLabsApp.Verify Filter Options Text Displayed        ${SORTING_BY_PRICE_LOW_TO_HIGH}
    SwagLabsApp.Verify Products Are Sorted Correctly        ${SORTING_BY_PRICE_LOW_TO_HIGH}
    @{random_products}=     SwagLabsApp.Add Products To Your Cart By Random Indices     ${NUMBER_PRODUCTS_SELECTED}
    SwagLabsApp.Verify Product Status Changes To Remove     @{random_products}
    @{random_products_removed}=     SwagLabsApp.Remove Products To Your Cart By Random Indices      ${random_products}      ${NUMBER_PRODUCTS_REMOVED}
    ${remaining_products}=    Evaluate    ${NUMBER_PRODUCTS_SELECTED} - ${NUMBER_PRODUCTS_REMOVED}
    SwagLabsApp.Verify Cart Icon Updates Correctly      ${remaining_products}
    SwagLabsApp.Verify Product Status Changes To Add To Cart       @{random_products_removed}
    ${products_selected}=   SwagLabsApp.Retrieve Products Selected
    SwagLabsApp.Navigate To Your Cart Page
    ${selected_product_details_filtered}=   SwagLabsApp.Retrieve Products Selected
    SwagLabsApp.Verify Cart Icon Updates Correctly      ${remaining_products}
    ${products_selected_your_cart}=        Retrieve Products Selected On Your Cart
    SwagLabsApp.Verify Product Details Matches Cart Ignoring Sorting        ${products_selected}        ${products_selected_your_cart}
    SwagLabsApp.Nevigate To Your Information Page
    SwagLabsApp.Navigation To Overview Page
    SwagLabsApp.Verify Subtotal Without Tax     ${products_selected_your_cart}
    SwagLabsApp.Verify Total Including Tax
    SwagLabsApp.Nevigate To Thank You Page
