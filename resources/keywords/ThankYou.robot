*** Settings ***
Library         SeleniumLibrary
Resource        ../locators/ThankYou.robot
Resource        ../locators/Common.robot

*** Keywords ***
Click "Finish" Button
    Click Button            ${FINISH_BUTTON}
    Page Should Contain     ${THANK_YOU_TEXT}

Click "Back Home" Button
    Click Button            ${BACK_HOME_BUTTON}
    Page Should Contain     ${PRODUCT_HEADER_TEXT}