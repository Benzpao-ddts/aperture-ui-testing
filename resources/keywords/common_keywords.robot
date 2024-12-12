*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     OperatingSystem
Resource        ../locators/common_locators.robot
Resource        ../variables/variables_login.robot

*** Keywords ***
Compare Texts
    [Arguments]     ${text_1}       ${text_2}
    Should Be Equal     ${text_1}       ${text_2}

Open Browser and Navigate to Login Page
    [Arguments]    ${url}
    Open Browser    ${url}    Chrome
    Maximize Browser Window

Input Login Credentials
    [Arguments]    ${username}    ${password}
    Input Text    ${LOGIN_PAGE_USERNAME}    ${username}
    Input Text    ${LOGIN_PAGE_PASSWORD}    ${password}

Click Login Button
    Click Element    ${LOGIN_PAGE_BUTTON}

Verify Navigation to Inventory Page
    Location Should Contain    ${INVENTORY_PAGE_URL}

Login Successfully
    [Arguments]     ${URL}      ${USERNAME}     ${PASSWORD}
    Open Browser and Navigate to Login Page    ${URL}
    Input Login Credentials    ${USERNAME}    ${PASSWORD}
    Click Login Button
    Verify Navigation to Inventory Page

Login Locked Out User
    [Arguments]     ${URL}      ${USERNAME}     ${PASSWORD}
    Open Browser and Navigate to Login Page    ${URL}
    Input Login Credentials    ${USERNAME}    ${PASSWORD}
    Click Login Button

Check Error Message Login Page
    [Arguments]     ${driver}       ${locator}      ${error_expected}
    Check Error Message     ${driver}       ${locator}      ${error_expected}

Click Shopping Cart Button
    Click Element    ${SHOPPING_CART_BUTTON}
    Log    Shopping cart button clicked successfully.

Click Checkout Button
    Click Element    ${CHECKOUT_BUTTON}
    Log    Checkout button clicked successfully.

Click Continue Button
    Click Element       ${CONTINUE_BUTTON}
    Log    Continue button clicked successfully.

Click Finish button
    Click Element       ${FINISH_BUTTON}
    Log    Finish button clicked successfully.

Click Back Home Button
    Click Element       ${BACK_HOME_BUTTON}
    Log    Back Home button clicked successfully.

Checkout Your Information
    [Arguments]    ${firstName}    ${lastName}      ${postalCode}
    Input Text      id=first-name       ${firstName}
    Input Text      id=last-name        ${lastName}
    Input Text      id=postal-code      ${postalCode}