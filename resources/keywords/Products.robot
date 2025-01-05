*** Settings ***
Library         SeleniumLibrary
Library         Collections  # To work with lists and dictionaries
Library         String
Resource        ../locators/Products.robot
Resource        Common.robot

*** Keywords ***
Retrieve Product Data And Store In Dictionary
    [Documentation]    This keyword retrieves product data from a webpage and stores it in a dictionary. The dictionary contains lists for each of the following keys:
    ...                 - product_name: List of product names.
    ...                 - product_desc: List of product descriptions.
    ...                 - product_price: List of product prices.
    ...                 - product_status: List of product button statuses as follows 1. Add to cart 2.Remove.
    ${items_count}=     Common.Get Length Of Items      ${ITEMS_LOCATOR}
    # Create a list to store details
    ${item_name}    ${item_desc}    ${item_price}    ${item_status}=    Common.Create Items List

    FOR    ${index}    IN RANGE    1    ${items_count + 1}
        ${name}=                 Common.Retrieve Name Item Text            ${index}       ${ITEM_NAME_LOCATOR}
        Append To List           ${item_name}                              ${name}
        ${desc}=                 Common.Retrieve Description Item Text     ${index}       ${ITEM_DESCRIPTION_LOCATOR}
        Append To List           ${item_desc}                              ${desc}
        ${price}=                Common.Retrieve price Item Text           ${index}       ${ITEM_PRICE_LOCATOR}
        Append To List           ${item_price}                             ${price}
        ${status}=               Common.Retrieve Status Item Text          ${index}       ${ITEM_STATUS_BUTTON}
        Append To List           ${item_status}                            ${status}
    END
    ${product_details_dict}=        Create Product in Dictionary    ${item_name}    ${item_desc}    ${item_price}   ${item_status}
    RETURN      ${product_details_dict}

Create Product in Dictionary
    [Documentation]    This keyword creates a product dictionary with keys like product name, description, price, and status.
    [Arguments]            ${item_names}    ${item_desc}    ${item_price}   ${item_status}
    ${product_details}=    Create Dictionary
    # Inserting a key and a list value
    Set To Dictionary    ${product_details}    product_name    ${item_names}
    Set To Dictionary    ${product_details}    product_desc    ${item_desc}
    Set To Dictionary    ${product_details}    product_price    ${item_price}
    Set To Dictionary    ${product_details}    product_status    ${item_status}
    RETURN               ${product_details}

Random Indices To Select Products
    [Arguments]    ${product_dict}    ${number_product_to_select}
    [Documentation]    Randomly selects a specified number of products from the product list.
    ${product_names}=    Get From Dictionary    ${product_dict}    product_name
    Run Keyword If    ${number_product_to_select} > len(${product_names})    Fail    Requested count (${number_product_to_select}) exceeds available products (${len(${product_names})}).
    # Select random indices
    @{random_indices}=    Evaluate    random.sample(range(1, len(${product_names})), ${number_product_to_select})    modules=random
    RETURN    @{random_indices}

Random Indices to Remove Products
    [Arguments]     ${product_selected}     ${number_product_removed}
    Run Keyword If    ${number_product_removed} > len(${product_selected})    Fail    Requested count (${number_product_removed}) exceeds available products (len(${product_selected})).
    # Remove random indices
    @{random_indices_to_remove}=    Evaluate    random.sample(${product_selected}, ${number_product_removed})    modules=random
    RETURN      @{random_indices_to_remove}

Add Products To Your Cart
    [Arguments]     @{random_products}
    FOR    ${item}    IN    @{random_products}
        Click Element               ${ITEM_STATUS_BUTTON.replace('{index}', str(${item}))}
    END

Remove Products From Your Cart
    [Arguments]     @{random_products_to_remove}
    FOR    ${item}    IN    @{random_products_to_remove}
        Click Element               ${ITEM_STATUS_BUTTON.replace('{index}', str(${item}))}
        END

Filter Products By Status
    [Arguments]    ${product_dict}    ${status_condition}
    ${indices_to_keep}=    Evaluate    [index for index, status in enumerate(${product_dict['product_status']}) if status == ${status_condition}]
    ${item_name}    ${item_desc}    ${item_price}    ${item_status}=    Create Items List
    FOR    ${index}    IN    @{indices_to_keep}
        Append To List           ${item_name}       ${product_dict['product_name'][${index}]}
        Append To List           ${item_desc}        ${product_dict['product_desc'][${index}]}
        Append To List           ${item_price}       ${product_dict['product_price'][${index}]}
        Append To List           ${item_status}      ${product_dict['product_status'][${index}]}
    END
    ${filtered_product_dict}=        Create Product in Dictionary    ${item_name}    ${item_desc}    ${item_price}   ${item_status}
    RETURN    ${filtered_product_dict}





