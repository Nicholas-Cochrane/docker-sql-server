from aiohttp import web
import logging
import psycopg2

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s %(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)

f = open("pass.txt", "r")
dbpass = f.read()
f.close()

logger.info(dbpass)

conn = psycopg2.connect(dbname="sensors", user="postgres", password= dbpass, host="db")

logger.info("HELLO WORLD!")

async def getResponse(request):
    return web.Response(text="This URL is primaraly for POST. This is not a page.")

async def processSensorReadings(request: web.Request) -> web.Response:
    """Process JSON from Airgradient """
    sensor_id = request.match_info["sensor_id"]
    logger.info(sensor_id)
    try:
        readings = await request.json()
        cur = con.cursor()
        for k,v in readings.items():
            logger.info(k)
            logger.info(v)
            logger.info(type(v))

            cur.close()
    except ValidationError:
        logger.error("Bad request from %s: %s", sensor_id, await request.text())
        return web.Response(status=400)
    
    return web.Response()

app = web.Application()
app.add_routes([web.get('/', getResponse),
                web.post('/', processSensorReadings),
                web.post("/sensors/airgradient:{sensor_id:[a-f0-9]{12}}/measures", processSensorReadings)])

web.run_app(app)

