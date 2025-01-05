*** Settings ***
Library         SeleniumLibrary
Library         Collections  # To work with lists and dictionaries
Resource        ../locators/Filters.robot

*** Keywords ***
Verify Filter Options Displayed
    [Documentation]     This keyword verifies that the filter options for a dropdown are displayed correctly based on the expected conditions.
    ...                 The keyword can check for default filter values (e.g., "Name (A to Z)") or any other specified filter option.
    [Arguments]     ${expected_text}
    Element Text Should Be      ${FILTERS_TEXT_LOCATOR}     ${expected_text}        Expected "${expected_text}" but the element "class=active_option" contained incorrect text!

Verify Product Sorting
    [Arguments]    ${product_dict}    ${condition}
    [Documentation]    Verifies if the products in the dictionary are sorted correctly based on the given condition.
    Log To Console      condition:${condition}
    # Determine the sorting condition
    ${sorted_list}=    Run Keyword If    '${condition}' == 'Name (A to Z)'    Sort List    ${product_dict['product_name']}
    ...    ELSE IF    '${condition}' == 'Name (Z to A)'    Sort List    ${product_dict['product_name']}    reverse=True
    ...    ELSE IF    '${condition}' == 'Price (low to high)'    Sort Prices Low To High    ${product_dict['product_price']}
    ...    ELSE IF    '${condition}' == 'Price (high to low)'    Sort Prices High To Low    ${product_dict['product_price']}
    ...    ELSE    Fail    Invalid condition provided: ${condition}

    # Get the original list to compare
    ${original_list}=    Run Keyword If    '${condition}' in ['Name (A to Z)', 'Name (Z to A)']    Set Variable    ${product_dict['product_name']}
    ...    ELSE    Set Variable    ${product_dict['product_price']}

    # Compare the sorted list with the original
    Log To Console      original_list:${original_list}
    Log To Console      sorted_list:${sorted_list}
    ${is_sorted}=    Evaluate    ${original_list} == ${sorted_list}
    Log To Console    Is sorted correctly: ${is_sorted}
    RETURN    ${is_sorted}

Set Sorting Error Message
    [Arguments]     ${condition_to_sort}
    ${error_message}=    Run Keyword If    '${condition_to_sort}' == 'Name (A to Z)'    Set Variable    Sorting by Name A to Z is incorrect!
    ...    ELSE IF    '${condition_to_sort}' == 'Name (Z to A)'    Set Variable    Sorting by Name Z to A is incorrect!
    ...    ELSE IF    '${condition_to_sort}' == 'Price (low to high)'    Set Variable    Sorting by Price low to high is incorrect!
    ...    ELSE IF    '${condition_to_sort}' == 'Price (high to low)'    Set Variable    Sorting by Price high to low is incorrect!
    ...    ELSE    Fail    Unknown sorting condition: ${condition_to_sort}
    RETURN    ${error_message}

Sort List
    [Arguments]    ${list}    ${key}=None    ${reverse}=False
    [Documentation]    Sorts a list with optional key and reverse arguments.
    ${sorted_list}=    Run Keyword If    ${key}    Evaluate    sorted(${list}, key=${key}, reverse=${reverse})
    ...    ELSE    Evaluate    sorted(${list}, reverse=${reverse})
    RETURN    ${sorted_list}

Select Filter Option By Text
    [Documentation]  Selects a dropdown option by its value.
    [Arguments]     ${condition_text}
    Select From List By Label    ${FILTERS_DROPDOWN_LOCATOR}    ${condition_text}

Sort Prices Low To High
    [Arguments]    ${price_list}
    ${converted_prices}=    Convert All Prices To Float    ${price_list}
    ${sorted_prices}=    Sort List    ${converted_prices}    reverse=False
    ${convert_to_correct_format}=        Add "$" To Each Value In List       ${sorted_prices}
    RETURN    ${convert_to_correct_format}

Sort Prices High To Low
    [Arguments]    ${price_list}
    ${converted_prices}=    Convert All Prices To Float    ${price_list}
    ${sorted_prices}=    Sort List    ${converted_prices}       reverse=True
    ${convert_to_correct_format}=        Add "$" To Each Value In List       ${sorted_prices}
    RETURN    ${convert_to_correct_format}

Convert All Prices To Float
    [Arguments]    ${price_list}
    [Documentation]    Converts a list of price strings (e.g., ['$29.99', '$9.99']) to floats.
    ${converted_list}=    Create List
    FOR    ${price}    IN    @{price_list}
        ${converted_price}=    Evaluate    float('${price}'.replace('$', ''))
        Append To List    ${converted_list}    ${converted_price}
    END
    Log To Console      converted_list:${converted_list}

    RETURN    ${converted_list}

Add "$" To Each Value In List
    [Arguments]    ${original_list}
    ${new_list}=    Create List
    FOR    ${value}    IN    @{original_list}
        ${new_value}=    Set Variable    $${value}
        Append To List    ${new_list}    ${new_value}
    END
    Log To Console      new_value:${new_value}

    RETURN    ${new_list}