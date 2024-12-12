*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     ../resources/keywords/common_keywords.py
Resource        ../resources/keywords/common_keywords.robot
Resource        ../resources/locators/common_locators.robot
Resource        ../resources/variables/variables_login.robot

*** Test Cases ***
Login Unsuccessfully By Locked Out User
    Login Locked Out User   ${URL}      ${USERNAME_LOCKED_OUT_USER}     ${PASSWORD}
    ${driver}=      Get WebDriver
    ${error_text}=      Get Element Text     ${driver}       xpath      ${ERROR_LOGIN_PAGE}
    Compare Texts     ${error_text}       ${ERROR_LOCKED_OUT_USER}
    Close Browser

Login Unsuccessfully Without Info
    Open Browser and Navigate to Login Page     ${URL}
    Click Login Button
    ${driver}=      Get WebDriver
    ${error_text}=      Get Element Text     ${driver}       xpath      ${ERROR_LOGIN_PAGE}
    Compare Texts     ${error_text}       ${ERROR_WITHOUT_INFO}
    Close Browser

Login Unsuccessfully Without Password
    Open Browser and Navigate to Login Page     ${URL}
    Input Text    ${LOGIN_PAGE_USERNAME}    ${USERNAME_SUCCESS}
    Click Login Button
    ${driver}=      Get WebDriver
    ${error_text}=      Get Element Text     ${driver}       xpath      ${ERROR_LOGIN_PAGE}
    Compare Texts     ${error_text}       ${ERROR_WITHOUT_PASSWORD}
    Close Browser

Login Unsuccessfully By Does Not Match
    Login Locked Out User   ${URL}      ${USERNAME_DOES_NOT_MATCH}     ${PASSWORD}
    ${driver}=      Get WebDriver
    ${error_text}=      Get Element Text     ${driver}       xpath      ${ERROR_LOGIN_PAGE}
    Compare Texts     ${error_text}     ${ERROR_DOES_NOT_MATCH}
    Close Browser
