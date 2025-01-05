*** Settings ***
Library         SeleniumLibrary
Resource        Common.robot
Resource        ../locators/ShoppingCartBadge.robot

*** Keywords ***
Verify Number Of Shopping Cart Badge
    [Arguments]     ${number_of_shopping_cart_badge_expected}
    Element Text Should Be      ${NUMBER_SHOPPING_CART_BADGE_LOCATOR}       ${number_of_shopping_cart_badge_expected}

Click Shopping Cart Badge
    Click Element           ${NUMBER_SHOPPING_CART_BADGE_LOCATOR}
    Page Should Contain     ${YOUR_CART_HEADER_TEXT}
