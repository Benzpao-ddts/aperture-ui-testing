*** Variables ***
${BROWSER}                         chrome
${URL}                             https://www.saucedemo.com/
${PASSWORD}                        secret_sauce
${USERNAME_SUCCESS}                standard_user
${USERNAME_PERFORMANCE}            performance_glitch_user
${USERNAME_VISUAL}                 visual_user
${USERNAME_ERROR}                  error_user

${USERNAME_DOES_NOT_MATCH}         test
${USERNAME_LOCKED_OUT_USER}        locked_out_user
${PASSWORD}                        secret_sauce

${ERROR_LOCKED_OUT_USER}           Epic sadface: Sorry, this user has been locked out.
${ERROR_WITHOUT_INFO}              Epic sadface: Username is required
${ERROR_WITHOUT_PASSWORD}          Epic sadface: Password is required
${ERROR_DOES_NOT_MATCH}            Epic sadface: Username and password do not match any user in this service

${LOAD_TIME_EXPECTED}              3
${DATE_FORMAT}                     %Y-%m-%d %H:%M:%S