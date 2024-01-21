from aiohttp import web
import logging

def get_module_logger(mod_name):
    """
    To use this, do logger = get_module_logger(__name__)
    """
    logger = logging.getLogger(mod_name)
    handler = logging.StreamHandler()
    formatter = logging.Formatter(
        '%(asctime)s [%(name)-12s] %(levelname)-8s %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
    return logger

if __name__ == "__main__":
    get_module_logger(__name__).info("HELLO WORLD!")

async def getResponse(request):
    return web.Response(text="This URL is primaraly for POST. This is not a page.")

async def processSensorReadings(request: web.Request) -> web.Response:
    """Process JSON from Airgradient """
    try:
        readings = await request.json()
        get_module_logger(__name__).info(readings)
    except ValidationError:
        logger.error("Bad request from %s: %s", sensor_id, await request.text())
        return web.Response(status=400)
    
    return web.Response()

app = web.Application()
app.add_routes([web.get('/', getResponse),
                web.post('/', processSensorReadings),
                web.post("/sensors/airgradient:{sensor_id:[a-f0-9]{12}}/measures", processSensorReadings)])

web.run_app(app)

