*** Settings ***
Library         SeleniumLibrary
Resource        ../locators/YourInformation.robot

*** Keywords ***
Fill Information
    [Arguments]     ${first_name}       ${last_name}        ${post_code}
    Fill First Name Field       ${first_name}
    Fill Last Name Field        ${last_name}
    Fill Post Code Field        ${post_code}

Fill First Name Field
    [Arguments]     ${first_name}
    Input Text      ${FIRST_NAME_LOCATOR}     ${first_name}

Fill Last Name Field
    [Arguments]     ${last_name}
    Input Text      ${LAST_NAME_LOCATOR}     ${last_name}

Fill Post Code Field
    [Arguments]     ${post_code}
    Input Text      ${POST_CODE_LOCATOR}     ${post_code}

Click "Continue" Button
    Click Button            ${CONTINUE_BUTTON}
    Page Should Contain     ${OVERVIEW_HEADER_TEXT}

Click "Cancel" Button
    Click Button            ${CANCEL_BUTTON}
    Page Should Contain     ${YOUR_CART_HEADER_TEXT}
