*** Settings ***
Documentation
...    Orders robots from RobotSpareBin Industries Inc.
...    Saves the order HTML receipt as a PDF file.
...    Saves the screenshot of the ordered robot.
...    Embeds the screenshot of the robot to the PDF receipt.
...    Creates ZIP archive of the receipts and the images.
Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.HTTP
Library    RPA.Tables


*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    Log    ${orders}

*** Keywords ***
Open the robot order website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Get orders
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=${True}    target_file=${OUTPUT DIR}${/}orders.csv
    ${orders}=    Read table from CSV            ${OUTPUT DIR}${/}orders.csv    header=${True}
    RETURN    ${orders}