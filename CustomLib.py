from robot.api.deco import keyword
from robot.api import logger


class CustomLib:
    @keyword('Get Token')
    def getToken(self, response: dict) -> str:
        logger.console(response.get('token'))
        return response.get('token')

    @keyword('Get BookingID')
    def getBookingId(self, response: dict) -> str:
        logger.console(response.get('bookingid'))
        return response.get('bookingid')