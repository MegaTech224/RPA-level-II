*** Settings ***
Documentation
...    Orders robots from RobotSpareBin Industries Inc.
...    Saves the order HTML receipt as a PDF file.
...    Saves the screenshot of the ordered robot.
...    Embeds the screenshot of the robot to the PDF receipt.
...    Creates ZIP archive of the receipts and the images.


*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Log    Done.


*** Keywords ***
Open the robot order website
    #ToDo: Implement your keyword here