*** Settings ***
Library         SeleniumLibrary
Resource        ../locators/Login.robot

*** Keywords ***
Fill Username Field
    [Arguments]     ${username}
    Input Text      ${LOGIN_USERNAME_LOCATOR}     ${username}

Fill Password Field
    [Arguments]     ${password}
    Input Text      ${LOGIN_PASSWORD_LOCATOR}     ${password}

Click "Login" Button
    Click Button        ${LOGIN_LOGIN_BUTTON}

Verify Error Text
    [Arguments]     ${error_message_expected}
    Wait Until Element Is Visible       ${LOGIN_ERROR_LOCATOR}
    Element Text Should Be              ${LOGIN_ERROR_LOCATOR}        ${error_message_expected}

Open Browser To Login Page
    [Arguments]     ${browser}
    Open Browser        ${URL}      ${browser}
    Maximize Browser Window
