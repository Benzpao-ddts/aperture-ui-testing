*** Settings ***
Resource        ../resources/keywords/Login.robot
Resource        ../resources/variables/Login.robot

*** Keywords ***
Verify Error Messages
    [Documentation]    Attempts to log in with the given username and password, and verifies the displayed error message.
    ...                This keyword performs the following steps:
    ...                1. Inputs the provided username and password.
    ...                2. Clicks the login button.
    ...                3. Waits until the error message is visible on the page.
    ...                4. Compares the displayed error message with the expected error message to ensure correctness.
    ...                Arguments:
    ...                - username: The username to input in the login field.
    ...                - password: The password to input in the password field.
    ...                - error_message_expected: The expected error message text.

    [Arguments]         ${browser}      ${username}     ${password}     ${error_message_expected}
    Login.Open Browser To Login Page      ${browser}
    Login.Fill Username Field      ${username}
    Login.Fill Password Field      ${password}
    Login.Click "Login" Button
    Login.Verify Error Text        ${error_message_expected}

Login Successfully
    [Arguments]         ${browser}      ${username}     ${password}
    Login.Open Browser To Login Page      ${browser}
    Login.Fill Username Field      ${username}
    Login.Fill Password Field      ${password}
    Login.Click "Login" Button

Open Browser To Login Page
    Open Browser                ${URL}      ${BROWSER}
    Maximize Browser Window

Login And Navigate To Product Page
    Open Browser                   ${URL}                   ${BROWSER}
    Login.Fill Username Field      ${USERNAME_SUCCESS}
    Login.Fill Password Field      ${PASSWORD}
    Login.Click "Login" Button