*** Settings ***
Library         SeleniumLibrary
Resource        ../locators/YourInformation.robot

*** Keywords ***
Verify First Name Field Value After Input
    [Arguments]     ${first_name}
    ${displayed_first_name_value}=    Get Value     ${FIRST_NAME_LOCATOR}
    Should Be Equal As Strings    ${displayed_first_name_value}    ${first_name}

Verify Last Name Field Value After Input
    [Arguments]     ${last_name}
    ${displayed_last_name_value}=     Get Value     ${LAST_NAME_LOCATOR}
    Should Be Equal As Strings    ${displayed_last_name_value}    ${last_name}

Verify Post Code Field Value After Input
    [Arguments]     ${post_code}
    ${displayed_post_code_value}=     Get Value     ${POST_CODE_LOCATOR}
    Should Be Equal As Strings    ${displayed_post_code_value}    ${post_code}

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
    Click Button                   ${CONTINUE_BUTTON}
    Wait Until Page Contains       ${OVERVIEW_HEADER_TEXT}     timeout=1.5s

Click "Cancel" Button
    Click Button                   ${CANCEL_BUTTON}
    Wait Until Page Contains       ${YOUR_CART_HEADER_TEXT}     timeout=1.5s
