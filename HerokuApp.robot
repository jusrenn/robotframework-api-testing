*** Settings ***
Documentation    HerokuAPP API Tests
Library    RequestsLibrary
Library    CustomLib.py

*** Variables ***
${baseURL}      https://restful-booker.herokuapp.com
${token}    0
${bookingID}    0

*** Test Cases ***
Create Token
    [Documentation]    POST
    ${body}       Create Dictionary    username=admin    password=password123
    Create Session    herokuApp    ${baseURL}    verify=True
    ${response}    POST On Session    herokuApp    /auth    data=${body}
    ${resToken}    Get Token    ${response.json()}
    Set Global Variable    ${token}     ${resToken}

Create Booking
    [Documentation]    POST
    ${body}    Set Variable    {"firstname" : "Nimi", "lastname" : "Sukunimi", "totalprice" : 1234, "depositpaid" : true, "bookingdates" : {"checkin" : "2022-12-16", "checkout" : "2022-12-30"}, "additionalneeds" : "Breakfast"}
    ${header}    Create Dictionary    Content-Type=application/json
    Create Session    herokuApp    ${baseURL}    verify=True    headers=${header}
    ${respose}    POST On Session    herokuApp    /booking    data=${body}
    ${resBookingID}     Get BookingID    ${respose.json()}
    Set Global Variable    ${bookingID}    ${resBookingID}
    Status Should Be    200    ${respose}

Get Booking
    [Documentation]    GET
    ${header}    Create Dictionary    Content-Type=application/json
    Create Session    herokuApp    ${baseURL}    verify=True    headers=${header}
    ${response}    GET On Session    herokuApp    /booking/${bookingID}
    Status Should Be    200    ${response}

Update Booking
    [Documentation]    PUT
    ${header}    Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${token}
    ${body}    Set Variable    {"firstname" : "Uusi nimi", "lastname" : "Uusi sukunimi", "totalprice" : 111, "depositpaid" : true, "bookingdates" : {"checkin" : "2022-12-24", "checkout" : "2022-012-31"},"additionalneeds" : "Breakfast"}
    Create Session    herokuApp    ${baseURL}    verify=True    headers=${header}
    ${response}    PUT On Session    herokuApp    /booking/${bookingID}    data=${body}
    Status Should Be    200    ${response}

Delete Booking
    [Documentation]    DELETE
    ${header}    Create Dictionary    Content-Type=application/json    Cookie=token=${token}
    Create Session    herokuApp    ${baseURL}    verify=True    headers=${header}
    ${response}    DELETE On Session    herokuApp    /booking/${bookingID}
    Status Should Be    201    ${response}
