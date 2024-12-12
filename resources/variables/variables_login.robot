*** Variables ***
${URL}       https://www.saucedemo.com/
${USERNAME_SUCCESS}  standard_user
${USERNAME_DOES_NOT_MATCH}      test
${USERNAME_LOCKED_OUT_USER}  locked_out_user
${USERNAME_PROBLEM_USER}  problem_user
${USERNAME_PERFORMANCE_GLITCH_USER}  performance_glitch_user
${USERNAME_ERROR_USER}  error_user
${USERNAME_VISUAL_USER}  visual_user
${PASSWORD}     secret_sauce

${ERROR_LOCKED_OUT_USER}    Epic sadface: Sorry, this user has been locked out.
${ERROR_WITHOUT_INFO}       Epic sadface: Username is required
${ERROR_WITHOUT_PASSWORD}       Epic sadface: Password is required
${ERROR_DOES_NOT_MATCH}       Epic sadface: Username and password do not match any user in this service
${INVENTORY_PAGE_URL}       inventory
