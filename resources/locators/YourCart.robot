*** Variables ***
${ITEMS_CART_LOCATOR}=               css:.cart_item
${ITEMS_CART_CLASS}=                 item_pricebar
${CHECKOUT_BUTTON}=                  id=checkout
${CONTINUR_SHOPPING_BUTTON}=         id=continue-shopping
${SHOPPING_CART_BADGE_ICON}=         id=shopping_cart_container
${CART_ITEM_NAME_LOCATOR}=           xpath://div[@class='cart_list']/div[contains(@class, 'cart_item')][{index}]//div[@class='inventory_item_name']
${CART_ITEM_DESC_LOCATOR}=           xpath://div[@class='cart_list']/div[contains(@class, 'cart_item')][{index}]//div[@class='inventory_item_desc']
${CART_ITEM_PRICE_LOCATOR}=          xpath://div[@class='cart_list']/div[contains(@class, 'cart_item')][{index}]//div[@class='inventory_item_price']
${YOUR_INFORMATION_HEADER_TEXT}=     Checkout: Your Information
${YOUR_CART_HEADER_TEXT}=            Your Cart