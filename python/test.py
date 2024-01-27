from aiohttp import web
import logging
import psycopg2

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s %(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)

logger.info("Begin Script")

stringi = """INSERT INTO \"readings\" (\"id\", \"sensor\", \"value\", \"time\") VALUES 
            (\'{mac}\', \'{sensor}\', \'{value}\', now());"""
stringf = """INSERT INTO \"readings\" (\"id\", \"sensor\", \"value\", \"time\") VALUES 
            (\'{mac}\', \'{sensor}\', \'{value:.1f}\', now());"""

f = open("pass.txt", "r")
dbpass = f.read()
f.close()
dbpass = dbpass[0:-1] #remove newline char

#logger.info('"' + dbpass + '"')

#if you have trouble connecting to server in docker try adding the lines
#pg_hba.conf < host all all all md5
#postgresql.conf < listen_adresses = '*'
conn = psycopg2.connect(dbname="sensors", user="postgres", password=dbpass, host="db")

logger.info("Connected to DB")

async def getResponse(request):
    return web.Response(text="This URL is primaraly for POST. This is not a page.")

async def processSensorReadings(request: web.Request) -> web.Response:
    """Process JSON from Airgradient """
    sensor_id = request.match_info["sensor_id"]
    logger.info(sensor_id)
    try:
        readings = await request.json()
        cur = conn.cursor()
        for k,v in readings.items():
#            logger.info(k)
#            logger.info(v)
#            logger.info(type(v))
            if(type(v) == int and k != "boot"):
                cur.execute(stringi.format(mac=sensor_id, sensor=k, value=v))
            elif(type(v) == float and k != "boot"):
                cur.execute(stringf.format(mac=sensor_id, sensor=k, value=v))
        cur.close()
        conn.commit()
    except ValidationError:
        logger.error("Bad request from %s: %s", sensor_id, await request.text())
        return web.Response(status=400)
    
    return web.Response()

app = web.Application()
app.add_routes([web.get('/', getResponse),
                web.post('/', processSensorReadings),
                web.post("/sensors/airgradient:{sensor_id:[a-f0-9]{12}}/measures", processSensorReadings)])

web.run_app(app)

