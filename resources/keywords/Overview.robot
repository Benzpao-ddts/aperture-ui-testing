*** Settings ***
Library         SeleniumLibrary
Resource        ../locators/Overview.robot
Resource        ../locators/ThankYou.robot

*** Keywords ***
Click "Finish" Button
    Click Button        ${FINISH_BUTTON}
    Page Should Contain     ${THANK_YOU_TEXT}

Click "Cancel" Button
    Click Button            ${CANCEL_BUTTON}
    Page Should Contain     ${YOUR_CART_HEADER_TEXT}

Sum Product Prices
    [Arguments]     ${product_dict}
    ${prices}=    Get From Dictionary    ${product_dict}    product_price
    ${sum}=    Evaluate     0
    FOR    ${price}    IN    @{prices}
        ${numeric_price}=    Evaluate    float('${price}'.strip('$'))
        ${sum}=    Evaluate    ${sum} + ${numeric_price}
    END
    ${sum}=    Evaluate    round(${sum}, 2)
    RETURN    ${sum}

Verify Total Of Products Without Tax
    [Arguments]     ${total_from_calculate}
    ${item_total}=      Retrieve Number From Text       ${ITEM_SUB_TOTAL_LOCATOR}
    Should Be Equal     ${total_from_calculate}     ${item_total}

Retrieve Number From Text
    [Arguments]     ${locator}
    ${text}=    Get Text    ${locator}
    ${matches}=    Should Match Regexp	    ${text}    \\d+.\\d+
    ${round_2digit}=    Evaluate    round(${matches}, 2)
    RETURN      ${round_2digit}

Verify Total Of Products Incould Tax
    ${item_total}=                      Retrieve Number From Text       ${ITEM_SUB_TOTAL_LOCATOR}
    ${tax}=                             Retrieve Number From Text       ${TAX_LOCATOR}
    ${total_incould_tax_retrieve}=      Retrieve Number From Text       ${ITEM_TOTAL_LOCATOR}
    ${total_incould_tax_calculate}=     Evaluate                        round(${item_total} + ${tax},2)
    Should Be Equal     ${total_incould_tax_retrieve}     ${total_incould_tax_calculate}