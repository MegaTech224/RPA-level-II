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
    Close the annoying modal
    ${orders}=    Get orders
    Input the orders for all the robots    ${orders}


*** Keywords ***
Open the robot order website
    Open Browser    https://robotsparebinindustries.com/#/robot-order    edge

Get orders
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=${True}    target_file=${OUTPUT DIR}${/}orders.csv
    @{orders}=    Read table from CSV            ${OUTPUT DIR}${/}orders.csv    header=${True}
    RETURN    @{orders}

Close the annoying modal
    Click Button    OK
    Wait Until Element Is Not Visible    //div[@class='modal-content']

Build and order a robot
    [Arguments]    ${Head}    ${Body}    ${Legs}    ${Address}
    Select From List By Value    //*[@id="head"]    ${Head}
    Click Element    //input[@id='id-body-${Body}']
    Input Text    //input[@placeholder='Enter the part number for the legs']    ${Legs}
    Input Text    //input[@id='address']    ${Address}
    Click Button    Preview
    Wait Until Element Is Visible    //div[@id='robot-preview-image']
    Click Button    Order
    Wait Until Keyword Succeeds    5x    1 sec    Check for and resolve alert

Input the orders for all the robots
    [Arguments]    ${orders}
    FOR    ${order}    IN    @{orders}
        Build and order a robot    ${order}[Head]    ${order}[Body]    ${order}[Legs]    ${order}[Address]
        Wait Until Element Is Visible    //div[@id='receipt']
        Click Button    Order another robot
        Close the annoying modal
    END

Check for and resolve alert
    # Expected Server Error; Server Feeling Slightly Sick Error; Who Came Up With These Annoying Errors?!, Bear In Server Room Error (Order)
    ${alert}=    Is Element Visible    //div[@class='alert alert-danger']
    IF    ${alert}
        ${alertmessage}=    Get Text    //div[@class='alert alert-danger']
        Log    ${alertmessage}
        Click Button    //*[@id="order"]
        Element Should Not Be Visible    //div[@class='alert alert-danger']
    END